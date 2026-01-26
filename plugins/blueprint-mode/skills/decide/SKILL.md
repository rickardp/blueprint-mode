---
name: blueprint:decide
description: Record a technology decision as an ADR
argument-hint: "[technology] [because reason]"
allowed-tools:
  - Glob
  - Grep
  - Read
  - Write
  - Edit
  - EnterPlanMode
  - ExitPlanMode
---

# Record Decision

**COMMAND:** Create an ADR for a technology decision.

## Execute

1. **Parse** argument for technology and rationale
2. **Check** docs/adrs/ for existing ADRs (create dir if needed)
3. **Detect** conflicts with existing decisions
4. **Create** ADR file
5. **Report** what was created

## Input Parsing

| Input | Action |
|-------|--------|
| `/decide PostgreSQL because team knows it` | Create ADR immediately |
| `/decide PostgreSQL` | Ask for rationale |
| `/decide` | Ask what to document |

## Conflict Detection

If new decision conflicts with existing ADR (e.g., DynamoDB vs existing PostgreSQL ADR):
- Ask: "ADR-003 documents PostgreSQL. Is this replacing it?"
- Options: Yes (supersede) / No (different purpose) / Cancel

## Template

**Source of truth:** `_templates/TEMPLATES.md` (`<!-- SECTION: adr-template -->`)

```markdown
---
status: Active
date: YYYY-MM-DD
---

# ADR-NNN: [Choice] as [CATEGORY]

## Context
[What problem are we solving?]

## Options Considered
### Option 1: [Alternative]
- Pro: [advantage]
- Con: [disadvantage]

## Decision
We chose **[CHOICE]** because [primary motivation].

## Consequences
**Positive:**
- [benefit]

**Negative:**
- [tradeoff]

## Related
- Tech stack: [docs/specs/tech-stack.md](../specs/tech-stack.md)
```

**Status values:** Draft (incomplete, has TODO markers), Active (complete)

### ADR Format Enforcement (CRITICAL)

**MANDATORY:** Use the exact format above. DO NOT deviate.

| DO NOT use | USE instead |
|------------|-------------|
| `## Status` with "Accepted" in body | YAML frontmatter `status: Active` |
| `**Benefits:**` | `**Positive:**` |
| `**Trade-offs:**` | `**Negative:**` |
| `## References` | `## Related` |

**Before writing:** Verify YAML frontmatter, title format, and all sections match template.

## Output

```
Created ADR-NNN at docs/adrs/NNN-technology.md
```

If rationale missing, mark as Draft with TBD.
