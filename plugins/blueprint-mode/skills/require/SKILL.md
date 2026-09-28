---
name: require
description: Add a functional or non-functional requirement to docs/specs. Use when the user states what the product must do or a measurable target such as latency, uptime, or a security constraint.
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Add Requirement

Formats are in `../_templates/TEMPLATES.md` (relative to this skill's directory): `feature-specs`, `nfr`, `adr-reading`.

## Steps

1. Read the argument and the conversation for the requirement, the user type, and any rationale.
2. Classify:
   - Capability ("users can", "should be able to", a workflow): feature spec at `docs/specs/features/[slug].md`. Add to an existing spec if one covers the feature.
   - Measurable target (latency, throughput, uptime, encryption, auth, scale): the matching file in `docs/specs/non-functional/` (`performance.md`, `reliability.md`, `security.md`, `scalability.md`). Create it if missing.
   - A decision with rationale rather than a requirement: record it as `decide` skill would and say so.
3. Select relevant ADRs per `adr-reading`. When a requirement may conflict with or extend a decision’s scope, read its full motivation and options before classifying it. Record compatible requirements normally. Identify actual conflicts by ADR and affected rule; record unresolved requirements and their conflicts under `**Open questions:**` in the feature spec’s Implementation State, or the NFR file’s optional `## Open Questions` section. Keep them out of accepted requirements and target metrics until resolved. Do not silently change an Active ADR.
4. Write or update the file. New feature specs start at `maturity: Exploring`. Unknown sections get `TBD`. A spec that predates `maturity` and Implementation State gets them added.
5. Link related ADRs in `related_adrs` when the feature clearly depends on a documented decision.

## Output

```
Added requirement to docs/specs/features/slug.md
```
