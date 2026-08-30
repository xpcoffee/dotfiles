---
name: code-comments
description: Use when writing, reviewing, or refactoring code comments, or before committing code that adds comments. Treats a comment as a signal: it either carries durable context a junior engineer cannot infer, or it marks code, docs, or a contract that should change. Decides which, and refactors accordingly. Trigger on "review the comments", "are these comments any good", "clean up the comments", "should this be a comment".
---

# Code comments

A comment earns its place only when it carries durable context a junior engineer cannot infer from the code in front of them. Read every other comment as a signal that the code, the docs, or the contract should change. This skill decides which case you are in, and what to do.

Run the [writing-style](../writing-style/SKILL.md) hard rules over every comment you keep or write. A comment is prose.

## What a comment is for

Keep a comment, tightened to one line, only when it carries one of these:

- A non-local hazard the call site cannot see: a callee that throws, a lock held, an ordering requirement.
- A workaround for an external constraint, with the constraint named: a vendor bug, a protocol quirk, a regulatory rule.
- The specific incident or regression a guard exists for.
- A unit or format the type cannot express: milliseconds, UTC, a currency minor unit.

Scope each comment to the exact line its context applies to. Name the artefact or team, never a person. Describe what this code does or guards against. A comment speaks for the code it sits on.

## Four things a comment must not do

1. Restate the code or narrate its mechanics.
2. Record a decision made in conversation that the code and docs do not show. Put the decision in a decision doc and link it.
3. Justify a local detail by pointing at a caller, a scenario, or code more than one call away. That breaks encapsulation and fails the moment the caller changes.
4. Carry prose that has not passed the writing-style rules.

## Smells, and what they signal

The comment is usually a symptom. Read it as a signal about the code around it.

### A comment that explains a whole workflow or scenario

It signals one of:

- The code or architecture cannot be followed by reading it.
- The specification and constraints were never captured in a design, architecture, or decision doc.

Refactor: move the workflow into the relevant doc and link it, or restructure the code so the workflow reads from the names (extract named steps, name the states). The comment shrinks to a one-line pointer, or goes.

### Several comments that each explain an implementation detail

It signals one of:

- The function or class does too many things.
- The implementation cannot be read on its own.
- The contract of the namespace or library is undefined, so the code keeps explaining itself.

Refactor: extract each commented block into a method whose name replaces the comment, split the type along the concerns the comments mark, or define the interface so callers never need the internals explained.

### A comment that states a value, enum, or name the code uses

It signals a literal that should be extracted, not described in prose. The comment and the code now hold the same value in two places, so they drift.

- A value that could change (a timeout, a limit, a threshold, an endpoint) belongs in configuration, read in one place.
- A fixed quantity (the speed of light, a conversion factor) belongs in a named constant, so the name carries the meaning.

Refactor: extract the value as a named constant or a configuration setting, and let the name say what the comment said. Reference it wherever the value is used. Keep a comment only for the source a name cannot carry, the citation or spec section a constant comes from.

## The refactor decision

When a comment trips one of the rules or smells, pick the smallest move that removes the need for it:

1. **Delete**: it restates the code. Remove it. (low risk)
2. **Tighten**: it is legitimate but verbose. Cut to the durable context, one line. (low risk)
3. **Rename or extract**: it names a step or a value. Make it a method or variable name and drop the comment. (low risk)
4. **Document**: it explains a workflow, constraint, or decision that belongs in design. Write or extend the doc, link it. (additive)
5. **Restructure**: comments mark separate concerns or an undefined contract. Split the method or type, or shape the interface. (higher risk: propose the change and the reason first)

Delete, tighten, rename, extract, and document directly. A structural change that splits a type or reshapes an interface is higher risk: describe it and why, and let the author decide before you make it.

## Examples

Restate the code, delete it:

```csharp
// increment the counter
counter++;
```

Caller reference breaking encapsulation, rewrite to describe this code:

```csharp
// BookingController calls this twice so we guard against a null cart   ❌
// the cart is created lazily on first add, so it is null until then    ✅
```

Workflow narration, extract and let names carry it:

```csharp
// first we validate the slot, then we hold it, then we charge, then we confirm   ❌
ValidateSlot(); HoldSlot(); Charge(); ConfirmBooking();                            ✅ names tell the story
```

Decision recorded only in a comment, move it to a doc:

```csharp
// we picked soft-delete over hard-delete in the 26 June review because reprocess needs the history   ❌
// soft-delete: reprocess reads retracted measurements. See docs/architecture/.../retraction.md         ✅
```

## Self-check before committing comments

1. Does every comment carry durable context a junior engineer could not infer, or is it a signal you have acted on?
2. Does each comment describe its own line, with no reference to a caller or distant scenario?
3. Are decisions in a linked doc, with the comment holding at most a pointer?
4. Did a workflow comment, a cluster of detail comments, or a comment duplicating a literal value get refactored, or did you consciously keep it and note why?
5. Has every kept comment passed the writing-style hard rules?
