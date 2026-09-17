---
name: validate
description: Check the codebase and its documentation against recorded decisions, boundaries, patterns, specs, and design intent. Use when the user asks for a consistency audit or whether the code still follows the documented decisions.
argument-hint: "[scope: all|changes|specs|patterns|adrs|features|docs|<directory>]"
allowed-tools: Read, Glob, Grep, Bash
---

# Validate Blueprint Compliance

Report only; never fix without being asked. Canonical formats are in `../_templates/TEMPLATES.md` (relative to this skill's directory).

## Scope

Use the argument if given. `changes` means uncommitted files plus the last commit. Otherwise, on a feature branch validate files changed against `main` or `master`; on the default branch validate the whole repo excluding build output and dependencies.

## Steps

1. Inventory Blueprint files: `docs/specs/**/*.md`, `docs/adrs/*.md`, `patterns/**`, `DESIGN.md`, `design/ux-decisions/*.md`. If none exist, say so and point at `/blueprint-mode:onboard`.
2. Read them and extract the rules to check: tech stack, boundaries, each decision's chosen and rejected options, anti-patterns, feature specs with module paths, `DESIGN.md` rules, UX decisions.
3. Run the checks below for every domain that applies.
4. Report findings ranked by severity, then offer the follow-ups.

## Checks

**Source code.** Dependency manifests versus declared tech stack. Grep for "Never Do" violations and for rejected alternatives named in Active decisions. In-scope changes that touch an "Ask First" item (Medium). Grep for documented anti-patterns. Note repeated conventions (three or more occurrences) that no good pattern captures.

**Features.** Each spec's `module` path exists; Active features have code and tests; maturity matches reality; Implementation State is present and not stale; `related_adrs` still Active. Specs missing User Stories or Requirements, or carrying TBD markers (Low). `docs/specs/non-functional/` missing performance, security, scalability, or reliability (Low; Medium when CI or infrastructure config exists). Source directories with no spec are flagged as unspecified.

**Documentation.** Markdown outside the Blueprint trees, including `CLAUDE.md` and `AGENTS.md`, does not recommend rejected alternatives or deprecated features. Stale agent instructions are High severity because agents follow them directly. Agent instructions that demand reading every Blueprint file before every edit, including a Blueprint 1.x `Pre-Edit Checklist`, are High with the fix "rerun `/blueprint-mode:onboard`".

**Scoped boundary routing.** Compare paths under `Scoped Rules` in `boundaries.md` with the compact routing line in the agent instructions identified by `agent-file-detection`. Ignore empty or placeholder sections. Missing, extra, or renamed paths are stale agent instructions (High); recommend refreshing the line per `agent-instructions`. With no scoped rules, the line should be absent. It should direct matching edits to only the relevant sections, without copying scoped rule contents.

**Vocabulary.** A legacy `## Always Do` heading in boundaries is read as `## Safe Without Asking`; obligation-style bullets under it ("read X before Y", "run Z before commit") are Low, with the destination the `boundaries` template gives for that kind of bullet. Do not recommend deleting a project requirement; it moves to scoped rules, the agent instructions, or an NFR. Non-canonical synonyms are Low: in decisions `Benefits`, `Trade-offs`, `Pros`, `Cons`, `References`, `status: Accepted`, and an `# ADR-` title under `design/ux-decisions/`; in feature specs `## Description`, `## Stories`, `status: Done|Complete|Todo`; in boundaries `# Boundaries`, `Do Always`, `Ask Before`, `Don't Do`, `Prohibited`; in anti-patterns `Wrong Way`, `Right Way`, `Better`, `**Level:**`.

**Decision files.** Filename number matches the title number (High). Slug still describes the title (Low). Links and `superseded_by` values resolve (Medium).

**Content placement.** Requirements inside ADRs, architectural rationale inside feature specs, UX rationale under `docs/adrs/` unless its Context says it was filed there deliberately, tech rationale under `design/`, broad rules filed as UX decisions, or per-flow rationale inside `DESIGN.md` (Medium, with the correct destination).

**Design.** Only when `DESIGN.md` or `design/` exists. UI source against explicit `DESIGN.md` prohibitions (High) and against rejected alternatives in Active UX decisions. Count `UX-TBD` flags (Low, informational).

**CI/CD and infrastructure.** Only when such files exist. Pipelines use the declared commands; infrastructure provisions what the decisions chose; no secrets committed (Critical).

## Severity

Critical: secrets, "Never Do" violations. High: tech stack mismatches, decision violations, stale agent instructions, design prohibition violations. Medium: misplaced content, broken decision links, undeclared dependencies, unapproved Ask First changes. Low: vocabulary drift, stale slugs, UX-TBD counts, missing spec sections.

## Output

```markdown
## Blueprint Validation Report

| Severity | Location | Finding | Source |
|----------|----------|---------|--------|

Summary: Critical N, High N, Medium N, Low N. Domains scanned: [...]. Skipped: [...].
```

## Follow-ups

Offer, do not perform: `/blueprint-mode:decide` for undocumented tech choices, `/blueprint-mode:require` for unspecified modules, `/blueprint-mode:good-pattern` for repeated conventions, and `/blueprint-mode:onboard` for stale agent instructions.
