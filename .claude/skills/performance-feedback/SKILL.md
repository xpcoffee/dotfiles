---
name: performance-feedback
description: Critique the user's professional performance over a week of work. Spawns cheap (haiku) subagents to gather evidence from the user's configured sources (chat, code reviews authored and given, work items, journal), then synthesises an evidence-only report in the main conversation: notable moments tagged against the user's 6-month goals plus baseline dimensions, signal per dimension, and gaps. No verdicts – the user draws conclusions. On first run, interviews the user to define 6-month goals and writes them to notes. Trigger on "run my weekly feedback", "critique my week", "performance feedback", "how did I do last week", "review my performance", "update my 6-month goals".
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent, AskUserQuestion
---

# Performance feedback

Produce an **evidence-only report** of the user's professional performance for a one-week window. The report is raw material the user turns into their own conclusions; the skill does not write feedback, a verdict, or advice.

## Config (read first)

Read `references/work-config.md` for identity (name, email), notes repo path, output paths, and the evidence sources with their connector commands. This file is per-user and gitignored; the rest of the skill is general. If it is missing, tell the user the skill needs it and what it must contain: an identity block, a notes repo path, and at least one evidence source. Do not invent values.

**Arguments:** $ARGUMENTS

- `refresh goals` / `update goals` → run the goals interview (`references/goals-interview.md`) and stop; no report.
- A date or range → use it as the window.
- Empty → default window: the most recent **complete Monday→Sunday week**.

## Model split (non-negotiable)

- **Gathering** (step 2): subagents with `model: haiku`. Mechanical extraction, no judgement.
- **Synthesis** (steps 3–5): the **main conversation**. Never delegate tagging, coverage assessment, or gap analysis to a subagent or a smaller model.

## Output

A single file at the report path in `work-config.md` (ISO week of the window's Monday, e.g. `feedback/<YYYY>-W<ww>.md`), in the shape of `templates/report.template.md`. Three `##` headings, exactly: `## Notable moments`, `## Signal per dimension`, `## What I didn't see`. The entire report is a bullet list the user scans.

## Workflow

### Step 1 – Goals file

Read the goals file named in `work-config.md`.

- **Missing** → run the interview in `references/goals-interview.md`, write the file, then continue.
- **Horizon passed or within 4 weeks** (frontmatter `horizon:`) → tell the user, offer a refresh, continue with the current file either way.
- **User declines the interview** → continue with baseline dimensions only and flag it in the report header.

**Dimensions for this run** = one per `## Goal:` heading in the goals file, **plus** the three baseline dimensions in `references/baseline-dimensions.md` (communication, code quality, follow-through). The goals file owns the goal dimensions – never hardcode them here.

### Step 2 – Gather evidence (parallel haiku subagents)

Read `references/gathering.md`. Spawn one gatherer per source listed in `work-config.md`, **all in a single message** so they run concurrently, each via the Agent tool with `subagent_type: "general-purpose"` and `model: "haiku"`.

Each gatherer prompt = the per-source brief from `references/gathering.md` + that source's commands from `work-config.md` + the window dates + the output contract. Gatherers return **facts only**: no judgements, no filtering for tone, flattering and unflattering items alike.

A gatherer returning null or an auth error is a **coverage gap, not a blocker**: record it in the report header (`sources:` line) and continue. Never silently present a partial week as complete.

### Step 3 – Extract notable moments

A notable moment **materially changes how you read a dimension**. Include only:

- **Strong on its own** – caught a production risk in review, missed an agreed deadline, unblocked someone else's work, shipped without the agreed observability, drove a decision to closure in a thread.
- **A weaker signal that repeats** – the same pattern two or three times across the week (review comments left unanswered, PRs opened without linked work items, threads started but not closed). **Group repeats into a single pattern bullet listing all instances.**

Drop weak singletons; they are noise. **Target 8–15 bullets** for a normal week. Shape: one bullet per moment, single sentence – date(s), factual description with the artefact link, then dimension tag(s) in backticks:

- `- Tue + Thu – Sent decision summaries after the planning syncs naming owners per action ([thread](...)). [communication+]`
- `- Mon, Wed, Fri – Three PRs merged without review comments addressed in follow-up commits ([Repo#1234](...), ...). [code quality-] [follow-through-]`

Verbatim quotes inline in double quotes when the phrasing carries the signal. **Asks vs does: do not conflate.** "Said he would X" is tagged as a commitment; tag `[follow-through+]` only when you can point to the artefact where X happened. If you cannot point to it, write the commitment, not the completion.

### Step 4 – Coverage and gaps

**Signal per dimension** – one bullet per dimension (goals first, then baseline): coverage level (**strong / mixed / thin / absent**) plus half a sentence on what was observed. Specific over generic.

**What I didn't see** – every dimension at thin/absent, plus expected-activity gaps (a goal with zero artefacts this week, reviews given but none received, no work-item hygiene signal). Each gap: one line, then `Would have looked like:` and a concrete illustration grounded in **this week's actual work**. If the previous report (from the journal gatherer) flagged the same gap, append `(also <prev-week>)`.

### Step 5 – Self-check, then write

Scan the draft against `references/style.md`. Non-negotiables: no verdicts or advice, no unsupported causal claims, no emotive adverbs, no adverbial disjuncts, every quote real, every tag pointing at a moment, people as `@firstname-lastname` matching `people/` files. Then write the report file and print a one-line summary: window, moment count, dimensions at thin/absent, coverage gaps.

## Failure modes

- **A connector is unauthenticated** (chat/M365 often is in headless runs) → mark the source ✗ in the header, continue. If two or more sources fail, ask the user whether a report this thin is worth writing.
- **Sparse week** (leave, mostly meetings) → say so in the header; do not pad moments to hit the target count.
- **User asks for a verdict or "what should I do"** → out of scope; the report is raw material. Point at the moments and gaps and let them conclude.
- **Re-run for the same week** → overwrite the existing report file (idempotent), note that the previous version is in git history.

## References

- `references/work-config.md` – per-user identity, paths, and source connectors (gitignored).
- `references/gathering.md` – per-source gatherer briefs and the output contract.
- `references/baseline-dimensions.md` – the three fixed dimensions with green/red signals.
- `references/goals-interview.md` – first-run / refresh goal elicitation.
- `references/style.md` – writing rules for the report.
- `templates/report.template.md` – report skeleton.
- `templates/goals.template.md` – goals file skeleton.
