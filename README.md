# lead-finder

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
| `sales/SKILL.md` | *(orchestrator — no direct command)* | Routes every `/sales <command>` to the right skill below, and directly implements `/sales quick <url>` inline (a 60-second scorecard, terminal output only, no subagents). **Required for any `/sales ...` command to work at all.** |
| `skills/sales-prospect` | `/sales prospect <url>` | The flagship command. Launches the 4 skills below as parallel subagents, aggregates them into one scored `PROSPECT-ANALYSIS.md`. |
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

**Top-level `agents/`, `templates/`, and `scripts/` folders from the source
repo were not brought in.** None of the skills above have a hard dependency on
them:
- The `agents/*.md` persona files (`sales-company.md`, `sales-strategy.md`,
  etc.) are never referenced by `sales-prospect`'s actual instructions — it
  explicitly launches subagents as `subagent_type: "general-purpose"`, driven
  by the `SKILL.md` files already here, not by those persona files.
- `templates/*.md` (outreach templates, proposal template, meeting-prep
  template) all belong to skills that were left out or removed.
- `scripts/analyze_prospect.py` is referenced once, by `sales-prospect`, but
  is explicitly optional in its own instructions — "if the script is not
  available or fails, continue the analysis" using plain `WebFetch` data
  instead. Nothing breaks without it.

## Installing as Claude Code skills

```bash
# Discovery layer
cp -r skills/icp-onboarding skills/icp-prompt-builder skills/lead-research-assistant ~/.claude/skills/

# Per-account deep-dive layer (sales/ is a top-level folder, not under skills/)
cp -r sales ~/.claude/skills/
cp -r skills/sales-prospect skills/sales-contacts skills/sales-competitors skills/sales-objections \
      skills/sales-research skills/sales-qualify ~/.claude/skills/skills/
```

Or copy into a project's `.claude/skills/` instead, to keep them project-scoped.

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
