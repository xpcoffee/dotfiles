# Why

> Resolves AB#<id>

<!-- The problem or goal in 2-3 sentences. The trigger: bug, member impact, missing capability. No solution yet. -->

## Intent

<!-- Only when the work item has Intent and "Metric: done when" blocks. Quote the Intent, then every
Metric bullet in the ticket's order: ticked with evidence, or unticked with the reason or departure. -->

> <Intent>

- [ ] <Metric bullet>. <evidence, or why not met>

# Approach

<!-- The strategy in a few sentences. One line for any tradeoff, with a link to the decision doc. -->

```mermaid
%% class/component/deployment if this changes interfaces or where logic runs;
%% sequence/flow if it changes a workflow or behaviour. Name nodes after real code.
```

# What changed

<!-- 3-5 salient points, most important first: each a behaviour the system now has or a decision
the reviewer must agree with, and what it replaced. Open with the behaviour, not a file path. -->

- 

```mermaid
%% Diagram of the change: before and after when the difference is the point. Scope to what changed.
```

# How have we built confidence

- **Tests:** <!-- what behaviour they pin; the scenarios below are the detail -->

```gherkin
# One scenario per pinned behaviour, at most five. For a bug fix the first one reproduces the
# reported failure. Name the pinning test under each, and say if it failed before the fix.
# Omit this block for a purely mechanical change and say why in one line.
Scenario: <behaviour in domain terms>
  Given <starting state>
  When <user action or event>
  Then <observable outcome>
```
Pinned by: `<TestClass.TestName>`

- **Observability:** <!-- metrics and their logs -->
- **Rollout:** <!-- feature flag / phased deploy / migration order -->
- **Manual:** <!-- environment + what you checked -->
- **Risks:** <!-- any unmitigated gap, stated plainly -->

<!-- Deep explanation lives in a committed doc; link it here, using this repo's
own docs layout:
Architecture: <path to the component's architecture doc>
Decision: <path to the decision doc> -->
