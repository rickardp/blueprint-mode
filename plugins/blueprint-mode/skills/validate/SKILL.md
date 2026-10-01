---
name: validate
description: Check the codebase and its documentation against recorded decisions, boundaries, patterns, specs, and design intent. Use when the user asks for a consistency audit or whether the code still follows the documented decisions.
allowed-tools: Read, Glob, Grep, Bash
---

# Validate Blueprint Compliance

Report only; never fix without being asked. ADR selection and reading depth follow section `adr-reading`. Canonical formats and retirement rules are in `../_templates/TEMPLATES.md` (relative to this skill's directory), sections `adr-template`, `ux-decision-template`, and `decision-lifecycle`.

## Scope

Use the argument if given. `changes` means uncommitted files plus the last commit. Otherwise, on a feature branch validate files changed against `main` or `master`; on the default branch validate the whole repo excluding build output and dependencies.

## Steps

1. Inventory Blueprint files: `docs/specs/**/*.md`, `docs/adrs/*.md`, `patterns/**`, `DESIGN.md`, `design/ux-decisions/*.md`. If none exist, say so and suggest asking to set up Blueprint.
2. For scoped checks, select relevant ADRs per `adr-reading` using the affected files and requirements, including cross-cutting decisions. Extract current choices and constraints from their status and Decision sections; read full ADRs for ambiguous applicability, potential conflicts or scope extensions, and legacy sections lacking operational context. Read added or modified decision files fully against their canonical template; follow affected supersession chains and incoming references even outside the diff. For whole-repo or ADR-wide checks, read every in-scope ADR fully, including rationale, to check operational completeness. Read other applicable boundaries, patterns, specs, and design rules for the chosen scope.
3. Run the checks below for every domain that applies.
4. Report findings ranked by severity, then offer the follow-ups.

## Checks

**Source code.** Compare dependency manifests against technologies chosen in Active ADRs. Grep for "Never Do" violations and deviations from Active decisions. Treat matches to rejected alternatives as candidates; read the full ADR before classifying a conflict, since a rejected option may apply outside its original scope. In-scope changes that touch an "Ask First" item (Medium). Grep for documented anti-patterns. Note repeated conventions (three or more occurrences) that no good pattern captures.

**Features.** Each spec's `module` path exists; Active features have code and tests; maturity matches reality; Implementation State is present and not stale; `related_adrs` still Active. Specs missing User Stories or Requirements, or carrying TBD markers (Low). `docs/specs/non-functional/` missing performance, security, scalability, or reliability (Low; Medium when CI or infrastructure config exists). Source directories with no spec are flagged as unspecified.

**Documentation.** Markdown outside the Blueprint trees, including `CLAUDE.md` and `AGENTS.md`, does not recommend rejected alternatives or deprecated features. Stale agent instructions are High severity because agents follow them directly. Agent instructions that demand reading every Blueprint file before every edit, including a Blueprint 1.x `Pre-Edit Checklist`, are High with the fix "ask to upgrade Blueprint documentation".

**Scoped boundary routing.** Compare paths under `Scoped Rules` in `boundaries.md` with the compact routing line in the agent instructions identified by `agent-file-detection`. Ignore empty or placeholder sections. Missing, extra, or renamed paths are stale agent instructions (High); recommend refreshing the line per `agent-instructions`. With no scoped rules, the line should be absent. It should direct matching edits to only the relevant sections, without copying scoped rule contents.

**Vocabulary.** A legacy `## Always Do` heading in boundaries is read as `## Safe Without Asking`; obligation-style bullets under it ("read X before Y", "run Z before commit") are Low, with the destination the `boundaries` template gives for that kind of bullet. Do not recommend deleting a project requirement; it moves to scoped rules, the agent instructions, or an NFR. Non-canonical synonyms are Low: in decisions `Benefits`, `Trade-offs`, `Pros`, `Cons`, `References`, `status: Accepted`, and an `# ADR-` title under `design/ux-decisions/`; in feature specs `## Description`, `## Stories`, `status: Done|Complete|Todo`; in boundaries `# Boundaries`, `Do Always`, `Ask Before`, `Don't Do`, `Prohibited`; in anti-patterns `Wrong Way`, `Right Way`, `Better`, `**Level:**`.

**Decision files.** For each ADR inspected in full, check that Decision is first and self-contained: applicability, constraints, and exceptions (Low when missing; unknown scope stays explicit). Flag operative constraints found only in rationale as incomplete Decision content; preserve their meaning when recommending a move. Selective reads do not establish completeness; report that check as skipped for those files. Filename number matches the title number (High). Slug still describes the title (Low). Links and `superseded_by` values resolve (Medium).

**Decision structure and retirement.** Compare fully read ADRs and UX decisions against the complete canonical template, including rationale sections and, for changed choices, the previously used option and reason for changing it under Options Considered (Low when missing; Draft TODOs are allowed). Apply `decision-lifecycle`: authorized changed choices rewrite the existing record; flag unnecessary successor records without an explicit separate-replacement request (Low). Historical links and reciprocal pointers are not retention reasons. Flag obsolete files without a concrete migration or archival blocker (Low), stale current guidance and broken live links at their applicable severity, and reused retired numbers (Medium). Numbering gaps and historical identifiers or git permalinks are valid. If reference or archival checks are incomplete, report those checks as skipped rather than passing supersession from metadata alone.

**Content placement.** Product requirements inside ADRs (architectural constraints belong in Decision), architectural rationale inside feature specs, UX rationale under `docs/adrs/` unless its Context says it was filed there deliberately, tech rationale under `design/`, broad rules filed as UX decisions, or per-flow rationale inside `DESIGN.md` (Medium, with the correct destination).

**Design.** Only when `DESIGN.md` or `design/` exists. UI source against explicit `DESIGN.md` prohibitions (High) and against rejected alternatives in Active UX decisions. Count `UX-TBD` flags (Low, informational).

**CI/CD and infrastructure.** Only when such files exist. Pipelines use the declared commands; infrastructure provisions what the decisions chose; no secrets committed (Critical).

## Severity

Critical: secrets, "Never Do" violations. High: mismatches with technologies chosen in Active ADRs, decision violations, stale agent instructions, design prohibition violations. Medium: misplaced content, broken decision links, undeclared dependencies, unapproved Ask First changes. Low: vocabulary drift, stale slugs, UX-TBD counts, missing spec sections.

## Output

```markdown
## Blueprint Validation Report

| Severity | Location | Finding | Source |
|----------|----------|---------|--------|

Summary: Critical N, High N, Medium N, Low N. Domains scanned: [...]. Skipped: [...].
```

## Follow-ups

Offer, do not perform: record undocumented tech choices, document requirements for unspecified modules, save repeated conventions as examples, or update stale Blueprint agent instructions. Describe these actions in ordinary language.
