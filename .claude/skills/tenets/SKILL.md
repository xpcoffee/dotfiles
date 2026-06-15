---
name: tenets
description: Use when drafting, reviewing, or sharpening tenets (guiding principles) for a project, team, role, or subagent. Triggers on "write tenets", "team principles", "operating principles", "guiding principles", "decision principles", "what should this agent optimise for", or when a stated principle reads like a platitude and needs a real tradeoff in it. Explains what a tenet is, why decisions are tension resolution, and why useful tenets are contextual and contentious.
---

# Writing useful tenets

Apply the [writing-style](../writing-style/SKILL.md) hard rules to every tenet you draft. This skill adds what makes a tenet do its job: resolve a real tradeoff.

Read this file completely before drafting tenets. Run every candidate through the tests below before presenting.

## What a tenet is

A tenet is a written rule that says which side of a recurring tradeoff to take. It records how we make decisions both to communicate how we will react to tough spots in advance, and to communicate why we think this is the correct tradeoff to make.

It front-loads the discussions so that we don't have to make them under stress and so that individuals are empowered to resolve these tensions without feeling like they need consensus.

A tenet _can_ act as a default, carrying the stance "unless we know better", but this is often an antipattern. We generally need to apply tenets when a tension cannot be resolved easily after we've done the legwork. It is not a substitute for doing the legwork. Think of it more as a tie breaker or a starting direction when we're unsure where to go.

## Decisions are tension resolution

A decision exists only when each option costs you something the others would have given you. You buy one good by spending another. When a single option wins on every axis, you have a correct answer and no decision to make.

Calling that a decision is a false decision. It dresses an obvious answer as a choice and spends the reader's attention for nothing. A decision turns false in two ways:

- **The options do not conflict.** One dominates. State the answer and move on.
- **The tension is real, but the tenet refuses to pick a side.** "Balance speed and quality" keeps both goods and gives no guidance the moment they collide, which is the only moment you needed it.

So a tenet earns its place exactly when it names a tension that matters and picks a side.

## Why tenets are contextual and contentious

**Contentious.** The side you pick has to be arguable. If everyone already agrees ("write correct code"), the tenet resolves nothing, because nobody was going to choose the other side. A good tenet is one a reasonable person in a different situation would reverse.

**Contextual.** Which side wins depends on the situation. "Prefer speed over completeness" is right for a quick experiment and wrong for a billing migration. So a tenet must state the conditions under which its pick holds, when that pick flips, and ideally the cost it accepts.

## Tests a tenet must pass

1. **Names a real tension.** Two things you want that pull against each other.
2. **Picks a side.** States which one wins when they collide.
3. **States its context.** When this holds, and what flips it.
4. **Accepts a cost.** Says what you give up. A tenet with no cost is a slogan.
5. **Changes a decision.** You can point at a recent choice it would have settled, and someone who would have chosen the other way.
6. **Survives pressure.** It still tells you what to do on the bad day when both sides are expensive.

If a candidate fails test 1 (no tension) or test 5 (changes nothing), drop it.

## Anti-patterns

- **Platitude:** "We value quality." Everyone agrees, so it resolves nothing.
- **Two-sided hedge:** "Balance X and Y." Picks no side, helps in no collision.
- **Goal restated as a tenet:** "Ship the feature." That is the objective. The tenet is how you trade off while pursuing it.
- **Too many tenets:** When everything ranks first, nothing does. Keep the few that apply to real decisions.
- **Context-free absolute:** "Always prefer X." Real tenets carry conditions. An absolute usually hides an unstated context.

## Tenet shape

> When [tension: A pulls against B], prefer [A]. We accept [cost] to get [benefit]. This holds while [context]; it flips when [condition].

You can drop the explicit clauses once a tenet is well understood, as long as the tension, the pick, and the cost stay legible.

## How to draft tenets

1. **List the recurring tensions** for this project, team, role, or agent. Ask: where do two good things pull apart here, often enough to argue about?
2. **Pick which side wins** for each. State the cost you accept by picking it.
3. **State the context.** When does this hold, and what flips it.
4. **Run the six tests.** Cut any that fail test 1 or test 5.
5. **Rank and trim.** Keep the few that apply on real decisions.

## Drafting for each target

The four targets differ in where the tension sits.

- **Projects** trade something specific for their outcome. Frame tenets around what this project is willing to give up to reach its goal. Example tension: time-to-learn against durability for a prototype.
- **Teams** trade off in how they work day to day. Example tension: letting one person move fast on their own against keeping the rest of the team in sync.
- **Roles** trade off against the role next to them. A role's tenets say what it optimises for when it pulls against an adjacent role. Examples: a product manager weighing a fresh customer request against the scope already committed for the launch; a quality assurance lead weighing holding a release for a defect against shipping on the promised date; a motion designer weighing a richer animation against keeping the interface fast and calm.
- **Subagents** decide alone while the orchestrator is absent, so their tenets are the rule they apply when a tension has no clear resolution. Make each concrete enough to resolve a tension with no human present, and state when to stop and escalate rather than guess. Example for a search subagent: returning a conclusion against returning the raw evidence. Pick "return the conclusion with the one citation that proves it".
