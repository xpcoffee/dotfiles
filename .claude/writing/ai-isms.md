# AI-isms

Habits in AI-drafted prose that I correct by hand. This list changes often, as new isms turn up and old ones stop appearing. The numbered hard rules in the writing-style skill are the stable set, and this file does not repeat them.

**Reading it.** Check drafts against every entry marked `status: rule`. Entries marked `status: candidate` are being watched, not enforced.

**Adding to it.** `/ism "phrase" -> rewrite` appends a sighting to `writing/ai-isms-inbox.md` in my notes repo, which is private because sightings are verbatim text from real drafts. `/ism-review` merges that inbox into this file, promotes anything with 3 sightings, and prunes candidates that went 90 days without a repeat. Rules are capped at 25; adding the 26th means folding or dropping one.

**Examples are generic on purpose.** This file is public. Every bad/good pair started as real text from a work draft and was rewritten onto a neutral domain: accounts, sessions, jobs, regions, endpoints, field devices, AdminUI and SupportUI. The habit each entry teaches is unchanged; only the nouns moved. `/ism-review` does that rewrite when it promotes a sighting, and the verbatim original stays in the private inbox.

**Seeded 2026-08-19** from three sources: the git history of the writing-style skill and its two deleted forks, the project memory directories, and hand-versioned drafts in my notes repo. Everything below has a real bad/good pair behind it.

---

## Rules

### Adverbial disjuncts
status: rule · sightings: 5 · first seen: 2026-05-26 · last seen: 2026-08-26

Sentence-level qualifiers that assert obviousness or sincerity instead of stating the claim: "plainly", "clearly", "simply", "honestly", "frankly", "basically", "admittedly", "arguably", "presumably", "fortunately", "surprisingly", "hopefully". Includes the preface version ("worth stating plainly", "honest answer") that frames the statement as notably candid, implying earlier ones were less so.

- Bad: "Clearly, he doesn't understand idempotency."
- Good: "He didn't engage with idempotency when asked."
- Bad: "Honest answer: the migration will slip."
- Good: "The migration will slip."

### AI register in sentence shape
status: rule · sightings: 3 · first seen: 2026-08-11 · last seen: 2026-08-26

Four tells that survive a banned-word scan: parallel triples, abstract nouns standing in for a specific fault ("a pattern where..."), one sentence carrying several claims joined by "and", and a trailing "which is" clause bolting a second claim onto a finished sentence.

- Bad: "outside the cluster, outside endpoint authorization, and outside the telemetry"; "auditing it legitimises a pattern where..."
- Good: "Review rejected it: the raw write path is the defect, and each control it bypasses (authorization, audit, telemetry) would have to be rebuilt client-side."
- Bad: "Each shard watches its own collections and nothing else, which is why work happens in the region holding that document."
- Good: "Each shard watches its own collections and nothing else. That is why work happens in the region holding that document."

### Metaphors in code identifiers and comments
status: rule · sightings: 1 · first seen: 2026-08-05 · last seen: 2026-08-05

The metaphor ban covers method names and inline comments, and it kept getting read as a prose-only rule.

- Bad: `LandRetryBudgetExhaustedAsync`
- Good: `FailJobAsync` or `PersistFailedJobAsync`, naming the write being performed

### Names of people in published output
status: rule · sightings: 2 · first seen: 2026-05-28 · last seen: 2026-08-05

Attribute to the role, the artefact, or the review, because people and ownership change and the source record already holds who said what. Watch for a capitalised first name followed by a speech verb.

- Bad: "Head of Product said the tier was wrong."
- Good: "Stakeholder feedback raised that the tier was wrong."

### Invented vivid specifics
status: rule · sightings: 1 · first seen: 2026-05-19 · last seen: 2026-05-19

Concrete-sounding detail added for texture that no source supports. Distinct from an unvalidated claim: the sentence is illustrative, so nobody thinks to check it.

- Bad: "The scope skill cites your last design review, so you skip the hour-long Loom."
- Good: Cite a real example, or describe the capability without the scene.

### Repeating a strong number
status: rule · sightings: 1 · first seen: 2026-05-19 · last seen: 2026-05-19

Restating the same validation figure, price tier, or adoption percentage in several sections reads as padding. State it once and refer back. An executive summary may repeat its own headline number.

- Bad: The same "34% of accounts" figure opening three separate sections.
- Good: The figure once, then "the 34% cohort above".

### Process instead of the design
status: rule · sightings: 7 · first seen: 2026-05-22 · last seen: 2026-08-26

Referring to how the document was reviewed rather than what it decided. The reader wants the engineering decision; the ticket record already holds the process. Includes the authoring session itself: referring to an earlier pass, a previous document iteration, or the numbers from the ticket that prompted the work.

- Bad: "A reviewer flagged this during persona-review, still Open, see Important finding 3."
- Good: "Retries are capped at three because the provider rate-limits at four per minute."
- Bad: "The earlier pass classified this as host-pinned."
- Good: "Blob reads take the serving region's storage account."

### Vague requirement words
status: rule · sightings: 1 · first seen: 2026-05-08 · last seen: 2026-05-08

Words that look like a requirement and set no threshold: "appropriate", "adequate", "reasonable", "timely", "as needed", "efficient", "user-friendly", "flexible", "best practice". Narrower than the numbers-over-adjectives rule (rule 6 in the skill), and each one has a named fix.

- Bad: "The endpoint must respond efficiently."
- Good: "The endpoint must respond within 200 ms at p95."

### First-person opinion as narration
status: rule · sightings: 8 · first seen: 2026-04-17 · last seen: 2026-04-17

In feedback and reports, the writer's reaction gets narrated as if it were the event. Describe what happened in the third person and let the assessment sit in its own tagged field.

- Bad: "His first design move was the one I liked most, and I noted it at the time."
- Good: "He proposed a manual remediation tool for the support team before any automation, reasoning that users are already reaching out. [user focus+] [ownership+]"

### Fragment lead-ins as slide headings
status: rule · sightings: 2 · first seen: 2026-08-19 · last seen: 2026-08-19

A bold lead-in cut down to a bare fragment, often an unresolved "it", instead of naming the subject.

- Bad: "**What triggers it.**" / "**The consequence.**"
- Good: "**What triggers the reveal-rule regression.**" / "**Consequence: the modal never closes.**"

### Agentive verbs for inanimate evidence
status: rule · sightings: 3 · first seen: 2026-08-19 · last seen: 2026-08-26

Evidence, a shape, or a read given a verb only an agent should take ("sits", "holds", "settles", "landed"), or hedged as "your read" instead of naming who concluded what.

- Bad: "The shape of the interaction landed on the retry path." / "Your read confirms it."
- Good: "The candidate retried three times before escalating."
- Bad: "the weight sits mostly on a session"
- Good: "most events for that account carry a session id"

### Structural metaphor for importance
status: rule · sightings: 2 · first seen: 2026-08-19 · last seen: 2026-08-20

"Load-bearing" and "anchors", borrowed from construction, mark a claim or decision as important instead of saying what depends on it.

- Bad: "the load-bearing one being *routing follows the data, not the call site*"
- Good: "the decision every downstream retry path depends on: routing follows the data, not the call site"

### Coined jargon
status: rule · sightings: 8 · first seen: 2026-08-18 · last seen: 2026-08-26

A new term invented to name something the reader could have been told in plain words, which then has to be looked up on every later mention.

- Bad: "contemporaneity", "occasion" for a session-like grouping, "id-form", "host-pinned", "disposition", "the right shape"
- Good: "how close in time the events are", "the session", "the internal identifier", "takes the serving region's connection", "what we decided", "what the code does instead"

### Clause that restates what the next sentence says
status: rule · sightings: 6 · first seen: 2026-08-24 · last seen: 2026-08-26

A lead-in that gives the reason or the gist, immediately followed by the sentences that give it properly, so the reader reads the same claim twice.

- Bad: "Reviewed per type, because both directions of error are worse than the defect being fixed." followed by a paragraph explaining both directions.
- Good: The paragraph alone.
- Bad: "The same two behaviours in both operator-facing apps, AdminUI and SupportUI, with no change to the persistence layer."
- Good: "Implement the following behaviours in both AdminUI and SupportUI:"

### Prose carrying what a diagram or example should carry
status: rule · sightings: 6 · first seen: 2026-08-19 · last seen: 2026-08-25

A decision tree, a state change, or a two-case comparison written as sentences, when a mermaid diagram, a worked example, or a code snippet would be read once instead of three times.

- Bad: three paragraphs describing which rate limit applies under four conditions.
- Good: a mermaid decision tree, plus one worked example with dates.

### Decision stated with no decider
status: rule · sightings: 4 · first seen: 2026-08-26 · last seen: 2026-08-26

A choice, a rejection, or an acceptance written as something that happened to the design, hiding who decided and leaving the reader unable to ask them.

- Bad: "It was rejected because refusal is hard to roll back." / "Accepted for now, and written down because nothing enforces the order."
- Good: "We rejected it because refusal is hard to roll back." / "We accept this for now and record it here, because nothing enforces the order."

### Observation left with no disposition
status: rule · sightings: 3 · first seen: 2026-08-21 · last seen: 2026-08-24

A problem named without saying whether it is fixed here, accepted, out of scope, or waiting on someone, so every item makes the reader ask the same unanswered question.

- Bad: "This is a defect in its own right rather than part of this design."
- Good: "Not fixed here. Filed as TICKET-4821 and listed in the follow-up page, because it needs the storage owner."

### Cross-reference in place of an explanation
status: rule · sightings: 3 · first seen: 2026-08-24 · last seen: 2026-08-24

Pointing the reader at another document or section for something the current sentence should have said, which costs them a round trip to learn one fact.

- Bad: "See the failure inventory for why this is out of scope."
- Good: "It is out of scope because the fix belongs to the device fleet, not this codebase."

### Sections ordered by how the analysis ran
status: rule · sightings: 3 · first seen: 2026-08-24 · last seen: 2026-08-24

A document sequenced by the order the author discovered things, or by which subsystem got the most investigation, rather than by what a reader needs next.

- Bad: the cheap short-term mitigation placed after the full architectural proposal; one subsystem given a chapter and the rest moved to a separate file.
- Good: problem, then recommendation, then a short summary with links, then the deeper problem, then the cheap mitigation, then the long-term design.

### Words spent before reaching the verb
status: rule · sightings: 6 · first seen: 2026-08-26 · last seen: 2026-08-26

A dummy subject, a cleft, or a bare copula standing between the reader and what the sentence actually says. Folds three entries that were the same habit seen at different points in the sentence: the existential opener, the pseudo-cleft, and "is" where a specific verb was available.

- Bad: "There are two in production, one in Europe and one in the United States."
- Good: "Production has two, one in Europe and one in the United States."
- Bad: "What the rule requires is that the connection is derived from the account."
- Good: "The rule requires that the connection come from the account."
- Bad: "The read-authorisation call is the precedent." / "Each terminal state has the same two-branch shape."
- Good: "The read-authorisation call sets the precedent." / "Each terminal state follows the same two-branch shape."

### Label-colon framing instead of a sentence
status: rule · sightings: 2 · first seen: 2026-08-18 · last seen: 2026-08-26

A bare label and a colon, or a noun phrase and a comma, used to introduce a fact, which reads as a form field rather than a sentence.

- Bad: "The cost: two extra lookups per request." / "117 sites, one shared component."
- Good: "Each request makes two extra lookups." / "Check the region in AccountPageBase and render a warning."

### Precision that does not serve the decision
status: rule · sightings: 2 · first seen: 2026-08-24 · last seen: 2026-08-26

An exact count given where the reader needs the category or the order of magnitude, so the number implies a precision the argument does not rest on. The inverse case of numbers-over-adjectives (rule 6 in the skill), and the reason that rule is not absolute.

- Bad: "Of the 77 endpoints reviewed, 16 drop the write while returning 200."
- Good: "This work addresses the failures where we lose data and report success."

### Section wrapper text
status: rule · sightings: 3 · first seen: 2026-05-19 · last seen: 2026-08-26

Scene-setting at the start of a section, or a wrap-up at the end. The hard rules against throat-clearing and summarising (rules 4 and 5 in the skill) cover a paragraph; the same habit reappears one level up, around a whole section. Folds the separate preamble and closer entries.

- Bad, opening: "Saved search is inherently personal and universally useful."
- Good, opening: "Users already expect saved searches: they ask for them unprompted in onboarding feedback."
- Bad, closing: "Taken together, these three constraints point at one design."
- Good, closing: End on the last fact or decision.

### Emphasis standing in for evidence
status: rule · sightings: 3 · first seen: 2026-05-19 · last seen: 2026-05-22

A sentence performing insight rather than carrying a claim a reader can check: a neat "X is Y" line, a strong claim with no reason attached, or drama borrowed from explainer writing. Folds the aphorism, unanchored-superlative and sensational-phrasing entries, which were one habit at three intensities.

- Bad: "Compliance paperwork is shipping debt."
- Good: "Compliance paperwork always lands at the worst time."
- Bad: "The scope is the artefact you're judged on."
- Good: "The scope is the most important part of the process: it grounds every downstream decision and is the only artefact stakeholders read end to end."
- Bad: "What's actually happening underneath is..." / "This is critical because..."
- Good: State the mechanism.

---

## Candidates

### Hedged verdict
status: candidate · sightings: 1 · first seen: 2026-04-17 · last seen: 2026-04-17

A two-sided opener where the document exists to state a call.

- Bad: "I'm leaning negative-mixed."
- Good: "I lean no."

### Scaffold text shipped as content
status: candidate · sightings: 1 · first seen: 2026-04-17 · last seen: 2026-04-17

Instructions for filling a section left in the draft body next to an empty template.

- Bad: "_(interviewer to write – use the scaffold below)_" above unfilled bullets.
- Good: The filled bullet, with the quote and timestamp.

### Gate metaphor for a boolean flag
status: candidate · sightings: 1 · first seen: 2026-08-20 · last seen: 2026-08-20

A config flag described as a mechanical gate ("gated shut") instead of naming the flag and its effect.

- Bad: "gated shut by `enable_traffic_routing = false`"
- Good: "disabled by `enable_traffic_routing = false`"

### Table cell as the container for an explanation
status: candidate · sightings: 1 · first seen: 2026-08-26 · last seen: 2026-08-26

A table used for rows that each need a paragraph, which forces three-sentence explanations into a cell and makes the widest column unreadable.

- Bad: an 11-row table whose Problem column holds three sentences each.
- Good: one heading per item, with the problem written out underneath.

### Defined terms as bold runs instead of headings
status: candidate · sightings: 1 · first seen: 2026-08-26 · last seen: 2026-08-26

A glossary written as bolded lead-ins inside one section, so no term is linkable and none appears in the document outline.

- Bad: ten terms as "**Shard.** ..." inside a single section.
- Good: one heading per term, alphabetised.

### Trailing and-it-is clause
status: candidate · sightings: 1 · first seen: 2026-08-25 · last seen: 2026-08-25

A second clause added only to stress the first, carrying no new information.

- Bad: "One endpoint is an exception, and it is cosmetic."
- Good: "One endpoint is an exception, at a cost of retry churn."

### Instructing the reader how to read
status: candidate · sightings: 1 · first seen: 2026-08-26 · last seen: 2026-08-26

Telling the reader what to make of the evidence instead of stating the conclusion.

- Bad: "Reading these three as a set: cross-region blob access was built and never made the default."
- Good: "These three routes tell one story: the team built cross-region blob access, proved it on a test route, and never made it the default."

### Nominalised subject for a rule about an actor
status: candidate · sightings: 1 · first seen: 2026-08-26 · last seen: 2026-08-26

An action turned into the subject of "should not happen", which hides who is supposed to stop doing it.

- Bad: "A field device creating a job for an out-of-region account should not happen."
- Good: "A field device should not create a job for an out-of-region account."

### Two names for one thing in one document
status: candidate · sightings: 1 · first seen: 2026-08-26 · last seen: 2026-08-26

Switching between synonyms the reader has to work out are the same, after one of them was established.

- Bad: a section that establishes "region", then uses "shard" for the same thing.
- Good: pick one and keep it.

### Implementation detail where design intent belongs
status: candidate · sightings: 1 · first seen: 2026-08-26 · last seen: 2026-08-26

A design section that lists which components or files the work touches, instead of what the design does for the person using it.

- Bad: naming each design-system component key the new screen would use.
- Good: what the operator sees, and why that stops the failure.

### Effort given as elapsed time
status: candidate · sightings: 1 · first seen: 2026-08-24 · last seen: 2026-08-24

An hour or day estimate attached to a proposal in a design document.

- Bad: "Roughly two days of work."
- Good: name the pieces of work and let planning size them.

### Artefact longer than its content needs
status: candidate · sightings: 1 · first seen: 2026-08-18 · last seen: 2026-08-18

A decision record or design page padded well past the decision it records.

- Bad: a decision record where the decision occupies two paragraphs of eleven.
- Good: the decision, what changed in the context, and how the decision answers it.

---

## Out of scope

Code-comment habits (comments restating the code, comments narrating a caller, comment-delimited stages that should be extracted methods) are already enforced by the comment rules in `CLAUDE.md` and the junior-engineer reviewer agent. Prompt-authoring habits for downstream models are a separate concern from prose style.

Changes to the numbered hard rules in the writing-style skill are tracked in `writing/ai-isms-fold-in.md` in my notes repo, not here. That backlog cites the private plugin branch the skill lives on.
