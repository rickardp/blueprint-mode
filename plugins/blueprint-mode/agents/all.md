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
| Design Context | `DESIGN.md` | Important adjacent repo file for cross-cutting UI rules; not part of the Blueprint structure |
| UX Decision | `design/ux-decisions/NNN-slug.md` | See UX Decision Format below |

**TREE SEPARATION (CRITICAL):** `docs/**` and `patterns/**` are the engineering tree. `design/**` is the design tree. They are NEVER interchangeable — different reviewers own each. UX decisions are NOT ADRs (separate file tree, separate numbering, separate audience).

**DESIGN TREE IS OPT-IN.** The `design/` tree only exists if `/blueprint:onboard-design` has been run. Always check whether `design/ux-decisions/` exists before producing files in it. If a user asks for a UX decision in a repo without the design tree, suggest `/blueprint:onboard-design` first — do NOT silently scaffold it from another skill.

**Stay quiet about design when it isn't relevant.** Only narrate design triage, design-tree absence, or `DESIGN.md` options when the input has UX/design signals OR the repo already has `design/` or `DESIGN.md`. For unambiguously architectural input in a repo with no design surface, just create the ADR — phrases like "no design tree → ADR" are noise.

**DELIBERATE VS COINCIDENTAL UI:** `DESIGN.md` and UX decisions record confirmed design intent. Current UI code by itself is not proof that a design choice was deliberate.

**DESIGN.md VS UX DECISIONS:** Cross-cutting rules and prohibitions go in repo-root `DESIGN.md`. Per-context choices with alternatives considered go in `design/ux-decisions/`. Do not duplicate a broad `DESIGN.md` rule into a UX decision; reference it instead.

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

## UX DECISION FORMAT

UX decisions live in `design/ux-decisions/NNN-slug.md`. Same structural shape as ADR but **never** filed in `docs/adrs/`. Title uses `UX-NNN`, not `ADR-NNN`. Create them when a user, designer, or source material confirms per-context design rationale with alternatives considered. Cross-cutting rules belong in `DESIGN.md` instead.

```markdown
---
status: [Draft|Active|Superseded|Deprecated]
date: YYYY-MM-DD
---

# UX-NNN: [Choice] for [Context]

## Context
[User problem / interaction tension]

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
- Related UX decisions: [UX-NNN]
```

**FORBIDDEN in UX decisions:**
- Filing in `docs/adrs/` (UX decisions live in `design/ux-decisions/`)
- Title `# ADR-NNN` (use `# UX-NNN`)
- `## Status` in body (use frontmatter)
- `**Benefits:**` (use `**Positive:**`)
- `**Trade-offs:**` (use `**Negative:**`)

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
### UX Decision Specific:
- [ ] Title `# UX-NNN: ...` (not `# ADR-NNN`)
- [ ] Filed in `design/ux-decisions/`, never `docs/adrs/`
- [ ] Status in YAML, NOT in body
- [ ] `**Positive:**` / `**Negative:**` (same as ADR)
- [ ] Not just a broad rule that belongs in `DESIGN.md`

---

## DIRECTORY STRUCTURE TO CREATE

```
docs/                          # CODE / ARCHITECTURE TREE
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

patterns/                      # Pattern examples and anti-patterns (any subject)
├── good/
│   └── [name].[ext]
└── bad/
    └── anti-patterns.md

design/                        # DESIGN / UX TREE — OPT-IN, created by /blueprint:onboard-design
└── ux-decisions/
    └── NNN-[slug].md

CLAUDE.md (or AGENTS.md)
```

**Create all directories that don't exist** — for the code/architecture tree. **Do NOT auto-create the `design/` tree or `DESIGN.md`** unless you are running `/blueprint:onboard-design` and the user accepts `DESIGN.md` scaffolding. `DESIGN.md` is important design context, but it is not part of the Blueprint structure. Other skills must check whether `design/` exists before producing files there. NEVER mix code and design trees — different reviewers own each.
