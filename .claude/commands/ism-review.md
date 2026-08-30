---
description: Merge the AI-ism inbox into the curated list, promote repeat offenders, prune dead entries
argument-hint: [optional: a specific pattern to review]
allowed-tools: Bash, Read, Edit, Write
---

Curate the AI-ism store. Three files, in two repos:

- `~/code/personal/notes/writing/ai-isms-inbox.md`: raw sightings appended by `/ism`. **Private.** Verbatim text from real drafts.
- `~/code/personal/notes/writing/ai-isms-fold-in.md`: the backlog of changes owed to the numbered hard rules in the writing-style skill. **Private.** Cites the plugin branch the skill lives on.
- `~/.claude/writing/ai-isms.md`: the curated list, which the writing self-check reads. **Public**, stowed from the dotfiles repo.

The middle step of every promotion is sanitising: a sighting arrives verbatim and private, and lands generic and public.

## 1. Merge

Read the inbox and the curated list. For each inbox line, decide whether it is the same ism as an existing entry, or a new one. Same ism means same underlying habit, even when the words differ: "this approach streamlines X" and "this solution enables Y" are one ism, not two.

- **Existing entry**: increment `sightings`, set `last seen` to the sighting date, and add the bad/good pair to its examples only when it shows a shape the existing examples do not already cover. Two near-identical examples earn their place only if the second one is what makes the pattern recognisable.
- **New entry**: add it with `sightings: 1`, `status: candidate`.

Delete every inbox line you absorbed. Leave behind anything you could not interpret, with a note on the line saying what is missing.

## 2. Sanitise every example before it enters the curated list

`ai-isms.md` is public. An example that names a real system, product, ticket, colleague, customer figure, or internal codename does not go in as written. Rewrite it onto the neutral domain the file already uses, and keep the sentence shape identical, because the shape is the whole lesson.

The concrete substitutions live in `~/code/personal/notes/writing/ai-isms-substitutions.md`, which is private for the same reason the inbox is: listing the real terms names the domain as plainly as using them would. Read that file before you rewrite anything, and add a row to it when a sighting needs a term it does not cover.

The public vocabulary those substitutions land on, so examples stay consistent with each other: accounts and users for people, sessions for scheduled events, jobs for units of work, field devices for hardware, shards and regions for deployment units, AdminUI and SupportUI for internal apps, operators for staff, saved search for a product feature, `TICKET-4821` for a ticket id, and a role or artefact in place of a person's name.

Check the result: nobody reading only the public file should be able to name the system the example came from. When a sighting cannot be genericised without losing the lesson, leave it in the inbox and say so in the report rather than publishing it.

The verbatim original stays in the inbox line you keep, or is deleted with the line. Never copy verbatim work text into `ai-isms.md`.

## 3. Promote

An entry becomes `status: rule` when it has 3 or more sightings, or when its line carries the word `always`. Promoted entries are what the self-check enforces; candidates are only being watched.

Cap the rule list at 25 entries. At the cap, promoting means demoting or folding something else, so say which and why. Prefer folding: when several rules are the same habit seen from different angles, write the general rule and delete the instances.

## 4. Prune

Flag for deletion any candidate with 1 sighting and a `last seen` date more than 90 days old. One sighting in three months was a one-off, and carrying it costs attention at every review. List them and ask before deleting.

## 5. Report

Tell the user, in this order:

1. What got promoted, with its sighting count.
2. Which examples you rewrote to genericise them, and anything you could not genericise.
3. What is at 2 sightings, so they know what is next.
4. What you propose to prune, and wait for their answer.
5. The current rule count against the cap of 25.

Numbers, not adjectives. Do not restate entries they can read in the file.

## Entry format in `ai-isms.md`

```
### <pattern named in a few words>
status: rule | candidate · sightings: N · first seen: YYYY-MM-DD · last seen: YYYY-MM-DD

<one sentence on what the habit is and why it reads as machine-written>

- Bad: "<generic rewrite>"
- Good: "<generic rewrite>"
```

Keep the prose in each entry to one sentence. The examples do the teaching; an entry that needs a paragraph of explanation is a rule that has not been named properly yet.

Do not commit. Two repos are in play, and the dotfiles change is public.
