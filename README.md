# Sales Team

Claude Code skills for finding relevant companies and running deep per-account
sales research — built by hand-picking pieces from a few larger skill repos,
not cloning any of them wholesale.

Two layers, kept deliberately separate:

1. **Discovery** (`icp-onboarding`, `icp-prompt-builder`, `lead-research-assistant`)
   — find and grade a list of companies. **Zero paid third-party APIs** — runs
   on Claude's own reasoning plus built-in web-search/fetch.
2. **Per-account deep dive** (everything under `sales/` and the `sales-*`
   skills) — once you've picked a company to actually pursue, go deep on it:
   research, decision-makers, competitive position, objection prep, full
   prospect scoring. Also no paid APIs — same principle, applied one company
   at a time instead of across a list.

## Layer 1 — Discovery (no paid APIs)

| Skill | From | What it does |
|---|---|---|
| `skills/icp-onboarding` | [growthenginenowoslawski/coldoutboundskills](https://github.com/growthenginenowoslawski/coldoutboundskills) | Conversational ICP intake. Scrapes your own website for context, interviews you on target industries/size/geography/disqualifiers, splits **hard filters** (must match) from **soft preferences** (nice-to-have), saves a structured `client-profile.yaml`. |
| `skills/icp-prompt-builder` | same | Builds and tunes an AI qualification prompt against a sample of companies, iterating with your corrections until 2 rounds in a row need none. Runs entirely as Claude Task sub-agents — no external API key, ever. |
| `skills/lead-research-assistant` | [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | The actual company *finder*. Given a product/ICP description, searches for and scores matching companies, with contact-strategy suggestions per lead. |

**Flow:** `icp-onboarding` (define who you want, once) → `lead-research-assistant`
(run repeatedly with different sector/region framings to surface candidates)
→ `icp-prompt-builder` (tune a qualification prompt on a sample, apply it to
filter/rank the full pool).

**Limitations:** modest scale (`lead-research-assistant` is built for a
10-20 company shortlist per run, not bulk volume — building a big list means
running it many times and merging results yourself), no contact enrichment
(no phone/email by design — add that separately later), and results aren't
verified (spot-check anything found via web search before acting on it at
volume).

## Layer 2 — Per-account deep dive (no paid APIs)

From [zubair-trabzada/ai-sales-team-claude](https://github.com/zubair-trabzada/ai-sales-team-claude)
— hand-picked, not the full repo. All of these take **one company URL** as
input; they don't discover companies, they analyze one you already picked.

| Skill | Command | What it does |
|---|---|---|
| `sales/SKILL.md` | *(orchestrator — no direct command)* | Routes every `/sales <command>` to the matching skill below. **Required for any `/sales ...` command to work at all** — nothing else in this layer runs without it. |
| `sales/SKILL.md` (quick mode) | `/sales quick <url>` | Implemented inline in the router itself, not a separate file. WebFetch the homepage only, no subagents, no file written — a 60-second scorecard straight to the terminal (top 3 opportunities, top 3 concerns). *(You asked for this one directly.)* |
| `skills/sales-prospect` | `/sales prospect <url>` | The flagship command. Launches the 4 skills below as parallel subagents, aggregates them into one scored `PROSPECT-ANALYSIS.md`. *(You asked for this one directly.)* |
| `skills/sales-contacts` | `/sales contacts <url>` | Decision-maker mapping: buying committee, org chart, personalization anchors. *(You asked for this one directly.)* |
| `skills/sales-competitors` | `/sales competitors <url>` | Competitive intelligence: current vendor signals, switching costs, positioning angles. *(You asked for this one directly.)* |
| `skills/sales-objections` | `/sales objections <topic>` | Objection-handling playbook. *(You asked for this one directly.)* |

**Added automatically — `sales-prospect` doesn't run without them:**

| Skill | Why it's here |
|---|---|
| `skills/sales-research` | `sales-prospect`'s "sales-company" subagent — company research & firmographics. Hard dependency, not optional. |
| `skills/sales-qualify` | `sales-prospect`'s "sales-opportunity" subagent — BANT/MEDDIC qualification. Hard dependency, not optional. |

**Removed:** the original upstream `sales-prospect` launched a 5th subagent
(`sales-strategy`, backed by a `sales-outreach` skill) that drafted a
ready-to-send *email* as part of the report. Since this is for calling, not
emailing, that subagent, its scoring weight, and the "Ready-to-Send First
Email" report section were all stripped out — `sales-prospect` here is the
4-subagent version, with scoring reweighted across the remaining 4 categories
(Company Fit 30% / Contact Access 25% / Opportunity Quality 25% / Competitive
Position 20%). `sales-outreach` itself was deleted from the repo since nothing
else needs it. The report still keeps a trimmed "Personalization Research"
section (trigger events, anchors) since that's useful on a call too — just
not wrapped in an email draft.

Left out on purpose: `sales-icp` (overlaps with `icp-onboarding`, less
reusable), `sales-followup` (email-specific), `sales-prep` / `sales-proposal`
/ `sales-report` / `sales-report-pdf` (not requested). Add any of these later
the same way — they're all single self-contained `SKILL.md` files with no
further dependencies.

**Top-level `agents/` and `templates/` folders from the source repo were not
brought in** — no hard dependency on either:
- The `agents/*.md` persona files (`sales-company.md`, `sales-strategy.md`,
  etc.) are never referenced by `sales-prospect`'s actual instructions — it
  explicitly launches subagents as `subagent_type: "general-purpose"`, driven
  by the `SKILL.md` files already here, not by those persona files.
- `templates/*.md` (outreach templates, proposal template, meeting-prep
  template) all belong to skills that were left out or removed.

**`scripts/analyze_prospect.py` was added**, at
`skills/sales-prospect/scripts/analyze_prospect.py`. `sales-prospect` treats
it as optional ("if the script is not available or fails, continue using
plain `WebFetch` data instead") — but it's genuinely free to include: pure
Python standard library (`urllib`, `html.parser`, `re`, `ssl`), no `pip
install`, no API key. It fetches the target URL and pulls out structured
metadata (title/meta tags, tech-stack signals, social links, contact
patterns) that `sales-prospect` folds into its discovery briefing. The
repo's other three scripts (`contact_finder.py`, `generate_pdf_report.py`,
`lead_scorer.py`) were left out — they belong to skills not in this repo.

## Installing — one command, one time (recommended for the team)

This repo is public, so there's no login step for this at all — anyone can
run this and it just works.

**Prerequisite: `git` has to already be installed.** Check with `git
--version`. If that doesn't print a version number, install it first — see
[ONBOARDING.md](ONBOARDING.md) Step 1, and specifically **don't** click
through Apple's "install command line developer tools" popup if one
appears (that's a ~14GB download you don't need just for this) — the
lightweight [git-scm.com](https://git-scm.com/download/mac) installer
(~200MB) gets you the same `git` command without it.

```bash
git clone https://github.com/YHavshush/sales.git ~/sales && bash ~/sales/install.sh
```

Once `git` is there, that command is the entire setup. It clones the repo to `~/sales` and symlinks every
skill into `~/.claude/skills` — a symlink instead of a copy, so it always
points at the live file in `~/sales`, not a frozen snapshot from today.

**You will not need to run this again**, and you will not need to run
`git pull` yourself either. Every skill in this repo pulls the latest version
of the repo automatically, silently, as its first step, before it does
anything else — so simply *using* a skill is what keeps you in sync. A skill
fix, or an update to the shared ICP, reaches you the next time you invoke
anything, with nothing for you to remember or run. (Re-running the install
command above is only ever needed if a brand new skill gets added to the
repo later — existing ones update themselves.)

The only person who ever needs a GitHub login is whoever *writes* an ICP
update (`/icp-onboarding` ends with a `git push`, which needs write access).
Everyone just reading/using skills needs nothing.

## Installing — copy (simpler, but a one-time snapshot)

If you're using this solo, don't care about staying in sync, or your OS/setup
makes symlinks awkward, plain copies work too — you'll just need to re-run
this (or `git pull` + re-copy) manually whenever you want the latest version:

```bash
# Discovery layer
cp -r skills/icp-onboarding skills/icp-prompt-builder skills/lead-research-assistant ~/.claude/skills/

# Per-account deep-dive layer (sales/ is a top-level folder, not under skills/)
cp -r sales ~/.claude/skills/
cp -r skills/sales-prospect skills/sales-contacts skills/sales-competitors skills/sales-objections \
      skills/sales-research skills/sales-qualify ~/.claude/skills/skills/
```

Or copy into a project's `.claude/skills/` instead, to keep them project-scoped.

## Using this repo as the sales team's single source of truth

The pattern that makes this work as shared team infrastructure, not just a
personal toolkit:

**1. The ICP lives in this repo, not in someone's home directory.**
`icp-onboarding` writes `profiles/<business-slug>/client-profile.yaml`
relative to this repo's own root — not `~/cold-email-ai-skills/...` (that
was the upstream default and doesn't make sense once this is a shared, cloned
repo). That's what makes it committable and shareable in the first place.

**2. Writing an ICP update means committing and pushing it.**
`icp-onboarding`'s last step now is `git add` / `commit` / `push` on the
profile file — a local-only edit doesn't help the team, only a pushed one
does. If two people edit the ICP at once, a normal `git pull --rebase` +
push resolves it same as any other file in this repo.

**3. Every skill pulls the latest repo before it does anything else —
automatically, no one has to remember to sync.** `sales/SKILL.md` (so every
`/sales <command>`), `icp-prompt-builder`, and `lead-research-assistant` all
run a silent `git pull` as their first step. This is what makes updates
reach the whole team "automatically" from the user's point of view:
whoever wrote a fix or an ICP change just pushes it once, and the next
person to use *any* skill gets it, with nothing for them to run or remember.
If the pull fails (offline, whatever) it's silently skipped and the skill
continues with whatever's already on disk — never blocks, never errors.

**4. Skills are symlinked, not copied** (`install.sh` sets this up in one
shot) — so a fix to any `SKILL.md`, not just the ICP, is picked up the moment
it's pulled, with no reinstall step.

**5. The repo is public, so reading needs no login at all.** Only writing an
ICP update needs GitHub write access (`icp-onboarding`'s final `git push`) —
everyone just running skills, including the sync pulls above, needs nothing.

**Net effect:** the one-time `install.sh` run is the *only* setup step for
the whole system, and after that, using the tools *is* the sync mechanism —
both "here's the current ICP" and "here's the current tooling" stay current
for every teammate automatically. If your team wants a gate on ICP changes
(so one person can't silently redefine who the whole team is calling), the
natural next step is to stop pushing to `main` directly and require a pull
request for changes under `profiles/` — GitHub's branch protection rules can
enforce that without changing anything about how the skills themselves work.

## Attribution

- `icp-onboarding`, `icp-prompt-builder`: from
  [growthenginenowoslawski/coldoutboundskills](https://github.com/growthenginenowoslawski/coldoutboundskills)
  (see that repo for its license).
- `lead-research-assistant`: from
  [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
  (see that repo for its license).
- `sales/`, `sales-prospect`, `sales-contacts`, `sales-competitors`,
  `sales-objections`, `sales-research`, `sales-qualify`:
  from [zubair-trabzada/ai-sales-team-claude](https://github.com/zubair-trabzada/ai-sales-team-claude)
  (see that repo for its license). `sales-prospect` and `sales/SKILL.md` were
  both modified locally (email subagent removed, scoring reweighted) — see
  above.
