# Sales Team Skills

The team's shared toolkit for finding companies to target and researching
them before you call. Built into Claude Code, kept up to date for everyone
automatically.

**New here?** → [ONBOARDING.md](ONBOARDING.md) gets you set up in one message to Claude Code.

---

## 🚀 Get started

Open Claude Code and paste this:

```
Please set up the shared sales team skills for me:
1. Check if git is installed. If it isn't, install it yourself (prefer
   `brew install git`, or the small git-scm.com installer — not Apple's
   Xcode Command Line Tools, which is a ~14GB download we don't need here).
2. Run: git clone https://github.com/YHavshush/sales.git ~/sales
3. Run: bash ~/sales/install.sh
```

Approve whatever it asks permission for. That's the whole setup — you do
this **once, ever**, per computer. Full details in [ONBOARDING.md](ONBOARDING.md).

---

## 🛠️ What you can actually do with this

Once it's set up, just talk to Claude Code in plain language, or use the
short commands below if you prefer.

| I want to... | Say this to Claude |
|---|---|
| Define who our ideal customer is | *"Help me set up our ICP"* |
| Find companies that match that profile | *"Find me leads that fit our ICP"* |
| Get a 60-second gut check on one company | `/sales quick <url>` |
| Get the full picture before I call someone | `/sales prospect <url>` |
| Just research a company's background | `/sales research <url>` |
| Figure out who to actually talk to there | `/sales contacts <url>` |
| See if this lead is worth chasing | `/sales qualify <url>` |
| Know what they're already using / competing with | `/sales competitors <url>` |
| Prep answers for pushback I expect on a call | `/sales objections <topic>` |

None of this costs anything beyond your normal Claude usage — no extra
accounts, no paid data services, no API keys to manage.

---

## 🔄 How "everyone stays up to date" actually works

Think of it like a shared Google Doc instead of downloaded copies. There's
one online "master copy" of our tools and our target-customer definition.
Your Claude Code is linked to that master copy, not a personal snapshot —
so when someone improves a tool, or updates who we're targeting, you get
that update automatically the next time you use anything here. Nothing to
remember, nothing to re-download.

---

## ❓ Something not working?

- **An error you don't understand?** Paste the exact error to your Claude
  Code session, or forward it to whoever's helping you set this up. It's
  much faster to fix from the real message than a description of it.
- **Setting up on a brand-new Mac?** See [ONBOARDING.md](ONBOARDING.md) —
  it covers the one hiccup that comes up on machines that have never had
  developer tools installed before.
- **Want to double check what's actually installed?** Ask Claude: *"is the
  sales team skill set up correctly?"*

---
---

# For the technically curious

Everything below is background on how this repo is built and why — useful
if you're maintaining it, not required reading to just use it day to day.

## Two layers, kept deliberately separate

1. **Discovery** (`icp-onboarding`, `icp-prompt-builder`, `lead-research-assistant`)
   — find and grade a list of companies. **Zero paid third-party APIs** — runs
   on Claude's own reasoning plus built-in web-search/fetch.
2. **Per-account deep dive** (everything under `sales/` and the `sales-*`
   skills) — once you've picked a company to actually pursue, go deep on it:
   research, decision-makers, competitive position, objection prep, full
   prospect scoring. Also no paid APIs — same principle, applied one company
   at a time instead of across a list.

### Layer 1 — Discovery

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
running it many times and merging results yourself), no contact enrichment,
and results aren't verified (spot-check anything found via web search
before acting on it at volume).

### Layer 2 — Per-account deep dive

From [zubair-trabzada/ai-sales-team-claude](https://github.com/zubair-trabzada/ai-sales-team-claude)
— hand-picked, not the full repo. All of these take **one company URL** as
input; they don't discover companies, they analyze one you already picked.

| Skill | Command | What it does |
|---|---|---|
| `sales/SKILL.md` | *(orchestrator — no direct command)* | Routes every `/sales <command>` to the matching skill below. **Required for any `/sales ...` command to work at all** — nothing else in this layer runs without it. |
| `sales/SKILL.md` (quick mode) | `/sales quick <url>` | Implemented inline in the router itself, not a separate file. WebFetch the homepage only, no subagents, no file written — a 60-second scorecard straight to the terminal. |
| `skills/sales-prospect` | `/sales prospect <url>` | The flagship command. Launches the 4 skills below as parallel subagents, aggregates them into one scored `PROSPECT-ANALYSIS.md`. |
| `skills/sales-contacts` | `/sales contacts <url>` | Decision-maker mapping: buying committee, org chart, personalization anchors. |
| `skills/sales-competitors` | `/sales competitors <url>` | Competitive intelligence: current vendor signals, switching costs, positioning angles. |
| `skills/sales-objections` | `/sales objections <topic>` | Objection-handling playbook. |
| `skills/sales-research` | *(subagent only)* | `sales-prospect`'s "sales-company" subagent — company research & firmographics. Hard dependency of `sales-prospect`. |
| `skills/sales-qualify` | *(subagent only)* | `sales-prospect`'s "sales-opportunity" subagent — BANT/MEDDIC qualification. Hard dependency of `sales-prospect`. |

**Removed from the upstream version:** the original `sales-prospect`
launched a 5th subagent (`sales-strategy`, backed by a `sales-outreach`
skill) that drafted a ready-to-send *email* as part of the report. Since
this team calls rather than emails, that subagent, its scoring weight, and
the "Ready-to-Send First Email" report section were all stripped out —
`sales-prospect` here is the 4-subagent version, with scoring reweighted
across the remaining 4 categories (Company Fit 30% / Contact Access 25% /
Opportunity Quality 25% / Competitive Position 20%). `sales-outreach` was
deleted from the repo entirely since nothing else needs it. The report
keeps a trimmed "Personalization Research" section (trigger events,
anchors) since that's useful on a call too — just not wrapped in an email
draft.

Left out on purpose: `sales-icp` (overlaps with `icp-onboarding`, less
reusable), `sales-followup` (email-specific), `sales-prep` / `sales-proposal`
/ `sales-report` / `sales-report-pdf` (not requested). Add any of these later
the same way — they're all single self-contained `SKILL.md` files with no
further dependencies.

Top-level `agents/` and `templates/` folders from the source repo weren't
brought in (no hard dependency on either — `sales-prospect` launches
subagents as `subagent_type: "general-purpose"`, driven by the `SKILL.md`
files already here, not by the `agents/*.md` persona files; `templates/*.md`
all belong to skills that were left out or removed).

`scripts/analyze_prospect.py` **was** added, at
`skills/sales-prospect/scripts/analyze_prospect.py` — pure Python standard
library, no `pip install`, no API key. `sales-prospect` treats it as
optional and degrades to plain `WebFetch` if it's missing, but it's free to
include. The repo's other three scripts (`contact_finder.py`,
`generate_pdf_report.py`, `lead_scorer.py`) were left out — they belong to
skills not in this repo.

## Installing — one command, one time

This repo is public, so there's no login step for reading it at all.

**Prerequisite:** `git` has to be installed (`git --version` to check) — see
[ONBOARDING.md](ONBOARDING.md) if it isn't, and specifically avoid Apple's
14GB Xcode Command Line Tools popup in favor of `brew install git` or the
small [git-scm.com](https://git-scm.com/download/mac) installer.

```bash
git clone https://github.com/YHavshush/sales.git ~/sales && bash ~/sales/install.sh
```

That clones the repo to `~/sales` and symlinks every skill into
`~/.claude/skills` — a symlink instead of a copy, so it always points at the
live file in `~/sales`, never a frozen snapshot.

You will not need to run this again, and you will not need to run `git pull`
yourself either — every skill in this repo pulls the latest version of the
repo silently as its first step, so simply *using* a skill is what keeps you
in sync. (Re-running `install.sh` is only needed if a brand-new skill gets
added to the repo later — existing ones update themselves.)

The only person who ever needs a GitHub login is whoever *writes* an ICP
update (`/icp-onboarding` ends with a `git push`, which needs write access).
Everyone just reading/using skills needs nothing.

### Alternative: copy instead of symlink

If you're using this solo, don't care about staying in sync, or symlinks are
awkward on your setup, plain copies work too — you'll just need to re-run
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

## Why this counts as a "single source of truth"

1. **The ICP lives in this repo**, not in someone's home directory —
   `icp-onboarding` writes `profiles/<business-slug>/client-profile.yaml`
   relative to this repo's own root, which is what makes it committable and
   shareable in the first place.
2. **Writing an ICP update means committing and pushing it** —
   `icp-onboarding`'s last step is `git add`/`commit`/`push` on the profile
   file. A local-only edit doesn't help the team, only a pushed one does.
3. **Every skill pulls the latest repo before it does anything else** —
   `sales/SKILL.md` (so every `/sales <command>`), `icp-prompt-builder`, and
   `lead-research-assistant` all run a silent `git pull` as their first
   step. If the pull fails (offline, etc.) it's silently skipped and the
   skill continues with whatever's on disk — never blocks, never errors.
4. **Skills are symlinked, not copied** — a fix to any `SKILL.md` is picked
   up the moment it's pulled, no reinstall step.
5. **The repo is public**, so reading needs no login — only writing an ICP
   update needs GitHub write access.

Net effect: `install.sh`, run once, is the only setup step for the whole
system — using the tools afterward *is* the sync mechanism. If the team
wants a review gate on ICP changes (so no one person can silently redefine
who everyone is calling), the natural next step is GitHub branch protection
requiring a pull request for changes under `profiles/` — that needs no
change to how the skills themselves work.

## Attribution

- `icp-onboarding`, `icp-prompt-builder`: from
  [growthenginenowoslawski/coldoutboundskills](https://github.com/growthenginenowoslawski/coldoutboundskills)
  (see that repo for its license).
- `lead-research-assistant`: from
  [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
  (see that repo for its license).
- `sales/`, `sales-prospect`, `sales-contacts`, `sales-competitors`,
  `sales-objections`, `sales-research`, `sales-qualify`: from
  [zubair-trabzada/ai-sales-team-claude](https://github.com/zubair-trabzada/ai-sales-team-claude)
  (see that repo for its license). `sales-prospect` and `sales/SKILL.md` were
  both modified locally (email subagent removed, scoring reweighted) — see
  above.
