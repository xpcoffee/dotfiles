---
name: investigate-oncall-issues
description: Batch-investigate auto-cut oncall alert work items assigned to me, root-cause each from production logs and the source repo, classify each as urgent, structural, or noise, and post investigation notes
user-invocable: true
allowed-tools: Bash, Read, Grep, Glob, Agent, TaskCreate, TaskUpdate, Write, Edit
---

# Investigate auto-cut oncall issues

Investigate every auto-cut oncall alert work item assigned to me that has no investigation yet, one at a time, using a subagent per issue for the log dives. Deliver a summary that splits the issues into three buckets: **urgent** (act in days), **structural** (hand to a team over weeks), and **noise or duplicate**.

**Arguments:** $ARGUMENTS

Read `references/work-config.md` first for the work-specific details: the tracker project, the markers that identify an auto-cut alert, the log-query tool with its resource and role map, the ID conventions, and the notes path for the summary. This file is per-user and gitignored; the rest of the skill is general. If it is missing, tell the user the skill needs it and what it must contain, then stop. Do not invent values.

Parse optional arguments; otherwise use the defaults:

- assignee → the current user
- specific work item IDs → investigate only those, skip discovery
- include closed states → default is open states only
- area path or date window → narrows discovery
- summary target → in-chat by default; a journal flag also writes the journal entry (Step 5)

## Step 1: Discover candidate issues

Query the tracker for auto-cut alert items assigned to the target user, using the markers in `work-config.md`. For each candidate, read its comment thread.

An issue already has an investigation when it carries a substantive analysis comment: a root-cause write-up, log findings, or impact analysis. Paging notes, chat-room links, and one-line operator questions do not count. Skip the issues that already have a full analysis. For an issue with a partial analysis or an open question, build on what is there.

## Step 2: Triage and cluster before diving

Read the full fields of each candidate to extract the alert rule, fire time in UTC, threshold, severity, and the alert's own embedded query if it has one. From the titles, rules, jobs, and entities, group the candidates so duplicates show up before any log dive:

- One alert rule firing more than once → likely exact duplicates. Investigate together and cross-link.
- One job or exception recurring across different days or entities → one recurring defect, separate incidents.
- Several alerts around one operation, e.g. a bulk migration → they can share one root cause yet have separate impact and recovery scopes. Keep them separate: the code fix can be one change while the data recovery runs per entity.

Create a task list with one task per issue or cluster, plus a final synthesis task.

## Step 3: Investigate each issue

Run the investigations sequentially so results stay clean and the log and tracker calls do not collide. For a known duplicate pair, investigate the shared signal once and note the duplicate.

Spawn a general-purpose subagent per issue or cluster. Each subagent prompt must include:

1. **The alert facts** already extracted: rule, fire time, threshold, severity, embedded query, and any operator or analysis notes from the comments. State what is already known so the subagent extends it.
2. **The log-query rule** from `work-config.md`: which tool to use, the resource and role map, the output and ID conventions, and the constraint to avoid the raw cloud CLI. Point the subagent at the log-diving skill named in `work-config.md`.
3. **The investigation:** reconstruct what fired from a window starting roughly 30 minutes before the fire time, find the exact failing operation, job, or exception, and the affected entities by external id only. Read the source repo for the code path when the cause is in code. Establish recurrence by querying the same signature across the last 30 days and counting occurrences and distinct members.
4. **The classification**, stated decisively with a one-line reason:
   - **Urgent (act in days):** ongoing member-facing impact or a data or safety risk. Examples: stranded records needing manual recovery, a broken member assessment, a missing device blocking a clinic flow.
   - **Structural (hand to a team, days to weeks):** a real defect that needs code or design work and can wait. Name the owning area and the fix.
   - **Noise, tooling, or duplicate:** transient with no impact, an over-sensitive threshold, a detector false positive, an alert-formatter gap, or a duplicate of another issue.
5. **The note** to post on the work item (see Step 4 for the permission gate), with sections: Log Findings (queries, window, what was seen), Root cause or code path, Impact and recurrence (count, distinct members, member-facing yes or no, ongoing yes or no), Classification with suggested owner and fix, and Relationship to other issues. Write it in the house style: terse, senior tone, HTML formatting, en dashes instead of em dashes, no filler. Apply the `writing-style` skill.
6. **The return value:** a compact plain-text summary covering relationship, root cause, recurrence, impact, classification, and the exact queries run with row counts. Return only the summary; the posted HTML stays on the work item.

## Step 4: Posting permission gate

A comment on a work item is an external-system write. Auto-mode treats each post as a fresh write and warns on it even with a session grant. Confirm with the user up front that subagents may post the notes. State that the security warnings will appear and are expected. Without a grant, have the subagents return findings only and post nothing.

## Step 5: Synthesize

After all investigations, produce one cross-issue summary:

- A table per bucket (urgent, structural, noise). Each row: work item, one-line root cause, action and owner.
- A duplicate and cluster map: which IDs are exact duplicates, which share a root cause as separate incidents.
- Cross-cutting observations, e.g. thresholds that fire on one or two events, or formatter gaps, with the owner of each fix.

When the journal flag is set or the user asks, append the summary as a dated section in the notes journal named in `work-config.md`. Leave it uncommitted unless asked.

## Notes

- Drop non-alert oncall items, e.g. access requests, from this flow.
- Weight low-severity alerts with single-event thresholds toward the noise bucket.
- When two members appear to share one id, or a recovery path could attach one member's data to another's record, flag it as a patient-safety finding whatever the severity.
