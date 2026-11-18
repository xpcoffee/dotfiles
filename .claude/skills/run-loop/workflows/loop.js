export const meta = {
  name: 'run-loop',
  description: 'Each iteration: an optimizer (Opus, high effort) plans, an implementer (Sonnet) does the work, an evaluator (Opus, low effort) scores it; stop when the checks pass or the budget runs out.',
  whenToUse: 'Called by the run-loop skill with args { loopDir, workdir, maxIterations, bestRef, artefact: "code" | "text" }.',
  phases: [{ title: 'Iterate' }, { title: 'Review packet' }],
}

// The runtime can hand args over as a JSON string.
const input = typeof args === 'string' ? JSON.parse(args) : (args || {})
const { loopDir, workdir } = input
const maxIterations = input.maxIterations || 3
let bestRef = input.bestRef || null
// Subagents may not write report files, so a loop whose result is not code carries it as text.
const textMode = input.artefact === 'text' || (!input.bestRef && input.artefact !== 'code')
let bestArtefact = null

// One place to change who runs each role. The script passes these explicitly so they hold
// on the general-purpose fallback too, where the agent definition's frontmatter does not apply.
const ROLES = {
  optimizer: { agent: 'loop-optimizer', model: 'opus', effort: 'high' },
  implementer: { agent: 'loop-implementer', model: 'sonnet' },
  evaluator: { agent: 'loop-evaluator', model: 'opus', effort: 'low' },
}

const PLAN_SCHEMA = {
  type: 'object',
  properties: {
    status: { type: 'string', enum: ['brief', 'blocked'] },
    diagnosis: { type: 'string' },
    targeted_checks: { type: 'array', items: { type: 'string' } },
    restore_ref: { type: 'string' },
    brief: { type: 'string' },
    blocked_decision: { type: 'string' },
  },
  required: ['status', 'diagnosis'],
}

const IMPLEMENTER_SCHEMA = {
  type: 'object',
  properties: {
    status: { type: 'string', enum: ['done', 'blocked'] },
    targeted_checks: { type: 'array', items: { type: 'string' } },
    summary: { type: 'string' },
    commit: { type: 'string' },
    artefact: { type: 'string' },
    concerns: { type: 'string' },
    blocked_decision: { type: 'string' },
  },
  required: ['status', 'summary'],
}

const EVALUATOR_SCHEMA = {
  type: 'object',
  properties: {
    checks: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          verdict: { type: 'string', enum: ['pass', 'fail', 'unknown'] },
          evidence: { type: 'string' },
        },
        required: ['id', 'verdict', 'evidence'],
      },
    },
    trend: { type: 'string', enum: ['first', 'improved', 'same', 'regressed'] },
    gaming_suspected: { type: 'boolean' },
    gaming_evidence: { type: 'string' },
    feedback: { type: 'string' },
  },
  required: ['checks', 'trend', 'gaming_suspected', 'feedback'],
}

// Agent types register at session start. A general-purpose stand-in would carry none of the
// loop agents' guard hooks, so a session that cannot see them stops instead.
async function roleAgent(roleName, prompt, opts) {
  const role = ROLES[roleName]
  const settings = { ...opts, model: role.model, ...(role.effort ? { effort: role.effort } : {}) }
  try {
    return await agent(prompt, { ...settings, agentType: role.agent })
  } catch (e) {
    if (!String(e).includes('not found')) throw e
    throw new Error(`agent type ${role.agent} is not registered in this session; start a new Claude Code session and run the loop again`)
  }
}

const REVIEW_SCHEMA = {
  type: 'object',
  properties: {
    intent: { type: 'string' },
    outcome: { type: 'string', enum: ['met', 'partly', 'not-met'] },
    how_met: {
      type: 'array',
      items: {
        type: 'object',
        properties: { need: { type: 'string' }, how: { type: 'string' }, checks: { type: 'array', items: { type: 'string' } } },
        required: ['need', 'how', 'checks'],
      },
    },
    not_met: { type: 'array', items: { type: 'string' } },
    risk: {
      type: 'object',
      properties: {
        level: { type: 'string', enum: ['low', 'medium', 'high'] },
        summary: { type: 'string' },
        items: {
          type: 'array',
          items: {
            type: 'object',
            properties: { risk: { type: 'string' }, impact: { type: 'string' }, likelihood: { type: 'string' }, reversal: { type: 'string' } },
            required: ['risk', 'impact', 'likelihood', 'reversal'],
          },
        },
      },
      required: ['level', 'summary', 'items'],
    },
    unverified: { type: 'array', items: { type: 'string' } },
    assumptions: { type: 'array', items: { type: 'string' } },
    decisions: { type: 'array', items: { type: 'string' } },
  },
  required: ['intent', 'outcome', 'how_met', 'not_met', 'risk', 'unverified', 'assumptions', 'decisions'],
}

phase('Iterate')
const history = []
let lastEval = null
let stalled = 0
let stopReason = 'budget'

const summarise = h => ({
  iteration: h.iteration,
  targeted: h.plan.targeted_checks,
  diagnosis: h.plan.diagnosis,
  implementer: h.work && h.work.summary,
  trend: h.evaluation && h.evaluation.trend,
  failing: h.evaluation ? h.evaluation.checks.filter(c => c.verdict !== 'pass').map(c => c.id) : [],
})

for (let i = 1; i <= maxIterations; i++) {
  const plan = await roleAgent('optimizer',
    `Plan loop iteration ${i} of ${maxIterations}.
Charter: ${loopDir}/charter.md (do not read ${loopDir}/holdout.md).
Working directory: ${workdir}.
Best ref so far: ${bestRef || 'none'}.
${textMode ? `Best draft so far: ${bestArtefact ? '\n' + bestArtefact : 'none yet'}\n` : ''}History of earlier iterations: ${history.length ? JSON.stringify(history.map(summarise)) : 'none, this is the first iteration'}.
Last evaluation in full: ${lastEval ? JSON.stringify({ trend: lastEval.trend, failing: lastEval.checks.filter(c => c.verdict !== 'pass'), feedback: lastEval.feedback }) : 'none'}.`,
    { label: `optimize ${i}`, schema: PLAN_SCHEMA },
  )
  if (!plan) { stopReason = 'optimizer-failed'; break }
  if (plan.status === 'blocked') {
    history.push({ iteration: i, plan, work: null, evaluation: null })
    stopReason = 'blocked'
    break
  }

  const work = await roleAgent('implementer',
    `Carry out loop iteration ${i}.
Charter: ${loopDir}/charter.md (do not read ${loopDir}/holdout.md).
Working directory: ${workdir}.
${textMode ? `This loop's result is text. Return the complete artefact in \`artefact\`; do not write it to a file. Start from the best draft: ${bestArtefact ? '\n' + bestArtefact + '\n' : 'none yet.\n'}` : ''}${plan.restore_ref && !textMode ? `Restore ${plan.restore_ref} first.\n` : ''}Brief from the optimizer, targeting ${(plan.targeted_checks || []).join(', ')}:
${plan.brief}`,
    { label: `implement ${i}`, schema: IMPLEMENTER_SCHEMA },
  )
  if (!work) { stopReason = 'implementer-failed'; break }
  if (work.status === 'blocked') {
    history.push({ iteration: i, plan, work, evaluation: null })
    stopReason = 'blocked'
    break
  }

  const evaluation = await roleAgent('evaluator',
    `Score loop iteration ${i}.
Charter: ${loopDir}/charter.md. Hold-out checks: ${loopDir}/holdout.md.
Working directory: ${workdir}.
Implementer report: ${JSON.stringify({ ...work, artefact: undefined })}.
${textMode ? `The artefact to score:\n${work.artefact || '(the implementer returned no artefact)'}` : ''}
Previous evaluation: ${lastEval ? JSON.stringify(lastEval) : 'none, report trend "first"'}.`,
    { label: `evaluate ${i}`, schema: EVALUATOR_SCHEMA },
  )
  if (!evaluation) { stopReason = 'evaluator-failed'; break }

  history.push({ iteration: i, plan, work, evaluation })
  const passed = evaluation.checks.filter(c => c.verdict === 'pass').length
  const unknown = evaluation.checks.filter(c => c.verdict === 'unknown').length
  // An unknown verdict keeps the loop from passing but is not evidence of a regression.
  const allPass = evaluation.checks.length > 0 && passed === evaluation.checks.length
  log(`iteration ${i}: ${passed}/${evaluation.checks.length} checks pass, ${unknown} unknown, trend ${evaluation.trend}`)

  if (evaluation.trend === 'first' || evaluation.trend === 'improved') {
    if (work.commit) bestRef = work.commit
    if (textMode && work.artefact) bestArtefact = work.artefact
    stalled = 0
  } else {
    stalled++
  }
  lastEval = evaluation

  if (evaluation.gaming_suspected === true) { stopReason = 'gaming-suspected'; break }
  if (allPass) { stopReason = 'checks-pass'; break }
  if (stalled >= 2) { stopReason = 'no-progress'; break }
}

phase('Review packet')
const review = await roleAgent('optimizer',
  `Write the review packet for this finished loop, for its owner to judge without reading the work.
Charter: ${loopDir}/charter.md (do not read ${loopDir}/holdout.md: the final evaluation below already scores the hidden checks, with evidence).
Working directory: ${workdir}. Best ref: ${bestRef || 'none'}. Stopped because: ${stopReason}.
${textMode ? `The result:\n${bestArtefact || 'none'}` : ''}
History: ${JSON.stringify(history.map(summarise))}.
Final evaluation: ${lastEval ? JSON.stringify(lastEval) : 'none'}.
- intent: the charter's intent in two or three sentences, in the owner's terms.
- how_met: one row per part of the intent, saying what in the result meets it and which check IDs back it. A part with no passing check goes in not_met.
- risk: judge the change itself, not the loop. For code: what the diff can break, for whom, how likely, and how to undo it. For a report or plan: what a reader could get wrong by acting on it. Set the level by the worst item.
- unverified: what no check covered.
- decisions: anything the owner must decide before accepting, including escalations from the history.
The owner reads this packet instead of the result, so every text field must make sense with the result closed. Before writing, read ~/.claude/skills/writing-style/skills/output-brief/SKILL.md, its exemplars.md, and the files in ~/.claude/prose-trial/exemplars/, and plan the Brief they describe for that reader. Say what each item is and what it affects; never point into the result by number, section name, check ID or file name, and introduce any term the owner has not met.`,
  { label: 'review packet', schema: REVIEW_SCHEMA },
)

return {
  stopReason, bestRef, bestArtefact, iterations: history.length,
  history,
  // Evidence comes from the evaluator verbatim, so the packet's author cannot restate it.
  review: review && { ...review, stop_reason: stopReason, iterations: history.length, checks: lastEval ? lastEval.checks : [] },
}
