---
name: pr-description
description: Use when writing or revising a pull request description, on GitHub or ADO, or before marking a PR ready for review. Produces a high-level summary built around four questions, with diagrams chosen by what the change touches, and pushes deep explanation into a committed architecture or decision doc. Trigger on "write the PR description", "open a PR", "draft the PR body", "update the PR description".
---

# PR descriptions

A PR description is a high-level summary. A reviewer reads it in under a minute and knows why the change exists, how it works, and why to trust it. Depth lives in the repo, in a committed doc the description links to, so it survives after the PR is merged and the description is forgotten.

Read this file completely before drafting. Run the [writing-style](../writing-style/SKILL.md) hard rules over the drafted description before presenting, committing, or pushing it. This is a pass over the text you wrote, every sentence and every diagram label, done after the draft exists. Diagram labels are prose: "lands", "surface", and glued jargon fail there too.

## The rule that sets the length

Put the reasoning a reviewer needs to approve the change in the description. Put everything a future maintainer needs in a committed doc. If you are explaining a tradeoff, a data model, an algorithm, or a migration in more than a short paragraph, stop: that belongs in a doc (see "When to write a doc"). Link it from the description and keep the description short.

The description answers four questions, in this order. Nothing else, apart from the Intent checklist under Why when the work item has one.

## The four questions

### 1. Why is the change needed

The problem or goal, in two or three sentences. Link the work item (`Resolves AB#<id>`). State the trigger: the bug, the member impact, the missing capability. No solution yet.

#### Intent and Metric, when the work item has them

When the work item carries an Intent and a "Metric: done when" list (the story format the plan docs use), add an `## Intent` subsection under Why. Quote the Intent in one or two sentences, then copy every Metric bullet as a checklist item, in the ticket's order and wording, so the reviewer judges the PR against what the story promised rather than against what the PR chose to claim.

- Tick a bullet only when the PR meets it, and follow it with the evidence: the test that pins it, a link, or the command and its result.
- Leave a bullet unticked when the PR does not meet it, and say in a few words why and what closes it, for example a separate PR that must merge first.
- When the PR departs from a bullet on purpose (a reviewer decision, a design change), leave it unticked, state the departure, and link where it was agreed.
- Name the Optimizer preferences only when the PR went against one, with the reason.

```markdown
## Intent

> Add the item classes, data access and serialization for the three order items.

- [x] A serialization round-trip test per type. Pinned by `OrderItemSerializationTests`.
- [ ] The container exists on dev. Needs infra#123 merged and released.
- [ ] `OutboxStatus` has exactly Pending and Done. Departure: finished entries are soft deleted, so `Done` was dropped (review on this PR).
```

### 2. What is the general approach

The strategy in a few sentences, plus a diagram (see "Choosing diagrams"). The reviewer should grasp the shape of the solution before reading any prose about the parts. If the approach has a tradeoff worth recording, state the pick in one line and link the decision doc for the reasoning.

### 3. What changed

The salient points a reviewer needs before opening the diff, plus a diagram. Write three to five bullets, most important first. Each bullet states a behaviour the system now has, or a decision the reviewer has to agree with, and what it replaced when the difference is the point. The reviewer judges each bullet, then opens the diff to check the code against it.

Open each bullet with the behaviour, not a path. Name a file only when the reviewer must look at that file specifically, such as a migration or a contract other teams consume. The diff already lists the files, so a file-by-file inventory adds nothing to it. When a change is spread across many files for one reason, it is one bullet.

Draw the diagram of the change as before and after when the difference is the point: a picture of the new flow alone asks the reader to imagine the old one.

### 4. How have we built confidence

Why this is safe to merge. Cover what applies:

- Tests added or changed, and what behaviour they pin.
- Observability: metrics and their logs, so the change is visible in production.
- Rollout control: feature flag, phased deploy, migration order.
- Manual verification, with the environment and what you checked.

If a risk is unmitigated, say so here. A reviewer trusts an honest gap more than a silent one.

#### Behaviours as Gherkin scenarios

When the change adds or alters behaviour, which includes every bug fix, state the behaviours the tests pin as Gherkin scenarios (Given, When, Then) in a fenced ` ```gherkin ` block, and name the test that pins each one. A reviewer can then check each claimed behaviour without reading test code, and spot a missing case by its absence. Skip the block for a purely mechanical change, such as a rename or a config bump, and say so in one line.

- For a bug fix, the first scenario reproduces the reported failure in the terms of the report: the input or user action that triggered it, and the correct outcome. Say whether its test failed before the fix; a test that never failed has not proven the fix.
- Write each scenario in domain and user terms, not method names. "When the user changes the filter before the first page loads" says more than "When LoadPage is called twice".
- One behaviour per scenario, three to five lines each, and at most five scenarios. Further cases belong in the test file, not the description.
- Follow each scenario with the test that pins it, for example `SearchResultsTests.FilterChange_DuringFirstLoad_DoesNotRestartQuery`. A scenario with no test is a gap: list it under Risks.

```gherkin
Scenario: A filter change while the first page loads does not restart the query
  Given the search results list has more than 20 rows
  When the user changes the filter to one with no matching rows before the first page appears
  Then the list shows no rows
  And the page stops reading from the database
```

## Choosing diagrams

Pick the diagram type from what the change touches. Both the approach section and the changed section get a diagram; they can be the same type or different.

- **Interfaces, and where logic lives or runs** → class, component, or deployment diagram. Use when the change moves responsibility between classes or services, adds or reshapes an interface, or changes which process or host runs a piece of logic.
- **A workflow or a behaviour** → sequence or flow diagram. Use when the change alters the order of calls, a state machine, a decision path, or what happens across a request.
- **Both** → include more than one diagram. A change that adds a service (where) and reroutes a call sequence through it (behaviour) needs one of each.

Keep each diagram to the nodes that changed plus their immediate neighbours. A diagram that redraws the whole system hides the change. If a section's change is purely mechanical (a rename, a config bump) and a diagram would add nothing, write one line saying why there is no diagram instead of forcing one.

### Diagram mechanics

Use Mermaid in fenced ` ```mermaid ` blocks. GitHub renders these in the PR description directly. On ADO the PR description does not render Mermaid reliably, so commit the diagram in the linked doc and reference it from the description there.

```mermaid
sequenceDiagram
    participant C as Caller
    participant S as Service
    C->>S: request
    S-->>C: result
```

Label every node and edge with a concrete name from the code. A box called "Service" teaches nothing; "PatientService" does. For a line break inside a label use `<br/>`; GitHub renders a literal `\n` as the two characters, not a break.

## When to write a doc

Write or extend a committed doc, and link it from the description, when any of these hold:

- The approach makes a significant decision about behaviour, architecture, or structure a future reader would question. → a short decision doc via the [decision-doc](../decision-doc/SKILL.md) skill.
- The change reshapes a component's behaviour or structure. → update that component's current-view architecture doc (`docs/architecture/`) so it reads as the present state, without replaying decisions.
- The change needs a whole new technical design (alternatives, system diagrams, the use-error/threat/privacy analyses). → the Technical Design Buddy skill, which produces the RFC.
- The explanation needs more than a short paragraph or more than two diagrams. → it belongs in one of the docs above, not the description.

The doc holds the depth: the decision and its reasoning, the schema, the sequence in full, the failure modes. The PR description holds the summary and one link. Check the target repo's convention for where docs live before creating a new location.

## Self-check before presenting

1. Does the description answer all four questions, in order, and nothing else? If the work item has an Intent and a Metric, does Why carry the checklist with every Metric bullet, each ticked with evidence or unticked with the reason?
2. Is every block of reasoning longer than a short paragraph moved to a linked doc?
3. Does the approach section and the changed section each carry a diagram (or one line saying why not)?
4. Is each diagram type the right one for what that section changed?
5. Are diagram nodes named after real code, scoped to what changed?
   Does each "What changed" bullet open with a behaviour or a decision, with at most five bullets and no file inventory?
6. Does "how have we built confidence" name tests, observability, and rollout, and call out any unmitigated risk?
   For a change in behaviour, are the pinned behaviours stated as Gherkin scenarios, each naming its test, with a bug fix's first scenario reproducing the reported failure?
7. Have you run the writing-style hard rules over the finished draft, sentences and diagram labels both?

Fix every failure before showing the draft. The template in `templates/pr-body.template.md` is the shape to fill.
