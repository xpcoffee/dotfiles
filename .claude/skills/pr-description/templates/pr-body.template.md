Tracking: [<plan doc title>](<plan doc link>) <!-- only when the work comes from a plan doc; a stack line goes here too -->

# Why

> Resolves AB#<id>

<!-- The problem or goal in 2-3 sentences. The trigger: bug, member impact, missing capability. No solution yet. -->

# Intent

<!-- Always present. Cover the work item's Intent and every "Metric: done when" bullet in the ticket's order, or, when the
work item has none, an intent gauged as the intent-review skill does and confirmed with the user. No checkboxes, no test names. -->

<Intent as plain text, not a quote: the behaviour the change should make true>

Each bullet below describes something the change does, explains why it serves that intent, and says how we validated it.

**<Part of the intent these bullets serve>**

- <behaviour>, so <why it matters for the intent>. Validated via <unit tests | component tests | e2e tests | manual testing on the PR deployment>.

**<Another part, if the bullets split>**

- <behaviour>, so <why>. Not met yet: <what closes it>.

## Decisions made during implementation

- <choice the work item did not settle, and why, in one line; link where it was agreed>

# Approach

<!-- The strategy in a few sentences, and the decisions the reviewer must agree with, one line each.
One line for any tradeoff, with a link to the decision doc. -->

```mermaid
%% class/component/deployment if this changes interfaces or where logic runs;
%% sequence/flow if it changes a workflow or behaviour. Name nodes after real code.
```

# Risks

- **Deploying:** <!-- what changes in production on deploy; deploy order -->
- **Rolling back:** <!-- does the previous version read everything this one may write -->
- <!-- any other unmitigated risk, and what decides or closes it -->

# How have we built confidence

<!-- Answers each risk above: how it was mitigated, or how it will be mitigated during rollout. No Gherkin, no test names. -->

- **Regressions:** <which suites pass, in one line>
- **Deploying:** <what makes the deploy safe; confirmed by a test, or only from the code>
- **Rolling back:** <what makes rollback safe>
- **<Risk left for rollout>:** <metric and dimensions to watch, what normal looks like, the signal to roll back>
- **<Step still to do> (not done yet):** <what will be checked, and where>

<!-- Deep explanation lives in a committed doc; link it from Approach, using this repo's own docs layout. -->
