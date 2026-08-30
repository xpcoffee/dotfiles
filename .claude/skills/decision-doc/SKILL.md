---
name: decision-doc
description: Use when a change makes a significant decision about behaviour, architecture, or structure and that reasoning should outlive the PR. Produces a short decision record (a few paragraphs): the decision, what changed in the context, and how the decision answers it, with diagrams. Pairs with updating the component's current-view doc. For a full technical design, route to the Technical Design Buddy instead. Trigger on "write a decision doc", "record this decision", "ADR for this", "why did we change the approach".
---

# Decision docs

A decision doc records one significant decision about behaviour, architecture, or structure, so the reasoning outlives the PR and the conversation. Keep it short: a few paragraphs. Write one when a change shifts behaviour, architecture, or structure in a way a future reader would question. Routine changes need none.

Run the [writing-style](../writing-style/SKILL.md) hard rules over every line.

## The current view comes first

A feature or component doc always describes its present behaviour and structure. A reader learns the current state from it without reading any decision history. So a significant change is two pieces of writing:

- Update the component's architecture doc so its current view matches the new behaviour or structure.
- Add a decision doc recording why it changed.

The architecture doc holds the current state. The decision doc holds the reasoning and the moment. A reader who wants "how does this work today" reads the architecture doc and stops. A reader who wants "why is it like this" reads the decision doc. Link the two, and keep the decision out of the current-view doc beyond a one-line pointer.

## Decision doc, or technical design doc

- **Decision doc** (this skill): one decision and its reasoning. A few paragraphs. Lives next to the code it governs.
- **Technical design doc**: a whole design, with alternatives, system diagrams, and the use-error, threat, and privacy analyses. Drive it with the Technical Design Buddy skill, which produces the RFC. Do not hand-roll one here. If a decision doc grows past a page, it wanted to be a design doc: route to the buddy and link it.

## The three parts

1. **The decision.** What we are doing, decided, in one or two sentences.
2. **What changed in the context.** Why now. Name which one it is: a lesson learned, a change in product or project direction, a deferred decision we are now taking, or a tension we are resolving.
3. **How the decision answers it.** How it adapts to, fixes, anticipates, or implements that context change, and the high-level approach in a few sentences.

### When the context is a tension

The tension case matters most and is the easiest to write badly. State three things:

- The two things we want. Both are real goods.
- Why they pull against each other in this change. The specific collision, not a general "tradeoff".
- Why we resolve toward one. What we buy, and what we give up.

This is the shape of a tenet for a single change. See the [tenets](../tenets/SKILL.md) skill: a decision doc records the resolution for one change, a tenet generalises it across many.

## Diagrams

Illustrate the decision with diagrams. Same rules as the [pr-description](../pr-description/SKILL.md) skill, "Choosing diagrams": class, component, or deployment when the decision is about interfaces or where logic lives; sequence or flow when it is about a workflow or behaviour; both when both. Use Mermaid, name nodes after real code, and `<br/>` for line breaks.

## Placement

Keep to a few paragraphs under the three headings, plus diagrams. Put it where the repo keeps decisions, dated and slugged. In APIBackend: `docs/architecture/<area>/decisions/<YYYY-MM-DD>-<slug>.md`. Link it from the architecture doc it affects and from the PR description (the pr-description approach section points at it).

## Reviewing or refactoring an existing decision doc

When you run this skill against a doc that already exists, do not just confirm the structure. Read it and make the change each check calls for:

- **Too long.** A decision doc is about five short paragraphs or fewer. Past that, it is doing the architecture doc's job. Move the present-state mechanism into the component's current-view doc and cut the decision doc back to the three parts. If what remains is still a page, it is a technical design: route to the Technical Design Buddy.
- **Mechanism where the decision belongs.** Prose that walks through how the code works now, step by step, is current-view content. It belongs in the architecture doc, with the decision doc holding only the decision and why. Relocate it and link.
- **No diagram.** A decision that changes behaviour or structure needs at least one diagram (the rules above). Add it. State in one line why not only if the decision has no spatial or temporal shape.
- **A missing part.** If the decision, the context change, or the resolution is absent, add it. If it resolves a tension, the two goods, the collision, and the chosen direction must all be present.

A doc that is long, mechanism-heavy, and diagram-less is the common failure: it reads like a second copy of the architecture doc. Cut it to the decision, draw the change, and point at the current-view doc for how it all works.

## Self-check

1. Is it about five short paragraphs or fewer, with present-state mechanism living in the architecture doc instead of here? If it is longer or reads as a page, trim, or route to the Technical Design Buddy.
2. Are all three parts present: the decision, the context change, how it answers?
3. If it resolves a tension, are the two goods, the collision, and the chosen direction all stated?
4. Does the component's current-view doc now reflect the change, so a reader need not read this decision to know the current state?
5. Does a diagram illustrate the decision, with the type matching what changed?
6. Has the prose passed the writing-style hard rules?
