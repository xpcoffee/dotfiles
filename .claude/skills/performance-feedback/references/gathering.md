# Gatherer briefs

The skill runs one gatherer per source. This file defines what each gatherer extracts and the output contract. The concrete commands (tools, queries, accounts, project names) live in `references/work-config.md`, which is gitignored and per-user. Spawn each gatherer as `subagent_type: "general-purpose"`, `model: "haiku"`, all in one message. Substitute `<start>`/`<end>` with the window dates.

## Output contract (append verbatim to every gatherer prompt)

> Return ONLY a markdown bullet list of evidence items, no preamble or summary. Each bullet:
> `- <YYYY-MM-DD> | <source link or id> | <factual description> | people: <names>`
> Include verbatim quotes in double quotes where the exact phrasing matters (review comments, commitments, decisions). Report facts only: no judgements, no scoring, no advice. Include unflattering items with the same fidelity as flattering ones; do not filter for tone. If a tool fails with an auth error, return the single line `COVERAGE GAP: <source> – <error>` and stop. If the tools you need are deferred, load them first with ToolSearch (`select:<tool-name>`).

## Source roles

For each source listed in `work-config.md`, take its commands from there and extract the following. Prioritise evidence that materially changes how a week reads.

- **chat** (Teams, Slack, etc.): messages the user sent and was @mentioned in. Skip messages under ~20 chars unless they are substantive answers in a thread (a one-line decision counts; "ok thanks" does not). Prioritise decisions stated or driven, summaries sent after meetings, questions asked vs answered, commitments made ("I'll have X by Y"), escalations, and threads the user started. Capture thread context: what was discussed, who waited on whom.
- **code reviews, authored**: PRs the user opened. Capture comments received and how he responded (replied, pushed a fix commit, resolved silently, left unanswered). Note PR mechanics that carry signal: description quality, size, time-to-merge, force-pushes after review, linked work items.
- **code reviews, given**: PRs the user reviewed, or threads he authored on others' PRs. Capture the comments he gave, verbatim where substantive, and the PR outcome.
- **work items**: items the user changed. Capture state transitions he drove, comment substance (status updates, decisions, investigation findings), and items that went stale while assigned to him. Keep only comments authored by him in window.
- **journal**: local notes for the window plus the previous report. Extract the day's work themes and meetings (these record what the week was spent on, including meetings invisible to the other sources), the previous report's gap bullets for repeat-marking, and the goals headings.

A source whose connector returns null or an auth error is a coverage gap, not a blocker: the gatherer returns the `COVERAGE GAP:` line and the synthesis records it in the report header.
