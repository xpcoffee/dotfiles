---
name: writing-style
description: Use when drafting any text. Specs, decisions, ADO/DevOps comments, code review comments, meeting notes, status updates, Teams messages, emails, PR descriptions, or any document. Applies hard style rules and a self-check before presenting.
---

# Writing style

These rules apply to ALL text you draft. Specs, decisions, code review comments, DevOps comments, status updates, published documents – everything.

Read this file completely before drafting anything. Refer back to it before presenting each draft.

## Hard rules

Violating any of these means the draft is not ready to show.

1. **No filler phrases.** Delete on sight: "it's worth noting", "importantly", "it should be noted", "this is a key area", "there is a significant opportunity", "this represents", "this ensures", "this enables", "this allows for", "in order to", "as part of", "from a ... perspective", "moving forward", "at the end of the day", "it is important to note". These add zero information.

2. **No weasel words.** Delete: "various", "significant", "substantial", "comprehensive", "robust", "streamlined", "enhanced", "leveraged", "utilised", "facilitated", "optimised", "aligned", "synergy", "holistic", "scalable" (unless literally about infrastructure), "innovative", "cutting-edge", "best-in-class", "world-class", "state-of-the-art", "seamless", "enterprise-grade", "cloud-integrated". If you catch yourself using these, replace with the specific thing you mean.

3. **One adjective per noun, maximum.** "A clear, compelling, data-driven argument" → pick one. If you need two, the noun is wrong.

4. **No throat-clearing.** First sentence of every paragraph must contain information. Never open with "In order to understand why...", "When we think about...", "It's clear that...", "As we look at...". Cut to the point.

5. **No summaries of what you just said.** Don't end sections with "In summary, ...", "This means that...", "Taken together...". The reader just read it.

6. **Numbers over adjectives.** "Significant drop-off" → "35% drop-off". "Many users" → "32,750 users". If you don't have the number, say so – don't paper over it with an adjective.

7. **Active voice.** "Conversion is improved by BNPL" → "BNPL improves conversion". Passive voice hides who does what.

8. **No AI tells.** Never write "This approach...", "This solution...", "This initiative...", "By doing X, we can Y". Write like a human talking to another human. Read your draft aloud – if it sounds like a consultant's slide deck, rewrite it.

9. **No em dashes.** Use en dashes (–) or restructure the sentence with commas, colons, or full stops. The em dash character (—) is banned.

10. **Describe what a thing is or does, positively.** State Y directly. The "X, not Y" contrast shape is banned, including mid-sentence ("depends on whether any is open, not how many") and standalone negations ("it does not reschedule itself", "only sooner, never later"). Rewrite every such negation as a positive statement: "it does not reschedule itself" → "it keeps its original schedule". Using the contrast once for genuine emphasis is a stylistic choice; as a habit it reads as a tic.

11. **No random metaphors.** Write the literal mechanism. Banned: "ratchets", "backstop", "strands", "hand off", "lands in", "born from", "sits on top of", "load-bearing", "anchor", "trip over", "tripwire", "surface" (as a verb), "promote", "demote". If a literal description doesn't fit, find a better noun or verb. Bad: "The queue is the load-bearing backbone of throughput." Good: "The queue buffers requests so workers process them at a steady rate."

12. **Simplest correct word wins.** Plain English over fancy or jargon equivalents: "divergence" → "difference", "utilise" → "use", "commence" → "start", "subsequently" → "then".

13. **Cut adjectives that carry no meaning.** If the sentence reads the same without it, drop it: "underlying", "actual", "real", "key", "core". Bad: "The underlying data model is a Cosmos document." Good: "The data model is a Cosmos document." (Rule 3 caps the count; this rule kills the filler ones outright.)

14. **Don't stack jargon into compound nouns.** Three pieces of jargon glued together is unreadable. Bad: "scan-result-item as the work-coordination primitive." Good: "Coordinate the workers using state in a dedicated scan-result document."

15. **Every claim must be valid.** Include a claim only when you have validated it. If uncertain, qualify it or drop it. Bad: "The change is invisible because the metric is flat." Good: "The change is hard to see because the dashboard has no week-over-week comparison."

16. **State context up front or link to it.** Give the reader what they need to parse a sentence, or link to where they can read it. Spell out short forms and project codes the first time you use them, and write the full project term unless the short form is already established — invent no abbreviations like "body-comp" or "eng-ctx". Bad: "tier table down to £0.75/call at 1M+ lifetime cumulative", "the apps", "pilot", "provided we pass-through." Good: name which apps, which pilot, and what passes through.

## Tone

- Write person to person. Internal doc, but not corporate.
- Confident, not boastful. State what's true; don't sell.
- Short sentences. If a sentence has more than one comma, split it.
- Specific over general. Always.

## Self-check before presenting any draft

Before showing a draft to the user, scan it against rules 1-16 above. If any violation exists, fix it first. Do not present text that violates these rules and ask the user to fix it – that's your job.
