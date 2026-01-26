---
name: blueprint:require
description: Add a requirement (functional or non-functional)
argument-hint: "[requirement description]"
allowed-tools:
  - Glob
  - Grep
  - Read
  - Write
  - Edit
  - EnterPlanMode
  - ExitPlanMode
---

# Add Requirement

**COMMAND:** Add a requirement to specs. Auto-detect type from description.

## Execute

1. **Parse** argument for requirement description
2. **Detect** type: FR (feature) or NFR (performance/security/etc)
3. **Create** spec file (scaffold dirs if needed)
4. **Report** what was created

## Type Detection

| Input contains | Type | File |
|----------------|------|------|
| "users can", "should be able to" | FR | docs/specs/features/[name].md |
| "P95", "latency", "under Xms" | NFR | docs/specs/non-functional/performance.md |
| "uptime", "availability" | NFR | docs/specs/non-functional/reliability.md |
| "encryption", "auth" | NFR | docs/specs/non-functional/security.md |

## Templates

**Source of truth:** `_templates/TEMPLATES.md`

### Feature Spec Template (inline for non-interactive execution)

```markdown
---
status: Active
module: src/[module]/
related_adrs: []
---

# [Feature Name]

## Overview
[1-2 sentence description]

## User Stories
- As a [user type], I want [capability] so that [benefit]

## Requirements
- [Requirement 1]

## Acceptance Criteria
<!-- TODO: Add when ready for test automation -->
```

### NFR Template (inline for non-interactive execution)

```markdown
---
category: Performance | Security | Scalability | Reliability
---

# [Category] Requirements

| Metric | Target | Measured At |
|--------|--------|-------------|
| [metric] | [target] | [location] |

## [Specific Requirement]
**Requirement:** [Measurable statement]
**Rationale:** [Why this matters]
```

## Output

```
Added requirement to docs/specs/[path]
```

If details missing, use TBD markers.
