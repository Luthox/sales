# Segment file schema + merge semantics

This is the canonical reference for how a **segment** relates to a **base
profile**. `icp-segment-builder` writes these files; `lead-generator-assistant`
and `icp-list-qualifier` read and merge them. All three skills point here
instead of repeating the rules inline — if you're changing the rules, this
is the one file to edit.

## Where segments live

```
profiles/<business-slug>/client-profile.yaml          # base ICP (unchanged format, from icp-onboarding)
profiles/<business-slug>/segments/<segment-slug>.yaml  # one file per segment
```

A segment is **not** a standalone profile — it's a delta, and only makes
sense read together with its base. It never duplicates fields that are
unchanged from the base; it only contains what's different for this segment.

## Segment slug naming

- kebab-case, 2-4 words, describing the narrowing/extension itself — not
  the business (that's already the parent folder).
- Good: `wholesale-logistics`, `pe-backed-rollups`, `multi-location-only`.
- Bad: `luthox-segment-1` (not descriptive), `Wholesale_Logistics` (wrong case).

## Segment file shape

```yaml
segment:
  slug: <matches the filename, without .yaml>
  name: <short human-readable label>
  description: >
    One or two sentences: what this narrows or adds on top of the base,
    and why it exists (which campaign/push it's for, if relevant).
  base_profile: profiles/<business-slug>/client-profile.yaml
  created_at: YYYY-MM-DD

# Only these two sections may appear below — business/offer/legal always
# come from the base profile; a segment never overrides them.
icp_hard_filters:
  ...
icp_soft_preferences:
  ...
```

Any field from the base's `icp_hard_filters` / `icp_soft_preferences` that
this segment doesn't mention is **inherited unchanged** from the base.

## Merge semantics

**Scalar fields** (`headcount_min`, `headcount_max`, `headcount_edge_tolerance`,
`geography_edge_tolerance`, `partial_competitor_overlap_note`, or any other
single value, not a list): if the segment sets it, that value **replaces**
the base value outright.

**List fields** (`job_titles`, `industries_in`, `industries_out`,
`countries`, `states`, `excluded_domains`, `qualitative_disqualifiers`,
`triggers`, `personas_to_prioritize`) support three forms — pick whichever
fits what you're actually doing:

1. **Plain list → additive (the default, and the common case).** The
   values are appended to the base list and de-duplicated. Use this when
   the segment only *adds* constraints and the base list should still apply.

   ```yaml
   icp_hard_filters:
     qualitative_disqualifiers:
       - No visible PE/buy-and-build ownership signal on their site or news
   ```

2. **`set:` → replace (use to narrow).** The base list for this field is
   ignored entirely; only these values apply. Use this when the segment
   narrows a broad/empty base field down to specifics — e.g. an
   industry-agnostic base narrowed to one vertical.

   ```yaml
   icp_hard_filters:
     industries_in:
       set:
         - Wholesale
         - Logistics
   ```

3. **`add:` / `remove:` → explicit merge.** Add these values to the base
   list, remove those values from it. If a value appears in both, `remove`
   wins. Use this when you need to both add and subtract from the same
   base list in one segment.

   ```yaml
   icp_hard_filters:
     countries:
       add: [BE]
       remove: [NL]
   ```

If a list field is entirely absent from the segment file, the base list
applies unchanged — same rule as scalars.

## Worked example

Base (`profiles/luthox/client-profile.yaml`, abbreviated): industry-agnostic
(`industries_in: []`), `headcount_min: 20` / `headcount_max: 200`, `countries:
[NL]`, soft trigger `pe_backed_mkb_rollup` among others.

A segment for "this quarter we're only pushing wholesale/logistics
companies that are part of a PE roll-up":

```yaml
segment:
  slug: wholesale-logistics-pe-rollups
  name: Wholesale/logistics PE roll-ups
  description: >
    Q4 campaign push — narrows the industry-agnostic base ICP to
    wholesale/logistics companies specifically, and requires visible
    PE-backed buy-and-build ownership instead of treating it as just a
    soft trigger.
  base_profile: profiles/luthox/client-profile.yaml
  created_at: 2026-09-17

icp_hard_filters:
  industries_in:
    set:
      - Wholesale
      - Logistics
  qualitative_disqualifiers:
    - No visible PE/buy-and-build ownership signal on their site, news, or
      KVK filings

icp_soft_preferences:
  triggers:
    - multi_warehouse_or_fulfillment_expansion
```

Merged result when this segment is applied: same job titles, headcount
range, and country as the base; `industries_in` becomes exactly `[Wholesale,
Logistics]` (replaced, not unioned); `qualitative_disqualifiers` gets the
base's 3 entries plus this new 4th one (appended); `triggers` gets the
base's 6 entries plus this new 7th one (appended).

## How to merge, step by step (for the skill reading this)

1. Read the base profile in full.
2. Read the segment file in full.
3. Start from a copy of the base's `icp_hard_filters` and
   `icp_soft_preferences`.
4. For each field present in the segment:
   - Scalar → overwrite.
   - List, plain form → append + de-duplicate.
   - List, `set:` form → overwrite entirely with the given values.
   - List, `add:`/`remove:` form → union with `add`, then drop anything in
     `remove`.
5. `business`, `offer`, `legal`, and `created_at` always come from the base
   — a segment never touches them, even if present (ignore them if a
   segment file somehow includes them).
6. The result is the merged ICP to use for the rest of that skill's run.
   Don't write this merged result back to disk anywhere — it's computed
   fresh each time from base + segment.
