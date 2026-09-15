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

## Installing — clone + symlink (recommended for a team)

Copying files (further down) works, but it forks them — after that, a `git
pull` in this repo updates nothing on your machine, since your copy is a
disconnected snapshot from whenever you ran `cp`. For a team sharing one ICP
and one set of skills, that's the wrong default: someone updates the ICP or
fixes a skill, pushes it, and everyone else is silently still working off a
stale copy with no signal that anything changed.

Clone once, then **symlink** each skill into your personal skills directory
instead of copying it. A symlink always resolves to the live file in your
clone's working tree — so the only thing you ever need to do to get
everyone's latest changes (skill fixes, and the shared ICP alike) is `git
pull` in the clone. Nothing to re-copy, ever.

```bash
# 1. Clone once, to the same path every teammate uses (so these instructions
#    stay copy-pasteable for everyone — adjust if your team prefers another path)
git clone https://github.com/YHavshush/sales.git ~/sales

# 2. Symlink the discovery layer
ln -s ~/sales/skills/icp-onboarding        ~/.claude/skills/icp-onboarding
ln -s ~/sales/skills/icp-prompt-builder    ~/.claude/skills/icp-prompt-builder
ln -s ~/sales/skills/lead-research-assistant ~/.claude/skills/lead-research-assistant

# 3. Symlink the deep-dive layer (sales/ is a top-level folder in this repo, not under skills/)
ln -s ~/sales/sales                        ~/.claude/skills/sales
mkdir -p ~/.claude/skills/skills
ln -s ~/sales/skills/sales-prospect        ~/.claude/skills/skills/sales-prospect
ln -s ~/sales/skills/sales-contacts        ~/.claude/skills/skills/sales-contacts
ln -s ~/sales/skills/sales-competitors     ~/.claude/skills/skills/sales-competitors
ln -s ~/sales/skills/sales-objections      ~/.claude/skills/skills/sales-objections
ln -s ~/sales/skills/sales-research        ~/.claude/skills/skills/sales-research
ln -s ~/sales/skills/sales-qualify         ~/.claude/skills/skills/sales-qualify
```

From then on, whenever anything in this repo changes — a skill gets fixed, or
someone updates the shared ICP — everyone just runs:

```bash
cd ~/sales && git pull
```

and every symlinked skill picks up the change immediately. No reinstalling.

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

**3. Reading an ICP means pulling first, automatically.**
`icp-prompt-builder` (and `lead-research-assistant`, if a profile exists)
now `git pull` this repo as their first step, before reading
`client-profile.yaml`. This is what makes updates reach the whole team
"automatically" from the user's point of view: nobody has to remember to
sync — invoking the skill does it for you, every time.

**4. Skills are symlinked, not copied** (see the install section above) — so
a fix to any `SKILL.md`, not just the ICP, reaches everyone on their next
`git pull`, with no reinstall step.

**Net effect:** `git pull` in the shared clone is the *only* sync operation
that matters for this whole system — one clone, one pull command, and both
"here's the current ICP" and "here's the current tooling" are up to date for
every teammate. If your team wants a gate on ICP changes (so one person
can't silently redefine who the whole team is calling), the natural next
step is to stop pushing to `main` directly and require a pull request for
changes under `profiles/` — GitHub's branch protection rules can enforce
that without changing anything about how the skills themselves work.

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
