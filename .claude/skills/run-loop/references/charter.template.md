# Loop: <short name>

Task type: <implement | fix | investigate | plan | research>
Requested: <the user's words, quoted>
Working directory: <worktree path, or this loop directory for non-code work>
Artefact: <where the result lands: branch, PR, report path>

## Intent

<One paragraph: the outcome, who it is for, and what they will do with it.>

Out of scope: <what the loop leaves alone>

## Checks

| ID | Kind | How it is measured | Passes when |
|---|---|---|---|
| <type>-1 | verifiable | `<command>` | <exit code 0, output contains X> |
| <type>-2 | judged | <evidence the evaluator must cite> | <condition> |
| guard-1 | verifiable | `<existing test or lint command>` | <still passes> |

Hold-out checks: `holdout.md` in this directory. The optimizer and implementer do not read it.

## Roles

Optimizer: loop-optimizer (Opus, high effort) plans each iteration.
Implementer: loop-implementer (Sonnet) does the work.
Evaluator: loop-evaluator (Opus, low effort) scores it.
Implementer may decide alone: naming, local structure, test shape, wording, order of work.
Escalate: <decisions that stop the loop and come back to the user>

## Budget

Maximum iterations: 3
Stop early when: all checks pass; the evaluator reports `same` or `regressed` twice in a row; the evaluator suspects gaming; the optimizer or implementer reports `blocked`.

## Assumptions and risks

- <assumption made to make the intent checkable, and what goes wrong if it is false>
