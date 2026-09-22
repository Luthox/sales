---
name: lead-generator-assistant
description: Identifies high-quality leads for your product or service by analyzing your business, searching for target companies, and providing actionable contact strategies. Perfect for sales, business development, and marketing professionals.
---

# Lead Generator Assistant

This skill helps you identify and qualify potential leads for your business by analyzing your product/service, understanding your ideal customer profile, and providing actionable outreach strategies.

## Output language: Dutch

The chat-facing "Lead Research Results" presentation (step 6 below — fit
reasoning, contact strategy, everything) is written in **Dutch**. Keep
company names, URLs, and person names as-is.

The **saved batch YAML** (step 7) is the one exception — it stays
machine-readable as documented there: `name`/`url` field values are just
the company name and URL (nothing to translate), and the `description`
field can be written in Dutch like everything else, but the YAML keys
themselves (`business`, `segment`, `leads`, `name`, `url`, etc.) always
stay in English, unchanged — other skills read those exact key names.

## When to Use This Skill

- Finding potential customers or clients for your product/service
- Building a list of companies to reach out to for partnerships
- Identifying target accounts for sales outreach
- Researching companies that match your ideal customer profile
- Preparing for business development activities

## What This Skill Does

1. **Understands Your Business**: Analyzes your product/service, value proposition, and target market
2. **Identifies Target Companies**: Finds companies that match your ideal customer profile based on:
   - Industry and sector
   - Company size and location
   - Technology stack and tools they use
   - Growth stage and funding
   - Pain points your product solves
3. **Prioritizes Leads**: Ranks companies based on fit score and relevance
4. **Provides Contact Strategies**: Suggests how to approach each lead with personalized messaging
5. **Enriches Data**: Gathers relevant information about decision-makers and company context

## Reuse the team's ICP if one exists

Before asking the user to redescribe their business, check whether
`profiles/<business-slug>/client-profile.yaml` already exists in this repo
(from `/icp-onboarding`). If it might, pull the latest copy first, silently:

```bash
git -C "$(dirname "$(readlink -f ~/.claude/skills/lead-generator-assistant/SKILL.md")")/.." pull
```

(Resolves back to wherever the shared repo was actually cloned. If the pull
fails — no internet, no remote — say nothing and just continue with what's
on disk.) Reading `client-profile.yaml` right after the pull, as its own
fresh Read call, already picks up whatever that pull just brought in — but
this file's own instructions don't refresh the same way, since you're still
executing the copy of `lead-generator-assistant/SKILL.md` you were handed
before the pull ran. If someone changed how this skill itself works, re-read
`lead-generator-assistant/SKILL.md` at the resolved path right after the pull,
and if it differs from what you're reading now, follow that freshly-read
version instead for the rest of this command.

Then use that file's `business`, `offer`, and
`icp_hard_filters`/`icp_soft_preferences` as the ICP instead of asking the
user to repeat it. If no such file exists, fall back to asking the user
directly, as below.

## Optional: use a segment instead of the base ICP alone

If the user names a segment ("use the `<segment-slug>` segment", "find
leads for our wholesale push"), or `profiles/<business-slug>/segments/`
exists and what they're asking for sounds like it matches one of the
filenames there, check for `profiles/<business-slug>/segments/<segment-slug>.yaml`
(same pull-first step as above already covers this — the segment file comes
along with the same `git pull`). If found, read `references/segment-schema.md`
in `icp-segment-builder` (in this same repo, at
`skills/icp-segment-builder/references/segment-schema.md`) for the merge
rules, then merge the segment onto the base profile per those rules and use
the **merged** result as the ICP for this run instead of the base alone.

If the user didn't name a segment, just use the base profile — segments are
opt-in, never required. If they ask what segments exist, list the filenames
under `profiles/<business-slug>/segments/` (strip `.yaml`).

## How to Use

### Basic Usage

Simply describe your product/service and what you're looking for:

```
I'm building [product description]. Find me 10 companies in [location/industry] 
that would be good leads for this.
```

### With Your Codebase

For even better results, run this from your product's source code directory:

```
Look at what I'm building in this repository and identify the top 10 companies 
in [location/industry] that would benefit from this product.
```

### Advanced Usage

For more targeted research:

```
My product: [description]
Ideal customer profile:
- Industry: [industry]
- Company size: [size range]
- Location: [location]
- Current pain points: [pain points]
- Technologies they use: [tech stack]

Find me 20 qualified leads with contact strategies for each.
```

## Instructions

When a user requests lead research:

1. **Understand the Product/Service**
   - If in a code directory, analyze the codebase to understand the product
   - Ask clarifying questions about the value proposition
   - Identify key features and benefits
   - Understand what problems it solves

2. **Define Ideal Customer Profile**
   - Determine target industries and sectors
   - Identify company size ranges
   - Consider geographic preferences
   - Understand relevant pain points
   - Note any technology requirements

3. **Research and Identify Leads**
   - Search for companies matching the criteria
   - Look for signals of need (job postings, tech stack, recent news)
   - Consider growth indicators (funding, expansion, hiring)
   - Identify companies with complementary products/services
   - Check for budget indicators
   - Check the company's visible tech stack (CMS, customer portals, webshop,
     dashboards, automation tooling — whatever's visible from the site) and
     what it implies about their current level of digitization. This is
     gathered here, up front, for every lead — not deferred to a later
     per-company check.
   - Check the company's vacancies/careers page for open roles that signal
     relevant pain (planning, operations, supply chain, QHSE/quality,
     logistics coordination, "coördinator"/"planner"/"manager" roles —
     anything suggesting a growing need for process/structure). Explicitly
     exclude purely operational/execution roles (driver, warehouse,
     mechanic, mover) — those aren't a signal for this ICP. Same as tech
     stack: do this here, up front, for every lead, not as an afterthought.
     If a lead has zero relevant vacancies, say so plainly ("no relevant
     openings found") rather than omitting the check.

### Scaling to large batches (20+ leads)

For a small ask (up to ~20 leads), do step 3 as written above: discover and
fully enrich each company in one pass. For anything larger, replace step 3
with the pipeline below instead — doing full enrichment (site fetch +
LinkedIn + decision-maker search + vacancy check) inline for every
candidate across several parallel search angles causes two real problems at
scale: the same company gets independently found *and* independently
verified by more than one angle (wasted tool calls, and worse, two agents
can guess two different names for the same decision-maker with nothing to
reconcile them), and agents left open-ended tend to keep searching one
company well past the point of diminishing returns instead of accepting
"not found."

**The number the user asked for is always the end-of-funnel count** — the
number of real, deduplicated, ICP-qualified companies that end up in the
saved batch, never the number of raw candidates found along the way. Don't
silently deliver fewer than asked; either hit the number or say plainly
that the segment ran dry at some smaller count.

1. **Discovery (cheap, redundancy-tolerant).** Split the search into a
   handful of angles (by sub-niche, region, or trigger signal — whatever
   partitions the ICP sensibly). Each discovery pass does only 1-2 search
   calls per candidate and outputs just `name + url + one-line reason` — no
   site fetch, no LinkedIn, no decision-maker or vacancy lookup yet.
   Overlap between angles is fine and expected here; a duplicate at this
   stage costs almost nothing. Size the total discovery target with a
   buffer over the requested count N: `discovery_target ≈ N / (1 -
   expected_attrition)`, using ~35% as a default attrition estimate (dedup
   + disqualifiers + unverifiable candidates), higher for a narrow segment.
   Most attrition only shows up *during enrichment* (a company turns out to
   be 400 fte, a one-person shop, or not actually in the segment) — a real
   facility-management run lost 20 of 76 candidates, most of them only
   after their site was fetched. Budget for that up front rather than
   discovering the shortfall afterwards.
2. **Central dedupe and filter — done once, not per-agent.** Merge every
   discovery angle's output yourself, dedupe by name/domain, and drop
   anything that clearly fails the ICP hard filters. This is the only place
   "which companies get researched" is decided, which is what guarantees no
   company is ever verified twice.
3. **Check the count against N.**
   - If unique-qualified ≥ N: keep the top ~1.2×N (by whatever fit signal
     is available from the discovery snippets) and send all of them into
     the *same* enrichment wave — the extra ~20% are the reserves that
     cover enrichment-stage disqualifications. Enriching them in the first
     wave is far cheaper than a separate reserve or top-up round later,
     because every extra round pays the per-agent fixed cost again (see
     "Token budget" below). Keep the best N after enrichment; drop the rest.
   - If unique-qualified < N: run one more discovery round using *new*
     angles not yet tried, sized to the shortfall, then re-check. Repeat.
   - If after 2-3 top-up rounds the segment still can't produce N real
     companies, stop and tell the user plainly (e.g. "found 41 solid
     matches, couldn't responsibly find 9 more without loosening the ICP —
     widen it, or take the 41?") instead of padding the list with weak fits.
4. **Enrichment (expensive, but exactly-once and budgeted).** Split the
   final list into batches of ~15-20 and enrich each batch in parallel — each
   enrichment pass gets an *assigned, fixed list* of companies (it cannot
   discover more) and does the full per-lead work from step 3 above (tech
   stack, vacancies, decision maker, LinkedIn) capped at roughly 2-3 tool
   calls per company. If a fact isn't found inside that budget, record it as
   "not found on site" rather than continuing to dig — that's the same
   fallback the schema already expects, so the cap doesn't reduce what
   actually ships, only how long an agent searches before accepting a gap.
5. **Do the dispatching and merging yourself** rather than delegating it to
   a middleman agent whose only job is to launch other agents — that layer
   adds real token cost (a full agent invocation) and produces no research.

#### Token budget: agent count is the main cost driver

Every agent you launch pays a **fixed ~60-70k-token startup cost** (system
prompt + tool definitions) before it does any research — even an agent
that only makes 6 tool calls ends up at ~65-75k. So the number of agents
matters far more than the number of tool calls per company. A real
facility-management run (45 leads) used ~37 agents and ~2.5-3M tokens,
versus ~930k for an earlier 9-agent run of 70 leads — the per-company
tool-call cap worked, but the agent count exploded. The rules below exist
to prevent that:

- **Sub-agents must never spawn their own sub-agents.** Put this sentence
  literally into every discovery and enrichment prompt you dispatch: *"Do
  the research yourself directly — do NOT spawn sub-agents or use the
  Agent/Task tool."* Without it, enrichment agents tend to split their
  list into 3-4 child agents, which roughly doubles the total cost (in the
  run above, ~20 of the 37 agents were unrequested children) and also
  breaks result collection, because the children report to the parent,
  not to you.
- **Prefer fewer, larger batches.** Because the fixed cost is per agent,
  2-3 discovery agents and 3 enrichment agents of ~15-20 companies each
  beat 5+5 small ones. The per-company cap (2-3 tool calls) is what keeps
  a large batch from bloating, not a small batch size.
- **Write the shared instructions once to a brief file** in the scratchpad
  (ICP, disqualifiers, per-company budget, output schema) and have each
  agent read it, instead of repeating the full brief in every prompt.
- **Agents write their YAML to a file in the scratchpad and reply with
  only** `path, count, DISQUALIFIED: <name> — <reason>` lines. Never have
  them paste full YAML into their reply — that inflates your own context,
  which is re-read on every turn for the rest of the session.
- **Don't nudge running agents to "assemble now" or "resend"** — each
  nudge costs a full extra turn per agent. If an agent's result is already
  in your context, just write the file yourself.
- **No extra rounds by default.** The ~1.2×N reserves from step 3 should
  cover attrition. Only run a top-up round if the shortfall is real, and
  ask the user first ("found 44 — top up to 50, or take 44?"): a top-up
  round costs as much as a whole extra agent wave.
- **Report progress to the user only at milestones** (discovery done,
  enrichment done, ready to review), not after every agent notification.

Rough sizing by N (agent counts are totals — stay inside them):

| N | Discovery agents | Enrichment agents | Total agents | Rough tokens |
|---|---|---|---|---|
| ≤20 | 0 — single inline pass (step 3 as written) | inline | 0 | ~100-300k |
| 20-40 | 2 | 2 (batches of ~15-25) | 4 | ~350-500k |
| 40-70 | 3 | 3-4 (batches of ~15-20) | 6-7 | ~600-900k |
| 70+ | 4-5, buffer-sized per the formula above | 5-6 (batches of ~15-20), strict per-company cap | ≤11 | ~1-1.3M |

4. **Prioritize and Score**
   - Create a fit score (1-10) for each lead
   - Consider factors like:
     - Alignment with ICP
     - Signals of immediate need
     - Budget availability
     - Competitive landscape
     - Timing indicators

5. **Provide Actionable Output**
   
   For each lead, provide:
   - **Company Name** and website
   - **Why They're a Good Fit**: Specific reasons based on their business
   - **Priority Score**: 1-10 with explanation
   - **Tech Stack**: What's visible on their site/systems (CMS, portals,
     webshop, dashboards, automation) and what it implies about their
     current digitization level
   - **Relevant Vacancies**: Open roles signaling relevant pain (planning,
     operations, supply chain, QHSE/quality, coordination) — never driver/
     warehouse/execution roles — or "none found"
   - **Decision Maker**: Role/title to target (e.g., "VP of Engineering")
   - **Contact Strategy**: Personalized approach suggestions
   - **Value Proposition**: How your product solves their specific problem
   - **Conversation Starters**: Specific points to mention in outreach
   - **LinkedIn URL**: If available, for easy connection

6. **Format the Output**

   Present results in a clear, scannable format:

   ```markdown
   # Lead Research Results
   
   ## Summary
   - Total leads found: [X]
   - High priority (8-10): [X]
   - Medium priority (5-7): [X]
   - Average fit score: [X]
   
   ---
   
   ## Lead 1: [Company Name]
   
   **Website**: [URL]
   **Priority Score**: [X/10]
   **Industry**: [Industry]
   **Size**: [Employee count/revenue range]
   **Tech Stack**: [What's visible from the site — CMS, portals, dashboards, automation — and what it implies, or "not disclosed on site"]
   **Relevant Vacancies**: [Open planning/operations/supply-chain/QHSE/coordination roles found on their careers page, or "none found" — never list driver/warehouse/execution roles here]
   
   **Why They're a Good Fit**:
   [2-3 specific reasons based on their business]
   
   **Target Decision Maker**: [Role/Title]
   **LinkedIn**: [URL if available]
   
   **Value Proposition for Them**:
   [Specific benefit for this company]
   
   **Outreach Strategy**:
   [Personalized approach - mention specific pain points, recent company news, or relevant context]
   
   **Conversation Starters**:
   - [Specific point 1]
   - [Specific point 2]
   
   ---
   
   [Repeat for each lead]
   ```

7. **Save the batch and sync to the team**

   Save the **full** per-lead detail from step 6 — not just name and URL —
   as a batch file the rest of the team can pull and work from, so anyone
   who opens the file sees the same fit reasoning, tech stack read, and
   contact strategy that generated it, without having to be in this chat
   or re-run the research themselves.

   **a. Propose a filename.** Derive a short label from this run's search
   framing (e.g. "fintech companies hiring platform engineers" →
   `fintech-platform-eng`). Propose:

   ```
   profiles/<business-slug>/leads/<YYYY-MM-DD>-<short-label>.yaml
   ```

   using today's date and the business slug from the ICP in use (see "Reuse
   the team's ICP if one exists" above). Ask the user to confirm the label
   or give their own. If that exact filename already exists, don't
   overwrite it — append `-2`, `-3`, etc. and tell the user you did.

   **If no `client-profile.yaml` exists** (the user described their ICP ad
   hoc, with no business set up in this repo), there's no business slug to
   save under automatically. Ask the user directly what to call the
   business for the folder name, or skip saving entirely if they say this
   was a one-off — never invent a slug silently.

   **b. Build the YAML**, carrying over every field from step 6's chat
   output per lead (nothing dropped):

   ```yaml
   business: <business-slug>
   segment: <segment-slug or null>        # optional, plain string, no nesting
   generated_at: <YYYY-MM-DD>
   description: >-
     <one or two sentences: what was searched for, which framing/angle was
     used this run>
   leads:
     - name: <Company Name>
       url: <https://...>
       priority_score: <X/10>
       industry: <Industry>
       size: <Employee count/revenue range>
       tech_stack: <What's visible and what it implies, or "not disclosed">
       relevant_vacancies: <Open planning/operations/supply-chain/QHSE/coordination roles found, or "none found" — never driver/warehouse/execution roles>
       why_fit: <Specific reasons based on their business>
       decision_maker: <Role/title to target>
       linkedin: <URL, or null if not found>
       value_proposition: <How the product solves their specific problem>
       outreach_strategy: <Personalized approach>
       conversation_starters:
         - <Specific point 1>
         - <Specific point 2>
     - name: <Company Name>
       url: <https://...>
       priority_score: <X/10>
       industry: <Industry>
       size: <Employee count/revenue range>
       tech_stack: <What's visible and what it implies, or "not disclosed">
       relevant_vacancies: <Open planning/operations/supply-chain/QHSE/coordination roles found, or "none found" — never driver/warehouse/execution roles>
       why_fit: <Specific reasons based on their business>
       decision_maker: <Role/title to target>
       linkedin: <URL, or null if not found>
       value_proposition: <How the product solves their specific problem>
       outreach_strategy: <Personalized approach>
       conversation_starters:
         - <Specific point 1>
         - <Specific point 2>
   ```

   The YAML keys themselves (`priority_score`, `tech_stack`,
   `relevant_vacancies`, `why_fit`, etc.) always stay in English, unchanged,
   same as `name`/`url` already did — other skills and teammates' tooling
   read those exact key names. Field *values* follow the normal Dutch
   output-language rule.

   **c. Show the user the exact YAML and filename, and ask "look right?"**
   before touching disk or git — same confirm gate `icp-onboarding` uses
   before saving `client-profile.yaml`.

   **d. After confirmation**, save the file, then:

   ```bash
   git add profiles/<business-slug>/leads/<filename>.yaml
   git commit -m "Add lead batch: <business-slug> <short-label>"
   git push
   ```

   If the push is rejected (someone else pushed in the meantime), `git pull
   --rebase` first, then push again. Tell the user the batch file is now
   live for every teammate who has this repo cloned — the next `git pull`
   (which every skill in this repo already does automatically) picks it up,
   no manual resync needed.

   **If zero leads were found this run**, skip this step entirely — don't
   write an empty or pointless batch file. Tell the user no leads matched
   and suggest broadening the search criteria instead.

8. **Offer Next Steps**
   - Remind the user the batch file is saved and pushed — teammates get it
     with `git pull`
   - Suggest working each lead with `/sales quick <url>` (fast gut check) or
     `/sales prospect <url>` (full analysis) when someone's ready to act on it
   - Suggest running this skill again with a different sector/region framing
     to keep building out the shortlist — each run becomes its own batch file
   - Offer to draft personalized outreach messages for top leads

## Common gotchas

- **No automated dedupe, on purpose.** This skill does not compare new
  candidates against previous batch files. Doing that would mean re-reading
  an ever-growing history on every run — cost scales with total leads ever
  found across all time — and fuzzy company-name/domain matching is
  error-prone. The `description` field in each batch file plus the
  company-name list is the entire dedupe strategy: a human skimming past
  batches catches obvious repeats in a few minutes. The failure mode of
  occasionally re-researching a company already in the CRM is mild and gets
  caught anyway when someone goes to actually enter it into the CRM. Do not
  "helpfully" add comparison-against-history logic here — it was discussed
  and deliberately rejected.
- **The batch file carries the full research, on purpose.** Every field
  from step 6's chat output (priority score, tech stack, relevant
  vacancies, decision maker, value proposition, outreach strategy,
  conversation starters) is persisted per lead, not just `name`/`url` — so
  any teammate who pulls the
  repo sees the same reasoning without re-running research or needing this
  conversation. This is a point-in-time snapshot, not a live source of
  truth: `generated_at` marks when it was produced, and `/sales quick`
  or `/sales prospect` can still be run on a lead later to refresh a stale
  read (e.g. the company's site or team has visibly changed since).
- **This is not a CRM.** Don't add status tracking, "contacted" flags, or
  notes fields to the batch schema — the team already has a real CRM used
  manually at call time; this file's only job is handing off a raw list.
- **Vacancy check is deliberately narrow.** Only flag planning/operations/
  supply-chain/QHSE/coordination roles as `relevant_vacancies` — driver,
  warehouse, mechanic, and mover roles are noise for this ICP, not signal,
  even though they're usually the majority of what's actually posted (a
  real test run found 20 driver/warehouse postings vs. 1 relevant QHSE
  coordinator role at a single company — don't let the volume of irrelevant
  postings bury the one that matters). Costs one extra fetch per lead,
  same order of magnitude as the tech-stack check.

## Examples

### Example 1: From Lenny's Newsletter

**User**: "I'm building a tool that masks sensitive data in AI coding assistant queries. Find potential leads."

**Output**: Creates a prioritized list of companies that:
- Use AI coding assistants (Copilot, Cursor, etc.)
- Handle sensitive data (fintech, healthcare, legal)
- Have evidence in their GitHub repos of using coding agents
- May have accidentally exposed sensitive data in code
- Includes LinkedIn URLs of relevant decision-makers

### Example 2: Local Business

**User**: "I run a consulting practice for remote team productivity. Find me 10 companies in the Bay Area that recently went remote."

**Output**: Identifies companies that:
- Recently posted remote job listings
- Announced remote-first policies
- Are hiring distributed teams
- Show signs of remote work challenges
- Provides personalized outreach strategies for each

## Tips for Best Results

- **Be specific** about your product and its unique value
- **Run from your codebase** if applicable for automatic context
- **Provide context** about your ideal customer profile
- **Specify constraints** like industry, location, or company size
- **Request follow-up** research on promising leads for deeper insights

## Related Use Cases

- Drafting personalized outreach emails after identifying leads
- Building a CRM-ready CSV of qualified prospects
- Researching specific companies in detail
- Analyzing competitor customer bases
- Identifying partnership opportunities
