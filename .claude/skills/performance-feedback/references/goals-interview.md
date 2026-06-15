# Goals interview

Runs when the goals file named in `work-config.md` is missing, or on `refresh goals`. Output: the goals file per `templates/goals.template.md`. The goals become evaluation dimensions, so each one must be observable in a normal week's artefacts – push back on goals that aren't.

## Step 1 – Read the seeds silently

Read the seed documents listed under "Goals-interview seeds" in `work-config.md` (self-review, peer feedback, promotion case, career matrix, and the current goals file when refreshing). Peer-feedback growth edges and promotion-case gaps are the prime goal candidates.

Distil 4–6 candidate goal areas: growth edges named by reviewers, gaps from the promotion attempt, and threads from the self-review. Each candidate gets one line: the area, and which seed it came from.

## Step 2 – Interview

Use AskUserQuestion, at most three rounds:

1. **Direction** – what should the next 6 months add up to? Options grounded in the seeds (e.g. promotion case, scope expansion, depth in a domain, leading larger initiatives), plus the candidate areas as a multi-select "which of these resonate".
2. **Per chosen area** (max 4 goals; push back above that – more goals means thinner signal per week): what does progress look like as **weekly observable evidence**? Offer concrete options drawn from how that area would show up in PRs, threads, and work items. A goal whose evidence only shows up quarterly is a bad dimension – reshape it with the user into its weekly leading indicators.
3. **Tradeoffs** – what gets deprioritised to make room. One question, free text via Other is fine.

Keep the user's own words in the goal names where possible.

## Step 3 – Write the file

Write the goals file per the template: frontmatter `set:` (today) and `horizon:` (today + 6 months), one `## Goal:` section per goal with **Why** (traced to a seed), **Progress looks like** (the weekly observables – these drive moment tagging), **Working against it looks like** (the red flags). Confirm the file back to the user in one line per goal. When refreshing, move the old file to `goals/archive/six-month-goals-<old-set-date>.md` first.
