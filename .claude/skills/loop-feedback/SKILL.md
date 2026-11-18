---
name: loop-feedback
description: Turn the user's dissatisfaction with a loop's result into an improvement to the loop system itself, by deciding which part failed (intent, checks, evaluator, optimizer, implementer, budget, or handoff) and changing that part so the next loop does better. Also records accepted results and reports how the loop system is doing. Trigger on "/loop-feedback", "that's not what I wanted", "the loop got this wrong", "this result is fine, accept it", "how are the loops doing".
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent
---

# Loop feedback

The loop system has its own intent, check, and optimizer. Its intent is that loops deliver what the user wanted without the user stepping in. Its check is the user's verdict on each finished loop. This skill is its optimizer: each rejection changes the one part of the system that caused it.

Find the loop: the one the user names, else the most recent directory in `~/.claude/loops/`. Read its `charter.md`, `holdout.md`, `ledger.jsonl`, and `outcome.json`. The ledger holds every iteration's plan, work and evaluation, including each check's verdict (`pass`, `fail` or `unknown`) and the evidence the evaluator cited; use that evidence to tell an evaluator miss from a checks miss.

## When the user accepts the result

Set `user_verdict` to `accepted` in `outcome.json` and stop. Accepted loops are half of the system's measurement, so record them even when the user mentions it in passing.

## When the user rejects the result

1. **Quote the complaint.** Use the user's words. If they have not said what is wrong, ask once: "What should the result have done that it did not?"
2. **Decide which part failed.** Walk the result back through the loop, and stop at the first answer that fits:
   - The charter's intent asked for something other than what the user wanted: **intent**.
   - The intent was right and every check passed: **checks**. The checks did not measure the intent.
   - A check that would have caught it existed and the evaluator passed it: **evaluator**.
   - The checks caught it and the briefs chose the wrong direction, repeated a failed approach, or missed the cause: **optimizer**.
   - The briefs were right and the work did not follow them, or took an action it should have escalated: **implementer**.
   - The loop stopped too early, ran too long, or did not escalate when it should have: **budget**.
   - The result was fine and the review page or PR description made it hard to judge: **handoff**.
3. **Change that part.** One change per rejection, written as how to do the work, with one example. Show the user the change as a short diff in your reply.

   | Part | Where the change goes |
   |---|---|
   | intent | a new entry in `~/.claude/skills/run-loop/references/intent-exemplars.md`: requested, intent written, intent that works, decision |
   | checks | a new check in `~/.claude/skills/run-loop/references/checks-library.md` under the task type, naming this loop as its source |
   | evaluator | a worked example in `~/.claude/agents/loop-evaluator.md` of the judgement it got wrong |
   | optimizer | a how-to line or example in `~/.claude/agents/loop-optimizer.md` |
   | implementer | a how-to line or example in `~/.claude/agents/loop-implementer.md` |
   | budget | the defaults in `~/.claude/skills/run-loop/references/charter.template.md` |
   | handoff | step 5 of `~/.claude/skills/run-loop/SKILL.md` or the review-packet prompt in `workflows/loop.js`; for a writing miss, also capture it with `writing-style:prose-miss` |

4. **Prove a new check.** For a checks or evaluator change, run the `loop-evaluator` agent on the rejected result with the new check added to a copy of the charter. The change is proven when the new check fails the rejected result. If it passes, the check does not capture the complaint: rewrite it and try again, at most twice, then tell the user it could not be pinned down.
5. **Log it.**

   ```bash
   jq -nc --arg loop "$LOOP" --arg part "$PART" --arg complaint "$COMPLAINT" --arg change "$CHANGE_PATH" \
     --arg proven "$PROVEN" --arg type "$TASK_TYPE" '{date:(now|todate), loop:$loop, task_type:$type, part:$part, complaint:$complaint, change:$change, proven:$proven}' \
     >> ~/.claude/loops/misses.jsonl
   ```

   Set `user_verdict` to `rejected` in the loop's `outcome.json`.

6. **Offer a re-run.** One line: the loop can run again with the changed part, from its best ref.

## When the same part keeps failing

Run `scripts/loop-report.sh`. When one part has two or more rejections for the same task type, one more example will not fix it. Propose a structural change to the user instead, with the misses as evidence: a different model or effort for that role in `ROLES` in `~/.claude/skills/run-loop/workflows/loop.js`, a verifiable check in place of a judged one, or a new question in the charter template. Wait for agreement before making it.

## Example

The user rejects a fix loop: "it fixed the symptom, the duplicate rows still get created by the nightly job." The charter's intent was right, and `fix-cause` passed because the evaluator accepted the API handler as the cause. A check existed and was passed wrongly, so the part is **evaluator**. The change adds a worked example to `loop-evaluator.md`: a cause passes `fix-cause` only when it explains every path that produces the fault, so search for other writers of the same table first. Replayed on the rejected result, the evaluator now fails `fix-cause` by citing the nightly job's insert, which proves the change.
