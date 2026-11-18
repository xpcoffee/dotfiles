Tracking: [<plan doc title>](<plan doc link>) <!-- only when the work comes from a plan doc -->

# Why

> Resolves AB#<id>

<!-- The problem or goal in 2-3 sentences. The trigger: bug, member impact, missing capability. No solution yet. -->

## Intent

<!-- Only when the work item has Intent and "Metric: done when" blocks. Quote the Intent in one sentence, then
every Metric bullet in the ticket's order, one line each: ticked with evidence, or unticked with what closes it. -->

> <Intent>

- [ ] <Metric in a few words>: <test class, link, or command and result>

Departures, agreed on [AB#<id>](<link>):
- <departure in one line>

# Approach

<!-- The strategy in a few sentences, and the decisions the reviewer must agree with, one line each.
One line for any tradeoff, with a link to the decision doc. -->

```mermaid
%% class/component/deployment if this changes interfaces or where logic runs;
%% sequence/flow if it changes a workflow or behaviour. Name nodes after real code.
```

# How have we built confidence

```gherkin
# Every scenario the plan promised, one behaviour each. For a bug fix the first one reproduces the
# reported failure and says whether its test failed before the fix. Omit the block for a purely
# mechanical change and say why in one line.
Scenario: <behaviour in domain terms>
  Given <starting state>
  When <user action or event>
  Then <observable outcome>
  # <TestClass.TestName>
```

# Risks

- **Deploying:** <!-- what changes in production on deploy; deploy order -->
- **Rolling back:** <!-- does the previous version read everything this one may write -->
- <!-- any other unmitigated risk, and what decides or closes it -->

<!-- Deep explanation lives in a committed doc; link it from Approach, using this repo's own docs layout. -->
