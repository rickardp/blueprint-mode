# Combined Agent - All Document Types

You are creating a complete Blueprint structure. You must follow the EXACT formats for each document type. This reference covers ALL document types you may create.

---

## DOCUMENT TYPES QUICK REFERENCE

| Document | Location | Format Reference |
|----------|----------|------------------|
| ADR | `docs/adrs/NNN-slug.md` | See ADR Format below |
| Feature Spec | `docs/specs/features/name.md` | See Feature Spec Format below |
| NFR | `docs/specs/non-functional/category.md` | See NFR Format below |
| Boundaries | `docs/specs/boundaries.md` | See Boundaries Format below |
| Tech Stack | `docs/specs/tech-stack.md` | See Tech Stack Format below |
| Product | `docs/specs/product.md` | See Product Format below |
| Good Pattern | `patterns/good/name.ext` | See Good Pattern Format below |
| Anti-Pattern | `patterns/bad/anti-patterns.md` | See Anti-Pattern Format below |

---

## ADR FORMAT

```markdown
---
status: [Draft|Active|Superseded|Deprecated]
date: YYYY-MM-DD
---

# ADR-NNN: [Descriptive Title]

## Context
[Problem statement]

## Options Considered

### Option 1: [Name]
- Pro: [advantage]
- Con: [disadvantage]

### Option 2: [Name]
- Pro: [advantage]
- Con: [disadvantage]

## Decision
We chose **[CHOICE]** because [rationale].

## Consequences

**Positive:**
- [benefit]

**Negative:**
- [tradeoff]

## Related
- [links]
```

**FORBIDDEN in ADRs:**
- `## Status` in body (use frontmatter)
- `**Benefits:**` (use `**Positive:**`)
- `**Trade-offs:**` (use `**Negative:**`)
- `## References` (use `## Related`)

**Cleanup:** Delete Superseded/Deprecated ADRs when no code references them. Git history is the archive.

---

## FEATURE SPEC FORMAT

```markdown
---
status: [Planned|Active|Deprecated]
module: src/[path]/
related_adrs: []
---

# [Feature Name]

## Overview
[1-2 sentence description]

## User Stories
- As a [user], I want [capability] so that [benefit]

## Requirements
- [Requirement]

## Acceptance Criteria (optional)
- Given [context], when [action], then [outcome]
```

---

## NFR FORMAT

```markdown
---
category: [Performance|Security|Scalability|Reliability]
---

# [Category] Requirements

| Metric | Target | Measured At |
|--------|--------|-------------|
| [metric] | [target] | [location] |

## [Requirement Name]

**Requirement:** [Measurable statement]
**Rationale:** [Why this matters]
```

---

## BOUNDARIES FORMAT

```markdown
# Agent Boundaries

## Always Do
- [Rule]

## Ask First

### [Category]
- [Item]

## Never Do

### [Category]
- [Prohibition]

## Scoped Rules (Optional)

### src/[module]/
**Always Do:**
- [Rule]

**Never Do:**
- [Prohibition]
```

---

## TECH STACK FORMAT

```markdown
# Technology Stack

## Runtime

| Component | Technology |
|-----------|------------|
| Runtime | [Choice] |
| Framework | [Choice] |
| Database | [Choice] |
| Auth | [Choice] |

## Commands

```bash
[package manager] install    # Install dependencies
[package manager] dev        # Development mode
[package manager] test       # Run tests
[package manager] lint       # Lint code
```
```

---

## PRODUCT FORMAT

```markdown
---
last_updated: YYYY-MM-DD
---

# [PROJECT_NAME]

## Vision
[1-2 sentence description]

## Users

### [User Type]
- [What they need]

## Success Metrics
- [Metric]

## Features
See `docs/specs/features/` for detailed specifications.

## Quality Standards
- Run `[command]` before committing
```

---

## GOOD PATTERN FORMAT

```
/**
 * [Pattern Name] Example
 *
 * USE THIS PATTERN WHEN:
 * - [Situation]
 *
 * KEY ELEMENTS:
 * 1. [Aspect]
 *
 * Related ADRs:
 * - [ADR-NNN](../../docs/adrs/NNN-name.md) - [Why]
 *
 * Source: [original path]
 */

// --- Example Implementation ---

// ADR-NNN: [Brief note]
[code]
```

---

## ANTI-PATTERN FORMAT

```markdown
## [Category]: [Description]

**Severity:** [Critical|High|Medium|Low]

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

---

## MASTER VALIDATION CHECKLIST

### For ALL Documents:
- [ ] Correct file location and naming
- [ ] Required frontmatter present (if applicable)
- [ ] All required sections present
- [ ] Correct section headings (exact wording)

### ADR Specific:
- [ ] Status in YAML, NOT in body
- [ ] `**Positive:**` not Benefits
- [ ] `**Negative:**` not Trade-offs
- [ ] `## Related` not References
- [ ] Title: `# ADR-NNN: [Descriptive Title]`

### Spec Specific:
- [ ] `status:` in frontmatter
- [ ] `module:` points to valid path
- [ ] `## Overview` not Description

### Boundaries Specific:
- [ ] Title: `# Agent Boundaries`
- [ ] Three main sections: Always Do, Ask First, Never Do
- [ ] Subsections use `### Category` format

### Pattern Specific:
- [ ] Good patterns have header comment block
- [ ] Anti-patterns all in single file
- [ ] `### Don't Do This` not "Wrong Way"
- [ ] `### Do This Instead` not "Right Way"

---

## DIRECTORY STRUCTURE TO CREATE

```
docs/
├── specs/
│   ├── product.md
│   ├── tech-stack.md
│   ├── boundaries.md
│   ├── features/
│   │   └── [feature].md
│   └── non-functional/
│       └── [category].md
└── adrs/
    └── NNN-[slug].md

patterns/
├── good/
│   └── [name].[ext]
└── bad/
    └── anti-patterns.md

CLAUDE.md (or AGENTS.md)
```

**Create all directories that don't exist. Create files with TBD markers if information is incomplete.**
