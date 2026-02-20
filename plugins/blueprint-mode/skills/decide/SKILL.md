---
name: blueprint:decide
description: Record a technology decision as an ADR (triages mixed input into ADRs, feature specs, and NFRs)
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

**COMMAND:** Create an ADR for a technology decision. Triage mixed input into the correct document types.

## Execute

1. **Parse** argument for technology and rationale
2. **Classify** each concern in the input (see Classification below)
3. **If mixed or misclassified:** Separate concerns into their document types
4. **Check** docs/adrs/ for existing ADRs (create dir if needed)
5. **Detect** conflicts with existing decisions
6. **Create** file(s) per concern type
7. **Report** what was created and where

## Classification

Before creating files, classify each distinct concern in the input:

| Signal | Type | Destination |
|--------|------|-------------|
| Tech choice, "[X] over [Y]", design pattern, infrastructure approach | Architectural | ADR (`docs/adrs/`) |
| "users can", feature behavior, workflow, user story, UI requirement | Functional | Feature spec (`docs/specs/features/`) |
| Latency, throughput, uptime, encryption, SLA, scalability target | Non-functional | NFR (`docs/specs/non-functional/`) |

**If input mixes types:**
1. Extract the architectural decision → create ADR
2. Extract functional requirements → create/update feature spec(s) with `related_adrs` linking back
3. Extract NFR targets → create/update NFR file(s)
4. Report all files created

**If input is purely functional or non-functional** (no architectural decision):
- Inform: "This is a [functional/non-functional] requirement, not an architectural decision."
- Create the appropriate spec file instead (use templates from `_templates/TEMPLATES.md`)
- Suggest: "Use `/blueprint:require` for future requirements."

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

**Single type (most common):**
```
Created ADR-NNN at docs/adrs/NNN-technology.md
```

**Mixed input (triaged):**
```
Triaged input into 3 concerns:
- ADR-NNN: [architectural decision] → docs/adrs/NNN-slug.md
- Feature: [feature name] → docs/specs/features/slug.md (linked to ADR-NNN)
- NFR: [metric] → docs/specs/non-functional/performance.md
```

**Redirected (no architectural decision):**
```
This is a functional requirement, not an architectural decision.
Created feature spec at docs/specs/features/slug.md
Tip: Use /blueprint:require for future requirements.
```

If rationale missing, mark as Draft with TBD.
