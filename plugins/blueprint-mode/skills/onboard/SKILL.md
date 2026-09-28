---
name: onboard
description: Create the Blueprint code/architecture tree for an existing repository, or upgrade one set up by an earlier Blueprint version. Safe to rerun; later runs fill gaps.
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash
---

# Onboard Repository

Create the full structure in one pass; the invocation is the scope. Formats and working style are in `../_templates/TEMPLATES.md` (relative to this skill's directory): `working-style`, `agent-file-detection`, `adr-reading`, `adr-template`, `product-spec`, `boundaries`, `bad-patterns`, `agent-instructions`.

## Steps

1. Read the repo: dependency manifests, README, existing docs, CI config, and the agent instructions file. Note every significant technology and any stated reason for it.
2. Detect the agent instructions file per `agent-file-detection`.
3. Create everything now, with `TBD` where rationale is unknown:
   - `docs/adrs/NNN-[slug].md`, one per significant technology, Active when rationale is known and Draft with TODOs otherwise
   - `docs/specs/product.md`, `docs/specs/boundaries.md` from the template plus any rules the user stated
   - `patterns/bad/anti-patterns.md` with the template header, and `patterns/good/.gitkeep`
   - The agent instructions section from `agent-instructions`, with the Autonomy and limits lines filled from `boundaries.md` and the good-pattern names filled from `patterns/good/`. Omit the `DESIGN.md` and `design/` lines unless those exist. Replace 1.x-generated sections as `agent-file-detection` describes; preserve unrelated content.
4. Ask one batched question covering every technology whose rationale is missing (likely options plus skip) and, if the README does not say, who the users are. Upgrade the answered Draft ADRs to Active.
5. Report existing docs that duplicate rationale now living in ADRs, and long inline comments that explain a decision; do not edit source files.
6. When the structure already exists: create only what is missing, refine Draft ADRs whose rationale is now known, add `maturity` and Implementation State to feature specs that lack them, and migrate a 1.x `boundaries.md` as the `boundaries` template describes. Refresh the scoped-boundaries routing line per `agent-instructions` after updating boundaries, including in 2.x agent files.
7. Refresh ADR routing per `agent-instructions`, including on reruns. Read existing ADRs fully before moving their operational choice, applicability, constraints, and exceptions into the leading Decision section. Preserve status and meaning; retain motivation and options in their sections. Mark uncertain scope `TBD` and report it rather than guessing.
8. If `docs/specs/tech-stack.md` exists, read it and verify whether all its information is already covered accurately by the target repo’s ADRs, README, agent instructions, or other maintained docs. Check incoming references too. If fully redundant, suggest removing it and updating its references, citing where the content is covered. Otherwise, raise the unique, conflicting, or uncertain content to the user with its location and why removal is not yet justified. Leave the file and references intact unless the user authorizes removal.
9. Do not create `design/` or `DESIGN.md`. If the repo has UI code, mention `/blueprint-mode:onboard-design` in the report.

## Output

```
Created Blueprint structure:
- N ADRs (M with rationale, K Draft)
- docs/specs/product.md, boundaries.md
- patterns/
- CLAUDE.md (updated; replaced 1.x checklist)

Rerun /blueprint-mode:onboard to refine Draft ADRs. UI detected: run /blueprint-mode:onboard-design to capture design intent.
```
