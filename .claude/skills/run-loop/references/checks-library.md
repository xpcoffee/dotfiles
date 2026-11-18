# Checks library

Default checks per task type. A charter starts from these and adds its own. `loop-feedback` adds a check here when a loop passed its checks and the user still rejected the result; each added check names the loop it came from and must fail that loop's rejected result.

## implement

- **impl-tests**, verifiable: the repository's test command passes.
- **impl-acceptance**, judged: each acceptance scenario in the intent is exercised by a named test; cite the test per scenario.
- **impl-observable**, judged: each new core behaviour emits a metric and a matching log line; cite both.
- **impl-scope**, judged: every file in the diff serves the intent; list any that do not.

Source: seeded 2026-11-18 from `~/CLAUDE.md` development rules.

## fix

- **fix-repro**, verifiable: a test that reproduces the reported fault fails on the starting SHA and passes on the result.
- **fix-cause**, judged: the root cause is named with evidence (log line, `file:line`), and it explains the first occurrence.
- **fix-guard**, verifiable: the full test suite still passes.

Source: seeded 2026-11-18.

## investigate

- **inv-answer**, judged: the report opens with a direct answer to the question in the intent, or says the evidence cannot answer it and why.
- **inv-evidence**, judged: each claim cites evidence the evaluator can re-run or open.
- **inv-alternatives**, judged: the two most likely alternative explanations are ruled out with evidence, or listed as open.

Source: seeded 2026-11-18.

## plan

- **plan-coverage**, judged: each requirement in the intent maps to at least one step.
- **plan-decisions**, judged: each decision states the tension it resolves and the option not taken.
- **plan-risks**, judged: assumptions and risks are listed for the user's review, each with what happens if it is wrong.

Source: seeded 2026-11-18 from `~/CLAUDE.md` decision-making rules.

## research

- **res-sources**, judged: each claim carries a source link; claims resting on secondary or thin sources say so.
- **res-question**, judged: the summary answers the research question before it surveys.

Source: seeded 2026-11-18.
