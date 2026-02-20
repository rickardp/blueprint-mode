# Blueprint Mode - Agent Reference

This project uses Blueprint Mode for spec-driven development. Blueprint captures decision rationale (WHY), not detailed specs (WHAT). Read this before making changes.

## Directory Structure

```
docs/specs/product.md          - Project vision, users, success metrics
docs/specs/tech-stack.md       - Technology choices with rationale
docs/specs/boundaries.md       - Agent guardrails: Always / Ask First / Never Do
docs/specs/features/*.md       - Feature specifications (status, module, related_adrs)
docs/specs/non-functional/*.md - Performance, security, scalability requirements
docs/adrs/NNN-[slug].md        - Architecture Decision Records (the WHY behind choices)
patterns/good/*.[ext]          - Approved code examples to follow
patterns/bad/anti-patterns.md  - Patterns to avoid (with severity)
CLAUDE.md                      - AI agent instructions and pre-edit checklist
```

## Pre-Edit Checklist (MANDATORY)

Before writing or editing ANY code:

1. **Feature specs** - Read `docs/specs/features/[feature].md` if implementing a documented feature
2. **Related ADRs** - Check `related_adrs` field in feature specs — these MUST be followed
3. **Boundaries** - Read `docs/specs/boundaries.md` — "Never Do" = hard blocker, "Ask First" = confirm with user
4. **Good patterns** - Check `patterns/good/` for approved examples
5. **Anti-patterns** - Check `patterns/bad/anti-patterns.md` for what to avoid
6. **Traceability** - Add `// ADR-NNN: brief note` when implementing a documented decision

## Key File Formats

**Feature specs** have frontmatter: `status` (Planned/Active/Deprecated), `module` (source path), `related_adrs` (ADR numbers to follow).

**ADRs** have frontmatter: `status` (Draft/Active/Superseded/Deprecated), `date`. Sections: Context, Options Considered, Decision, Consequences, Related.

**Boundaries** have three levels: Always Do (mandatory), Ask First (need user confirmation), Never Do (hard blockers — refuse and suggest alternatives).

**Good patterns** are real code files with a header comment block explaining when to use them and which ADRs they relate to.

**Anti-patterns** have severity (Critical/High/Medium/Low), a bad example, a good alternative, and an explanation.

## Boundary Violations

If a task would violate a "Never Do" boundary:
1. DO NOT proceed
2. INFORM the user which boundary would be violated
3. SUGGEST alternative approaches that comply

## Blueprint Commands

| Command | Purpose |
|---------|---------|
| `/blueprint:status` | Overview of Blueprint structure |
| `/blueprint:validate` | Check code against documented specs |
| `/blueprint:decide [topic]` | Record architecture decisions as ADRs |
| `/blueprint:require [desc]` | Add feature or quality requirements |
| `/blueprint:good-pattern [file]` | Capture approved code patterns |
| `/blueprint:bad-pattern [desc]` | Document anti-patterns to avoid |
| `/blueprint:supersede [ADR]` | Replace or deprecate previous decisions |
| `/blueprint:list-adrs` | List all ADRs with status |
