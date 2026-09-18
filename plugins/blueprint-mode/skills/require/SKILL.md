---
name: require
description: Add a functional or non-functional requirement to docs/specs. Use when the user states what the product must do or a measurable target such as latency, uptime, or a security constraint.
argument-hint: "[requirement description]"
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Add Requirement

Formats are in `../_templates/TEMPLATES.md` (relative to this skill's directory): `feature-specs`, `nfr`.

## Steps

1. Read the argument and the conversation for the requirement, the user type, and any rationale.
2. Classify:
   - Capability ("users can", "should be able to", a workflow): feature spec at `docs/specs/features/[slug].md`. Add to an existing spec if one covers the feature.
   - Measurable target (latency, throughput, uptime, encryption, auth, scale): the matching file in `docs/specs/non-functional/` (`performance.md`, `reliability.md`, `security.md`, `scalability.md`). Create it if missing.
   - A decision with rationale rather than a requirement: record it as `/blueprint-mode:decide` would and say so.
3. Write or update the file. New feature specs start at `maturity: Exploring`. Unknown sections get `TBD`. A spec that predates `maturity` and Implementation State gets them added.
4. Link related ADRs in `related_adrs` when the feature clearly depends on a documented decision.

## Output

```
Added requirement to docs/specs/features/slug.md
```
