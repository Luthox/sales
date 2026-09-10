# lead-finder

Claude Code skills for defining an ICP and finding relevant companies —
**with no paid third-party APIs or accounts**. Everything here runs on Claude's
own reasoning plus the built-in web-search/fetch tools (or, for
`icp-onboarding`, a plain `fetch()`-based scraper with zero external
dependencies).

This is a deliberately curated subset of two larger repos — not a full clone
of either. Most skills in both source repos require a paid data provider
(Prospeo, RapidAPI, Blitz, DiscoLike, OpenRouter, etc.); these three don't.

## What's in here

| Skill | From | What it does | Cost |
|---|---|---|---|
| `skills/icp-onboarding` | [growthenginenowoslawski/coldoutboundskills](https://github.com/growthenginenowoslawski/coldoutboundskills) | Conversational ICP intake. Scrapes your own website for context, interviews you on target industries/size/geography/disqualifiers, splits **hard filters** (must match) from **soft preferences** (nice-to-have), saves a structured `client-profile.yaml`. | Free |
| `skills/icp-prompt-builder` | same | Builds and tunes an AI qualification prompt against a sample of companies, iterating with your corrections until 2 rounds in a row need none. Runs entirely as Claude Task sub-agents — no external API key, ever. | Free |
| `skills/lead-research-assistant` | [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | The actual company *finder*. Given a product/ICP description, searches for and scores matching companies, with contact-strategy suggestions per lead. | Free |

## How they fit together

1. **`icp-onboarding`** — define who you're targeting, save it once
2. **`lead-research-assistant`** — run it (repeatedly, with different sector/region framings) to surface candidate companies
3. **`icp-prompt-builder`** — tune a qualification prompt against a sample of what came back, then apply it to filter/rank the full candidate pool

## Known limitations — read before relying on this

- **Scale is modest.** None of this queries a real company database (Prospeo,
  Clay, etc. all cost money). `lead-research-assistant` is built and capped
  around a 10-20 company shortlist per run. Building a genuinely large list
  means running it many times with different search angles and merging
  results yourself — there's no automated "snowball until it's exhausted"
  loop here (the paid-API repo's `list-expander` skill does that, but it
  requires Prospeo).
- **No contact enrichment.** These skills stop at company-level discovery
  and ICP fit. No phone numbers, no verified emails — by design. Add that as
  a separate step later, with tools you've explicitly chosen to pay for (or
  by asking Claude to check each qualified company's own `/contact` page as
  a free, best-effort, main-line-only lookup).
- **`lead-research-assistant`'s results aren't verified.** It relies on
  Claude's web search — company names, "recent news," and LinkedIn URLs it
  surfaces should be spot-checked before you act on them at any volume.

## Installing as Claude Code skills

Copy (or symlink) whichever of `skills/*` you want into your personal skills
directory:

```bash
cp -r skills/icp-onboarding skills/icp-prompt-builder skills/lead-research-assistant ~/.claude/skills/
```

Or keep them project-scoped by copying into a project's `.claude/skills/`
instead.

## Attribution

- `icp-onboarding` and `icp-prompt-builder`: from
  [growthenginenowoslawski/coldoutboundskills](https://github.com/growthenginenowoslawski/coldoutboundskills)
  (see that repo for its license).
- `lead-research-assistant`: from
  [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
  (see that repo for its license).
