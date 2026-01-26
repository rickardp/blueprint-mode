---
name: blueprint:bad-pattern
description: Document an anti-pattern to avoid
argument-hint: "[description] - [correct approach]"
allowed-tools:
  - Glob
  - Grep
  - Read
  - Write
  - Edit
  - EnterPlanMode
  - ExitPlanMode
---

# Document Anti-Pattern

**COMMAND:** Document code to avoid and the correct alternative.

## Execute

1. **Parse** argument for anti-pattern and correct approach
2. **Create** patterns/bad/ if needed
3. **Add** entry to patterns/bad/anti-patterns.md
4. **Report** what was documented

## Input Handling

| Input | Action |
|-------|--------|
| `/bad-pattern any type - use unknown` | Document with both bad and good |
| `/bad-pattern inline SQL` | Ask for correct approach |
| `/bad-pattern` | Ask what to document |

## Anti-Pattern Template

Add to `patterns/bad/anti-patterns.md`:

```markdown
## [Category]: [Description]

**Severity:** Critical | High | Medium | Low

### Don't Do This
```[language]
[bad code]
```

**Problems:**
- [Issue]

### Do This Instead
```[language]
[good code]
```

**Why:** [Explanation]
```

## Severity Guide

- **Critical**: Security, data loss
- **High**: Performance, maintenance burden
- **Medium**: Code smell
- **Low**: Style preference

## Output

```
Anti-pattern documented in patterns/bad/anti-patterns.md
```

If details missing, use TBD markers.
