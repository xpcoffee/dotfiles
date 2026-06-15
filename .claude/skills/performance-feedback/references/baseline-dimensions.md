# Baseline dimensions

Three fixed dimensions, always evaluated regardless of the goals file. Goals-derived dimensions come first in the report; these follow. Tags in moments use the short names in backticks: `[communication+]`, `[code quality-]`, `[follow-through+]`.

## communication

How work, decisions, and status move between the user and others.

Green signals:
- Decision summaries sent after discussions, naming owners and actions.
- Status shared before being asked (work items updated, threads closed with outcomes).
- Disagreement stated directly with reasoning, in the open thread rather than sidebars.
- Written artefacts (PR descriptions, work-item comments) that let a reader act without a follow-up question.

Red signals:
- Threads the user started that end without a stated outcome.
- Questions to the user that aged > 1 working day without acknowledgement.
- Decisions kept undocumented: work shipped with no trace of why in the PR/work item.
- Long messages where the ask is buried or absent.

## code quality

The state of code the user ships and the reviews he gives.

Green signals:
- Review comments received are engaged: fix commit, reasoned pushback, or explicit deferral with a follow-up item.
- Reviews given catch behaviour-level issues (failure modes, observability, cross-component effects) beyond style.
- PRs scoped to one behaviour, with descriptions stating the why and the risk.
- Tests and observability ship in the same commit as the behaviour.

Red signals:
- Review comments resolved without response or follow-up commit.
- PRs merged with known gaps and no tracking item.
- Reviews given that are rubber stamps on substantive changes (approve, no comments, large diff).
- Repeated review feedback on the same pattern across the week's PRs.

## follow-through

Whether stated intentions become artefacts.

Green signals:
- Commitments made in chat/standups traceable to a PR, work item, or message closing them within the stated window.
- Work items moved to done with the evidence attached, beyond a bare state flip.
- Items unblocked for others (reviews turned around, answers given) without chasing.

Red signals:
- "I'll do X" with no corresponding artefact by week's end and no renegotiation.
- Work items assigned to the user untouched all week with no status note.
- The same item carried across weeks without a stated reason.
