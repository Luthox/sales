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
2. Run: git clone https://github.com/Luthox/sales.git ~/sales
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
| Narrow our ICP for one vertical or campaign push, without redoing the whole interview | *"Set up an ICP segment for [vertical/campaign]"* |
| Find companies that match that profile | *"Find me leads that fit our ICP"* |
| Get a fast, single-company gut check | `/sales quick <url>` |
| Get the full picture before I call someone | `/sales prospect <url>` |
| Just research a company's background | `/sales research <url>` |
| Figure out who to actually talk to there | `/sales contacts <url>` |
| See if this lead is worth chasing | `/sales qualify <url>` |
| Know what they're already using / competing with | `/sales competitors <url>` |
| Prep answers for pushback I expect on a call | `/sales objections <topic>` |

None of this costs anything beyond your normal Claude usage — no extra
accounts, no paid data services, no API keys to manage.

---

## 📞 Recommended flow: zero to calling

If you're starting from nothing, this is the order that gets you from "no
target list" to "ready to dial," using the skills above:

1. **Define your ICP, once per business.** *"Help me set up our ICP"*
   (`icp-onboarding`). You only redo this when your targeting actually
   changes — it's the one step everyone shares.
   - *(Optional)* **Narrow it for one vertical or campaign push** without
     redoing the interview: *"Set up an ICP segment for [vertical]"*
     (`icp-segment-builder`). Skip this until you actually need to target a
     specific slice differently from the base ICP — most runs just use the
     base.
2. **Build a shortlist.** *"Find me leads that fit our ICP"*
   (`lead-generator-assistant`) — or *"find leads for the `<segment>`
   segment"* if you set one up. Run it repeatedly with different sector or
   region framings to keep surfacing candidates. This already scores and
   filters every lead against your ICP itself, even at 50-70+ leads — no
   extra qualification step needed before the next step.
3. **Triage the shortlist.** `/sales quick <url>` on each candidate — a fast
   gut check to rank who's actually worth going deeper on before you invest
   more time. Since the saved batch file already carries lead-generator-
   assistant's full read on each company (score, tech stack, decision
   maker, etc.), this step matters most when you want a fresh look at a
   lead that may have changed since the batch was generated.
4. **Go deep on your top few**, using whichever of these actually answers
   the question you have — you don't need all of them for every prospect:
   - `/sales research <url>` — company background & firmographics
   - `/sales contacts <url>` — who to actually ask for
   - `/sales qualify <url>` — is this lead worth chasing (BANT/MEDDIC)
   - `/sales competitors <url>` — what they're already using
5. **Prep for pushback.** `/sales objections <topic/industry>` right before
   the call, so responses are ready instead of improvised live.
6. **Call.**

`/sales prospect <url>` (the full 4-in-1 report) isn't part of this flow —
it's a heavier deliverable for when you want a written report to hand off
or reference later, not something you need on the way to a cold call.

> **Got a list from somewhere other than `lead-generator-assistant`?** (a
> purchased list, a trade-show export, a KVK bulk export) — that's the one
> case this flow doesn't cover, since those companies were never scored
> against your ICP. See [Qualifying a list you got elsewhere](#qualifying-a-list-you-got-elsewhere)
> below.

---

## 📋 Qualifying a list you got elsewhere

Skip this section unless you have a list of companies that came from
**outside** `lead-generator-assistant` — a purchased list, a trade-show
export, a KVK bulk export, anything nobody here scored against your ICP
yet.

Say *"tune a qualification prompt for this list"* (`icp-list-qualifier`).
Think of it as training a junior assistant to screen a huge stack of
resumes: you write down what a good fit looks like, test it on 10
companies, correct anything it got wrong, retest on 10 more, and repeat
until it gets two batches in a row completely right — only then do you
trust it to grade the rest of a pile you could never review by hand
yourself.

You will **not** need this after `lead-generator-assistant` — that skill
already applies your ICP (or segment) itself while it searches, and scores
every lead before it's ever shown to you, even at 50-70+ leads. This tool
only earns its keep on a list that never went through that skill.

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

1. **Discovery** (`icp-onboarding`, `icp-list-qualifier`, `lead-generator-assistant`)
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
| `skills/icp-segment-builder` | this repo | *(Optional)* Layers a narrower or extended sub-ICP ("segment") on top of an existing `client-profile.yaml`, for one vertical or campaign push — without re-running the full interview. Writes `profiles/<slug>/segments/<segment-slug>.yaml` as a delta on the base; see [Segments](#segments-narrower-icps-without-re-onboarding) below. |
| `skills/icp-list-qualifier` | [growthenginenowoslawski/coldoutboundskills](https://github.com/growthenginenowoslawski/coldoutboundskills) | **Rarely needed** — only for a list of companies from *outside* this repo (a purchased list, a trade-show export, a KVK bulk export). Builds and tunes an AI qualification prompt against a sample of them, iterating with your corrections until 2 rounds in a row need none. Runs entirely as Claude Task sub-agents — no external API key, ever. `lead-generator-assistant` already does its own version of this qualification during discovery, so a list that came from there doesn't need this too. |
| `skills/lead-generator-assistant` | [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | The actual company *finder*, and the one you'll use almost every time. Given a product/ICP description, searches for and scores matching companies — including a tech stack read (CMS, portals, dashboards, automation visible on their site) as a standard part of research — with contact-strategy suggestions per lead. Accepts an optional segment name to search against instead of the base ICP. Applies the ICP's hard filters and its own fit scoring itself, before you ever see a candidate — including at 50-70+ leads via its discover-then-enrich pipeline (see "Scaling to large batches" in the skill). Saves each run as a batch file under `profiles/<slug>/leads/` with the full per-lead detail (score, industry, size, tech stack, decision maker, value prop, outreach strategy, conversation starters — not just name/URL) and pushes it for the team. |

**Flow:** `icp-onboarding` (define who you want, once) → optionally
`icp-segment-builder` (narrow/extend for a specific vertical or push) →
`lead-generator-assistant` (run repeatedly with different sector/region
framings, or a segment, to surface candidates — this is normally the last
step, since it already grades and scores everything itself). Reach for
`icp-list-qualifier` only if you're grading a list `lead-generator-assistant`
never touched.

### Segments: narrower ICPs without re-onboarding

A business has exactly one base ICP, but real campaigns often need a
narrower or extended slice of it — "same base, but only wholesale/logistics
companies" or "same base, but require a visible PE-backed roll-up signal
instead of treating it as just a nice-to-have." Re-running the full
`icp-onboarding` interview for that would mean re-answering questions that
haven't actually changed.

A **segment** (`icp-segment-builder`) is a small YAML file that records only
the *delta* from the base — the fields that differ for this slice — saved
to `profiles/<business-slug>/segments/<segment-slug>.yaml`. Anything not in
the segment file is inherited unchanged from the base. The exact merge
rules (when a segment field replaces the base vs. adds to it) live in
`skills/icp-segment-builder/references/segment-schema.md`.

Segments are entirely optional: nothing changes for anyone who doesn't use
one, and `lead-generator-assistant` / `icp-list-qualifier` both fall back to
the base ICP unless you explicitly name a segment.

**Limitations:** `lead-generator-assistant` handles a single run up to
~20 leads as one straightforward pass. Above that, it switches to a
discover-then-enrich pipeline (cheap, overlap-tolerant discovery across a
few search angles, deduped centrally, then a budgeted enrichment pass on
exactly the companies that will ship) so a 50-70 lead ask doesn't mean
running it many times and merging results by hand — see "Scaling to large
batches" in the skill itself for how that's sized. There's still no contact
enrichment beyond what's publicly findable, and results aren't verified
against authoritative sources (spot-check anything found via web search
before acting on it at volume).

### Layer 2 — Per-account deep dive

From [zubair-trabzada/ai-sales-team-claude](https://github.com/zubair-trabzada/ai-sales-team-claude)
— hand-picked, not the full repo. All of these take **one company URL** as
input; they don't discover companies, they analyze one you already picked.

| Skill | Command | What it does |
|---|---|---|
| `sales/SKILL.md` | *(orchestrator — no direct command)* | Routes every `/sales <command>` to the matching skill below. **Required for any `/sales ...` command to work at all** — nothing else in this layer runs without it. |
| `sales/SKILL.md` (quick mode) | `/sales quick <url>` | Implemented inline in the router itself, not a separate file — and no longer has its own scoring template. Loads the ICP, WebFetches the homepage, and runs `lead-generator-assistant`'s own research/output steps for that one URL, printing the same field set (including tech stack) straight to the terminal. No subagents, no file written. |
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
git clone https://github.com/Luthox/sales.git ~/sales && bash ~/sales/install.sh
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
cp -r skills/icp-onboarding skills/icp-list-qualifier skills/lead-generator-assistant ~/.claude/skills/

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
   `sales/SKILL.md` (so every `/sales <command>`), `icp-list-qualifier`,
   `icp-segment-builder`, and `lead-generator-assistant` all run a silent
   `git pull` as their first step. If the pull fails (offline, etc.) it's
   silently skipped and the skill continues with whatever's on disk — never
   blocks, never errors.
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

- `icp-onboarding`, `icp-list-qualifier`: from
  [growthenginenowoslawski/coldoutboundskills](https://github.com/growthenginenowoslawski/coldoutboundskills)
  (see that repo for its license).
- `icp-segment-builder`: written for this repo, not from an upstream source.
- `lead-generator-assistant`: from
  [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
  (see that repo for its license).
- `sales/`, `sales-prospect`, `sales-contacts`, `sales-competitors`,
  `sales-objections`, `sales-research`, `sales-qualify`: from
  [zubair-trabzada/ai-sales-team-claude](https://github.com/zubair-trabzada/ai-sales-team-claude)
  (see that repo for its license). `sales-prospect` and `sales/SKILL.md` were
  both modified locally (email subagent removed, scoring reweighted) — see
  above.
