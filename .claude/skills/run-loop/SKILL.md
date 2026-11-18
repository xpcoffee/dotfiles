---
name: run-loop
description: Run a larger task (implement, fix, investigate, plan, research) as a loop with an explicit intent, checks that measure it, and three agents per iteration: an optimizer that plans, an implementer that does the work, and an evaluator that scores it, in the background. The default for a task with a definition of done that one pass is unlikely to meet, or one that will run while the user is away. Trigger on "loop this", "run this as a loop", "implement/fix/investigate/plan X" when the work is more than a quick lookup, and when another skill hands over a task with a clear definition of done.
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent, Workflow, Skill
---

# Run a loop

Turn a task into three explicit parts, then iterate until the checks pass or the budget runs out, while the user does something else.

- **Intent**: the outcome the user wants, in their words, plus what is out of scope.
- **Checks**: how we measure the intent. Verifiable checks run a command with a pass condition. Judged checks name the evidence an evaluator must cite. Hold-out checks are judged checks the optimizer and implementer never see.
- **Roles**: each iteration runs three agents, with models set in `workflows/loop.js` under `ROLES`.
  - `loop-optimizer` (Opus, high effort) reads the history and the last evaluation, diagnoses the shortfall, and writes a brief.
  - `loop-implementer` (Sonnet) carries out the brief.
  - `loop-evaluator` (Opus, low effort) scores the result against the checks.

Loop state lives in `~/.claude/loops/<YYYY-MM-DD>-<slug>/`: `charter.md`, `holdout.md`, `ledger.jsonl`, `outcome.json`, and the artefact for non-code tasks.

## 1. Write the charter

Copy `references/charter.template.md` to the loop directory and fill it from the request.

- Take the intent from the user's words. Read `references/intent-exemplars.md` first: each entry is a past intent that produced the wrong result and the version that would have produced the right one.
- Start the checks from the task type's defaults in `references/checks-library.md`, then add checks specific to this intent. Prefer a verifiable check whenever a command can decide it. For a text result, write the command to read the artefact on standard input (`grep -c 'openai\.com' -`), because the file does not exist until the loop ends. Every check in the library carries the loop it came from; keep that.
- Put one or two checks in `holdout.md` that test the purpose behind the intent rather than its wording, for example "a reviewer unfamiliar with the ticket can follow the change" or "the root cause explains the first occurrence, not just the latest". The charter names the file; a guard hook on the optimizer and implementer blocks any tool call that names it.
- For code, create a worktree for the loop (`git worktree add`) and record its path as the working directory. Record the starting SHA as the first best ref.
- For a text result, make the loop directory a git repository (`git init`) and commit the charter, so every iteration's draft gets a commit in step 4 and the best one can be restored the same way as code.
- Fill "Assumptions and risks" with anything you assumed to make the intent checkable. These are what the user reviews.

## 2. Show the charter, then start

Show the user the intent, the check list, the budget, and the assumptions, in that order, in under 15 lines. Then start without waiting, unless an assumption is high risk (it changes what gets built, touches shared data, or posts outside the machine): then ask that one question first.

## 3. Run it

Give the loop its own copy of the script, named after the loop, so `/workflows` and the progress display tell loops apart. The name must be literal text in the copy:

```bash
sed "s/name: 'run-loop'/name: 'loop: $SLUG'/" ~/.claude/skills/run-loop/workflows/loop.js > "$LOOP_DIR/loop.js"
```

Then run that copy with the Workflow tool, in the background:

```
Workflow({ scriptPath: "<loopDir>/loop.js",
           args: { loopDir, workdir, maxIterations, bestRef, artefact: "code" | "text" } })
```

Before starting, register the working directory with the guard hook, which refuses file edits anywhere else: `echo "$WORKDIR" >> ~/.claude/loops/active-workdirs`. Remove that line in step 4.

When the Workflow tool returns its run ID and transcript directory, write them to `outcome.json` with `status: "running"`. The transcript directory's `journal.jsonl` holds every agent's full result as it finishes, so a session that dies mid-run can rebuild the ledger from it.

Use absolute paths in `args`. Set `artefact` to `text` for a report, plan or other prose result: subagents may not write report files, so the implementer returns the text and the script carries it between iterations. If the Workflow tool is unavailable, run the same loop by hand: `loop-optimizer`, then `loop-implementer`, then `loop-evaluator`, per iteration, with the models and effort from `ROLES`, stopping on the conditions in the charter's budget section. If the script stops because a loop agent is not registered, the agent files are newer than the session: start a new session rather than substituting a general-purpose agent, which would run without the guard hook.

## 4. Record

When the workflow returns:

- Write each iteration in full to `ledger.jsonl`: its plan, the implementer's report and the evaluation with every check's verdict and evidence. `loop-feedback` reads this to see what the evaluator relied on.

  ```bash
  jq -c '.history[]' "$RESULT_JSON" >> "$LOOP_DIR/ledger.jsonl"
  ```

- For a text loop, commit each iteration's draft in the loop directory (`history[].work.artefact`, one commit per iteration, message naming the iteration and its pass count), then write `bestArtefact` to the artefact path in the charter, commit it, and tag that commit `best`.
- Remove the working directory from `~/.claude/loops/active-workdirs`.
- Write the `review` object to `review.json`, adding `title` (the loop's short name), `requested`, `task_type`, `date`, and `result_url` or `result_markdown`.
- Write the outcome:

```bash
jq -n --arg type "$TASK_TYPE" --arg stop "$STOP" --argjson iters "$N" --argjson pass "$PASS" --arg review "$REVIEW_URL" \
  '{task_type:$type, stop_reason:$stop, iterations:$iters, checks_passed:$pass, review:$review, user_verdict:"pending"}' > "$LOOP_DIR/outcome.json"
```

## 5. Hand over for review

The user reviews from one place that answers three questions quickly: what was the intent, how does the result meet it, and how risky is it. The review packet holds all three; put it where the user will look.

Before either path below, run `writing-style:output-brief` over the packet's text fields, with the user as the reader and the result closed: they have not read the report, the diff, or the loop's files. Rewrite any line that only makes sense with the result open, such as "recommendation 3", a check ID used as a noun, or a phase or file name the user has not met. The evaluator's evidence stays verbatim; it sits next to its check, so it resolves on the page.

- **The result is a pull request.** Run the `pr-description` skill and hand it the packet: the intent opens "Why"; each row of `how_met` with its checks and the evaluator's evidence goes under "How have we built confidence"; the risk level, its items and `unverified` open "Risks"; `decisions` go first in the description, so they are not missed.
- **Anything else.** Render the review page and publish it as an Artifact:

  ```bash
  ~/.claude/skills/run-loop/scripts/render-review.sh "$LOOP_DIR/review.json" "$LOOP_DIR/review.html"
  ```

  Publish `review.html` with the Artifact tool (icon `checklist` on first publish) and record the link in `outcome.json`.

Then report to the user as a status: the review link, the outcome and risk level in one line each, any decision waiting for them, and one closing line: if the result is not what they wanted, `/loop-feedback` turns that into an improvement to the next loop.

## When not to loop

A direct question, a lookup, or a task one agent can finish in a single pass does not need a charter: do it directly, because a loop costs three agents per iteration. If the user asks for a quick answer on a large topic, answer and offer the loop in one line.
