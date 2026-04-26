---
name: blueprint:good-pattern
description: Capture good code as a reusable example (any subject — server code, schema, UI, scripts)
argument-hint: "[file-path or description]"
allowed-tools:
  - Glob
  - Grep
  - Read
  - Write
  - Edit
  - EnterPlanMode
  - ExitPlanMode
---

# Capture Good Pattern

**COMMAND:** Extract code as a pattern others should follow. Patterns are tree-agnostic — file everything under `patterns/good/` regardless of subject (server code, database model, UI, build scripts, etc.).

## Execute

1. **Parse** argument for file path or description
2. **Find** file (search if only description given)
3. **Read** file content
4. **Create** pattern at `patterns/good/[name].[ext]`
5. **Report** what was captured

## Input Handling

| Input | Action |
|-------|--------|
| `/good-pattern src/repos/user.ts` | Read file, capture as pattern |
| `/good-pattern error handling in api` | Search for files, ask which one |
| `/good-pattern` | Ask for file path |

## Pattern Template

Use template from `_templates/TEMPLATES.md` (`<!-- SECTION: good-patterns -->`).

The header comment lists the decisions that motivate the pattern — ADRs (`../../docs/adrs/...`) for tech/architecture rationale, UX decisions (`../../design/ux-decisions/...`) when the pattern reflects a UX choice. Either, both, or neither — only link what genuinely applies.

```[language]
/**
 * [Pattern Name]
 *
 * USE THIS PATTERN WHEN:
 * - [Situation where this applies]
 *
 * KEY ELEMENTS:
 * 1. [Important aspect]
 *
 * Related decisions:
 * - [ADR-NNN](../../docs/adrs/NNN-name.md) - [Why this pattern]
 * - [UX-NNN](../../design/ux-decisions/NNN-name.md) - [If applicable]
 *
 * Source: [original file path]
 */

// --- Example Implementation ---

// ADR-NNN: [Brief reference to the decision]
[extracted code]
```

## Output

```
Pattern captured at patterns/good/[name].[ext]
```

## Directory Structure

Create `patterns/good/` if it doesn't exist.
