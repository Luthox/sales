---
name: icp-segment-builder
description: Creates a narrower or extended sub-ICP ("segment") on top of an existing base client-profile.yaml, without re-running the full icp-onboarding interview. Use when the user wants to target a specific vertical, sector, or campaign push that's a variation on an ICP that already exists. Triggers on "set up a segment", "narrow our ICP for X", "new campaign for [vertical]", "segment our ICP", "ICP for just [industry/trigger]".
---

# ICP Segment Builder

A business has one base ICP (`client-profile.yaml`, from `icp-onboarding`).
This skill adds a **segment**: a named, narrower-or-extended variant of that
base for one campaign push, vertical, or target group — without redoing the
full onboarding interview. A segment only records what's *different* from
the base; everything else is inherited.

Requires a base profile to already exist. If it doesn't, send the user to
`icp-onboarding` first — there's nothing to layer a segment on top of.

## Step 0 — Sync before doing anything else

Before anything below:

1. Silently run:

   ```bash
   git -C "$(dirname "$(readlink -f ~/.claude/skills/icp-segment-builder/SKILL.md")")/.." pull
   ```

   (Resolves the symlink back to wherever the shared repo was actually
   cloned. If the pull fails — no internet, no remote — say nothing and
   continue with whatever's on disk.) This matters here because this skill
   both reads a base profile a teammate might have just updated, and ends
   in a `git push` of its own — pulling first avoids clobbering someone
   else's concurrent edit.

2. **Re-read this file** at the resolved path from step 1. If its content
   differs from what you're reading right now, treat that freshly-read copy
   as authoritative for the rest of this command instead of continuing with
   this one.

## Schema and merge rules

Read `references/segment-schema.md` before writing anything — it's the
canonical definition of the segment file format, the naming convention, and
exactly how a segment merges onto its base (scalar override vs. list
append/replace/add-remove). Don't improvise a different shape; the same
schema is what `lead-generator-assistant` and `icp-prompt-builder` expect
when they read a segment back.

## Steps

### 1. Identify the business and load its base profile

- If there's exactly one `profiles/<slug>/client-profile.yaml` in the repo,
  use it and confirm: "This'll be a segment on top of `<business name>`'s
  ICP — right?"
- If there are multiple, ask which business.
- If none exist yet, stop and tell the user to run `icp-onboarding` first —
  a segment needs a base to sit on top of.
- Read the base profile in full. You'll need it for step 3.

### 2. Name the segment

Ask: "What should this segment be called, and what's it narrowing or adding
for — a vertical, a trigger, a specific campaign push?"

Propose a kebab-case slug from the answer (2-4 words, describing the
narrowing/extension itself, not the business — see the naming convention in
`references/segment-schema.md`). Confirm the slug with the user before
moving on; it becomes the filename and how other skills reference it later.

### 3. Interview only the deltas

Show the user a short summary of the base profile's `icp_hard_filters` and
`icp_soft_preferences` (one line per field is enough — they already know
their own ICP, this is just a reminder of what's already covered). Then go
field by field, but only on the fields relevant to what they described in
step 2 — don't re-ask about fields that obviously aren't changing:

- **Industries** — narrowing to specific ones, or adding exclusions?
- **Headcount range** — different min/max for this segment?
- **Geography** — narrower or different countries/states?
- **Job titles** — different buyer for this segment?
- **Excluded domains** — any segment-specific competitors/customers to add?
- **Qualitative disqualifiers** — anything extra that disqualifies a company
  *for this segment specifically*, beyond the base's disqualifiers?
- **Triggers** — any segment-specific signal to prioritize?
- **Personas to prioritize** — different persona ranking for this segment?

For each answer, apply the same hard/soft judgment `icp-onboarding` uses
(pushing back on vague answers, treating triggers as soft not hard), and
also decide **narrow vs. add** for any list field that changed:

- If the user is picking specific values out of a broad/empty base field
  (e.g. base `industries_in: []`, segment wants "just wholesale and
  logistics") → that's a **narrow**, write it as `set:`.
- If the user is layering an extra constraint on top of an existing base
  list (e.g. one more qualitative disqualifier, one more trigger) → that's
  an **add**, write it as a plain list (or `add:`/`remove:` if both are
  needed).

If the user has nothing to say for a given field, leave it out of the
segment file entirely — it inherits from the base.

### 4. Write the segment file

Follow the exact shape in `references/segment-schema.md`. Save to:

```
profiles/<business-slug>/segments/<segment-slug>.yaml
```

### 5. Save + confirm

Print the segment yaml back to the user, and — since a segment is only
useful read together with its base — also print what the **merged** result
looks like (base + segment, applying the merge rules) so they can sanity
check the actual effect, not just the diff. Ask "look right?" before ending.

### 6. Sync this to the rest of the team

Same as `icp-onboarding` — a local-only segment doesn't help anyone else:

```bash
git add profiles/<business-slug>/segments/<segment-slug>.yaml
git commit -m "Add ICP segment <segment-slug> for <business-slug>"
git push
```

If the push is rejected (someone else pushed in the meantime), `git pull
--rebase` first, then push again.

### 7. Tell the user how to use it

> "Segment saved. Next time you run `lead-generator-assistant` or
> `icp-prompt-builder`, just say 'use the `<segment-slug>` segment' and
> it'll apply this on top of the base ICP instead of the base alone. Leave
> it unmentioned and you get the base ICP as before — this doesn't change
> anything for anyone not using this segment."

## Common gotchas

- **Don't duplicate the base.** If a field isn't changing for this segment,
  it shouldn't be in the segment file at all — that's what makes segments
  cheap to create and safe to layer (see `references/segment-schema.md`).
- **`qualitative_disqualifiers` should almost always be additive, not
  `set:`.** A segment narrowing a target group rarely wants to un-disqualify
  something the base profile already ruled out — accidentally replacing the
  base's disqualifier list is the most likely way a segment quietly does the
  wrong thing. Default to plain-list (additive) for this field unless the
  user is explicit that a base disqualifier shouldn't apply here.
- **A segment is not a new business.** `business`, `offer`, and `legal`
  always come from the base profile — never ask about those again here, and
  never write them into a segment file.
- **Multiple segments per business are fine** — nothing here caps how many
  a business can have. Each is independent; segments don't stack on each
  other, only on the base.

## What to do next

With a segment saved, use it from either downstream skill by naming it:
- `lead-generator-assistant` — "find leads for the `<segment-slug>` segment"
- `icp-prompt-builder` — "tune a qualification prompt for the `<segment-slug>` segment"

## Files

- `references/segment-schema.md` — canonical segment file format and merge
  semantics; read before writing any segment file.
