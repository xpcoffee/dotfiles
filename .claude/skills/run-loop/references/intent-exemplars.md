# Intent exemplars

Each entry is an intent that produced a result the user rejected, the intent that would have produced the right result, and the judgement that separates them. `loop-feedback` adds entries; keep the library near ten and merge entries that teach the same judgement.

## 1. Name the outcome, not the activity

**Requested.** "Look into why the booking sync is slow."

**Intent written.** Investigate booking sync performance.

**Intent that works.** Find which step of the booking sync accounts for most of its run time on a normal weekday, so the team can decide whether to fix that step or change the schedule. Out of scope: changing code.

**Decision.** An activity has no finish line, so the optimizer stops when it runs out of ideas, not when the user has what they need. Ask what the user will do with the result, and write that into the intent; the checks then follow from it. This entry is a seed written with the skill, not a captured miss.
