---
name: lead-generator-assistant
description: Identifies high-quality leads for your product or service by analyzing your business, searching for target companies, and providing actionable contact strategies. Perfect for sales, business development, and marketing professionals.
---

# Lead Generator Assistant

This skill helps you identify and qualify potential leads for your business by analyzing your product/service, understanding your ideal customer profile, and providing actionable outreach strategies.

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

   The chat output from step 6 is for the user right now. Separately, save a
   **stripped-down** version — company name and URL only, nothing else from
   this run's scoring or reasoning — as a batch file the rest of the team
   can pull and work from.

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

   **b. Build the YAML**, using only `name` and `url` per lead — drop every
   other field from step 6's chat output:

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
     - name: <Company Name>
       url: <https://...>
   ```

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
- **The batch file is intentionally stripped down.** Only `name` and `url`
  per lead — no fit score, decision-maker guess, or contact strategy get
  persisted, because `/sales quick` and `/sales prospect` regenerate that
  analysis fresh per company when someone actually works the lead. Stale
  scoring in a static file would just go out of date. Don't add those
  fields back into the saved YAML even though they're in the chat output.
- **This is not a CRM.** Don't add status tracking, "contacted" flags, or
  notes fields to the batch schema — the team already has a real CRM used
  manually at call time; this file's only job is handing off a raw list.

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
