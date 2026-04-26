# Blueprint Mode - Agent Reference

This project uses Blueprint Mode for spec-driven development. Blueprint captures decision rationale (WHY), not detailed specs (WHAT). Read this before making changes.

## Directory Structure

Blueprint splits artifacts into two strictly separate trees so different reviewers (engineering vs design) can own different paths.

**Code / architecture tree:**
```
docs/specs/product.md          - Project vision, users, success metrics
docs/specs/tech-stack.md       - Technology choices with rationale
docs/specs/boundaries.md       - Agent guardrails: Always / Ask First / Never Do
docs/specs/features/*.md       - Feature specifications (status, module, related_adrs)
docs/specs/non-functional/*.md - Performance, security, scalability requirements
docs/adrs/NNN-[slug].md        - Architecture Decision Records (WHY behind tech choices)
patterns/good/*.[ext]          - Approved code examples
patterns/bad/anti-patterns.md  - Code anti-patterns (with severity)
```

**Design / UX tree (OPT-IN — only present if `/blueprint:onboard-design` was run):**
```
design/sources.md                  - External design sources (Figma, Storybook, docs URLs)
design/ux-decisions/NNN-[slug].md  - UX decisions (UX-NNN) — WHY behind UX choices
```

**The design tree is opt-in.** Many repos (backend services, libraries, CLIs) will not have it. Always check whether `design/ux-decisions/` exists before assuming UX decisions can be filed there. If it doesn't exist and the user wants to record a UX decision, point them to `/blueprint:onboard-design`.

```
CLAUDE.md                      - AI agent instructions and pre-edit checklist
```

## Pre-Edit Checklist (MANDATORY)

Before writing or editing ANY code:

1. **Feature specs** - Read `docs/specs/features/[feature].md` if implementing a documented feature
2. **Related ADRs** - Check `related_adrs` field in feature specs — these MUST be followed
3. **Boundaries** - Read `docs/specs/boundaries.md` — "Never Do" = hard blocker, "Ask First" = confirm with user
4. **Code patterns** - Check `patterns/good/` for approved examples and `patterns/bad/anti-patterns.md` for what to avoid
5. **For UI work, also check the design tree IF IT EXISTS** - The design tree is opt-in. If `design/ux-decisions/` exists, check it for UX choices that constrain the work. If it doesn't exist, skip this check (do NOT scaffold the tree from a regular task)
6. **Traceability** - Add `// ADR-NNN: brief note` for architectural decisions, `// UX-NNN: brief note` for UX decisions

## Key File Formats

**Feature specs** have frontmatter: `status` (Planned/Active/Deprecated), `module` (source path), `related_adrs` (ADR numbers to follow).

**ADRs** have frontmatter: `status` (Draft/Active/Superseded/Deprecated), `date`. Sections: Context, Options Considered, Decision, Consequences, Related. Title: `# ADR-NNN: ...`

**UX decisions** have the **same shape** as ADRs but live in `design/ux-decisions/` with title `# UX-NNN: ...` and independent numbering. They are NEVER filed under `docs/adrs/`.

**Boundaries** have three levels: Always Do (mandatory), Ask First (need user confirmation), Never Do (hard blockers — refuse and suggest alternatives).

**Good patterns** are real code/UI files with a header comment block linking to the ADRs (and UX decisions, where relevant) that motivate them.

**Anti-patterns** have severity (Critical/High/Medium/Low), a bad example, a good alternative, and an explanation.

## Tree Separation (CRITICAL)

- `docs/**` and `patterns/**` = engineering tree (engineering reviewers)
- `design/**` = design tree (design reviewers, opt-in)
- These are NEVER interchangeable. UX decisions are NOT ADRs (separate tree, separate numbering, `UX-NNN` not `ADR-NNN`).

## Boundary Violations

If a task would violate a "Never Do" boundary:
1. DO NOT proceed
2. INFORM the user which boundary would be violated
3. SUGGEST alternative approaches that comply

## Blueprint Commands

| Command | Purpose |
|---------|---------|
| `/blueprint:status` | Overview of Blueprint structure (both trees) |
| `/blueprint:validate` | Check code against documented specs and design |
| `/blueprint:decide [topic]` | Record decisions — triages tech (ADR) vs UX (UX decision) |
| `/blueprint:require [desc]` | Add feature or non-functional requirement (NOT for components) |
| `/blueprint:good-pattern [file]` | Capture approved patterns (any subject — code, schema, UI) |
| `/blueprint:bad-pattern [desc]` | Document anti-patterns (any subject — code, schema, UI) |
| `/blueprint:supersede [ADR\|UX]` | Replace or deprecate a previous decision |
| `/blueprint:list-adrs` | List all ADRs with status (architectural only) |
| `/blueprint:onboard-design` | Opt in to the design tree (run once to set it up) |
