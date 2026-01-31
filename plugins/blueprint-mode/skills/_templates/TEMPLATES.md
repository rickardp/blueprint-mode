# Shared Blueprint Templates

These templates are used by multiple skills. When creating files, use the appropriate template and fill in the placeholders.

---

## Skill Design Principle: Simplicity Over Specification

**Short, imperative skills > long, conditional skills.**

More instructions doesn't mean better compliance. Keep skills under 100 lines with:

1. **COMMAND framing** - "Do X" not "Consider whether to X"
2. **Single execution path** - No conditions, no "if user prefers"
3. **Direct steps** - 1. Read 2. Create 3. Report
4. **TBD for gaps** - Missing info = TBD marker, not blocking questions

**Skill structure:**
```markdown
---
name: blueprint:skillname
description: One line
allowed-tools: [Glob, Grep, Read, Write, Edit]
---

# Skill Name

**COMMAND:** [What this does. No questions about scope.]

## Execute

1. [Direct step]
2. [Direct step]
3. [Direct step]

## Output

[Exact format]
```

**Questions are only allowed about CONTENT, never about SCOPE:**
- "Why was X chosen?" - content (allowed)
- "What would you like to create?" - scope (forbidden)

---

## Quick Reference (Section Markers)

**For selective reading, use these section markers:**

| Section | Line Marker | Use When |
|---------|-------------|----------|
| Specs: product.md | `<!-- SECTION: product-spec -->` | Creating product.md |
| Specs: features | `<!-- SECTION: feature-specs -->` | Creating feature specs |
| Specs: tech-stack | `<!-- SECTION: tech-stack -->` | Creating tech-stack.md |
| Specs: boundaries | `<!-- SECTION: boundaries -->` | Creating boundaries.md |
| Specs: NFR | `<!-- SECTION: nfr -->` | Creating NFR files |
| ADRs: discovery | `<!-- SECTION: adr-index -->` | Understanding ADR discovery |
| ADRs: template | `<!-- SECTION: adr-template -->` | Creating individual ADRs |
| Patterns: good | `<!-- SECTION: good-patterns -->` | Capturing good patterns |
| Patterns: bad | `<!-- SECTION: bad-patterns -->` | Documenting anti-patterns |
| CLAUDE.md | `<!-- SECTION: claude-md -->` | Creating agent instructions |
| Interview Standards | `<!-- SECTION: interview -->` | Following interview patterns |

**To read a specific section:** Search for the marker, then read ~50-100 lines.

---

## Plugin Scope

**Blueprint is for:** Making specs the source of truth for your project.

### In Scope
- Documenting architectural decisions (ADRs) with rationale
- Capturing good/bad code patterns with real examples
- Defining product requirements and feature specs
- Setting agent boundaries (Always/Ask/Never rules)
- Validating code against documented specs
- Tracking non-functional requirements

### Out of Scope
- **Task decomposition**: Blueprint documents what and why, not how to break down work. Use your preferred task management approach.
- **Code generation**: Specs document decisions, they don't generate code. This is intentional to support iterative refinement.
- **CI/CD pipelines**: Blueprint doesn't configure or manage CI/CD. Use `/blueprint:validate` manually or integrate it into your existing pipeline.
- **Time estimates**: Blueprint focuses on clarity of intent, not project scheduling.
- **Enforced acceptance criteria**: Requirements support iterative refinement. Given/When/Then format is optional, not mandatory.

---

**Placeholders** (use SCREAMING_SNAKE_CASE for consistency):
- `[PROJECT_NAME]` - Name of the project
- `[TODAY]` - Current date in YYYY-MM-DD format
- `[NNN]` - ADR number (zero-padded, e.g., 001, 002)
- `[CHOICE]` - The technology/approach chosen
- `[CATEGORY]` - Category of decision (Runtime, Framework, Database, etc.)

---

## Directory Structure

```
docs/
├── specs/
│   ├── product.md          # Project vision, users, success metrics
│   ├── features/           # Feature specifications (discovered via globbing)
│   │   └── [feature].md    # Individual feature specs
│   ├── tech-stack.md       # Technology decisions
│   ├── non-functional/     # NFR directory (discovered via globbing)
│   │   └── [category].md   # Performance, security, scalability, etc.
│   └── boundaries.md       # Always / Ask / Never rules
├── adrs/
│   └── NNN-[slug].md       # Individual decisions (discovered via globbing)
patterns/
├── good/
│   └── [name].[ext]        # Approved code examples
└── bad/
    └── anti-patterns.md    # Anti-patterns to avoid
CLAUDE.md                   # AI agent instructions
```

---

<!-- SECTION: product-spec -->
## docs/specs/product.md

```markdown
---
last_updated: [TODAY]
---

# [PROJECT_NAME]

## Vision
[1-2 sentence description of what this project is]

## Users

### [User Type 1]
- [What they need from the system]

<!-- TODO: Add more user types if needed -->

## Success Metrics
- [Metric 1]
- [Metric 2]

<!-- TODO: Add success metrics if not yet defined -->

## Features
See `docs/specs/features/` for detailed feature specifications (discovered via globbing).

## Quality Standards
- Run `[lint command]` before committing
- Run `[test command]` for verification
```

**Completion detection:** Skills scan for `<!-- TODO: -->` markers to identify incomplete sections. No tracking arrays needed - the document content is the source of truth.

---

<!-- SECTION: feature-specs -->
## docs/specs/features/[feature].md

Features are discovered via globbing `docs/specs/features/*.md` - no index file required.

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
[Start high-level, refine iteratively as needed]

## Acceptance Criteria (optional)
[Add when ready for test automation]
- Given [context], when [action], then [outcome]
```

---

<!-- SECTION: nfr -->
## docs/specs/non-functional/[category].md

NFRs are discovered via globbing `docs/specs/non-functional/*.md` - one file per category.

**Categories:** `performance.md`, `security.md`, `scalability.md`, `reliability.md`

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

---

<!-- SECTION: tech-stack -->
## docs/specs/tech-stack.md

```markdown
# Technology Stack

## Runtime

| Component | Technology |
|-----------|------------|
| Runtime | [CHOICE] |
| Framework | [CHOICE] |
| Database | [CHOICE] |
| Auth | [CHOICE] |

## Commands

```bash
[package manager] install    # Install dependencies
[package manager] dev        # Development mode
[package manager] test       # Run tests
[package manager] lint       # Lint code
```
```

---

<!-- SECTION: boundaries -->
## docs/specs/boundaries.md

```markdown
# Agent Boundaries

## Always Do

- Run quality commands before commits
- Follow existing code patterns
- Read ADRs before implementing features
- Use patterns from `patterns/good/`
- Link code to ADRs/specs in comments when implementing documented decisions
- Keep comments brief - document design intent in specs, not inline

## Ask First

### Architecture
- [Project-specific items]

### Breaking Changes
- Removing/renaming API response fields
- Changing database schemas

### Dependencies
- Adding new packages
- Upgrading major versions

### Blueprint
- Adding or editing ADRs in docs/adrs/
- Adding or editing specs in docs/specs/
- Modifying boundaries.md

## Never Do

### Security
- Commit secrets or credentials
- Disable authentication
- [Project-specific items]

### Code
- Commit with type errors
- [Project-specific items]

### Documentation
- Create ad-hoc README/markdown files outside the docs/ structure without prior agreement
- Add excessive comments (code should be self-documenting)
- Write long or boilerplate-heavy file header comments instead of concise summaries

## Scoped Rules (Optional)

Rules can be scoped to specific modules when needed:

### src/[module]/
**Always Do:**
- [Module-specific requirements]

**Never Do:**
- [Module-specific prohibitions]
```

---

<!-- SECTION: adr-index -->
## ADR Discovery

**ADRs are discovered via globbing** `docs/adrs/*.md` - no index file required.

Status is read from each ADR's frontmatter (`status: Active|Draft|Outdated|Superseded|Deprecated`).

To list all ADRs, read files in `docs/adrs/*.md` and check the `status` field in each file's frontmatter.

---

<!-- SECTION: adr-template -->
## docs/adrs/NNN-[slug].md (ADR Template)

ADRs support two statuses:
- **Draft**: Incomplete ADR with TODO markers. Can be refined later.
- **Active**: Complete ADR ready for use.

### Minimal ADR (Draft)

When the user provides limited information or says "I'll add more later":

```markdown
---
status: Draft
date: [TODAY]
---

# ADR-[NNN]: [Choice] as [CATEGORY]

## Decision

We chose **[CHOICE]** because [primary motivation].

<!-- TODO: Add context - what problem does this solve? -->
<!-- TODO: Add alternatives considered -->
<!-- TODO: Add consequences (positive and negative) -->
```

**Completion detection:** Skills scan for `<!-- TODO: -->` markers. When all TODOs are resolved, change `status: Draft` to `status: Active`.

### Complete ADR (Active)

When all sections are documented:

```markdown
---
status: Active
date: [TODAY]
---

# ADR-[NNN]: [Choice] as [CATEGORY]

## Context

[What problem are we solving? What are the constraints?]

## Options Considered

### Option 1: [Alternative A]
- Pro: [advantage]
- Con: [disadvantage]

### Option 2: [Alternative B]
- Pro: [advantage]
- Con: [disadvantage]

## Decision

We chose **[CHOICE]** because [primary motivation].

[Additional reasoning]

## Consequences

**Positive:**
- [benefit 1]
- [benefit 2]

**Negative:**
- [tradeoff 1]

## Related

- Tech stack overview: [docs/specs/tech-stack.md](../specs/tech-stack.md)
```

### Refining Draft ADRs

To complete a Draft ADR: fill in the `<!-- TODO: -->` sections, then change `status: Draft` to `status: Active` in the frontmatter.

---

<!-- SECTION: bad-patterns -->
## patterns/bad/anti-patterns.md

```markdown
# Anti-Patterns

Common mistakes to avoid in this codebase.

## How to Add Anti-Patterns

Add a new section below following this format:

## [Category]: [Description]

**Severity:** Critical | High | Medium | Low

### Don't Do This
```[language]
[bad code example]
```

**Problems:**
- [Issue 1]

### Do This Instead
```[language]
[correct code example]
```

**Why:** [Explanation]

---
```

---

<!-- SECTION: good-patterns -->
## patterns/good/[name].[ext]

```
/**
 * [Pattern Name] Example
 *
 * USE THIS PATTERN WHEN:
 * - [Situation 1]
 * - [Situation 2]
 *
 * KEY ELEMENTS:
 * 1. [Important aspect 1]
 * 2. [Important aspect 2]
 *
 * Related ADRs:
 * - [ADR-NNN](../../docs/adrs/NNN-name.md) - [Why this pattern]
 *
 * Source: [original file path]
 */

// --- Example Implementation ---

// ADR-NNN: [Brief reference to the decision]
[extracted code]
```

**Note on comments in patterns:**
- The header block explains WHEN and WHY (for pattern discovery)
- Inline comments show HOW to reference ADRs in actual code
- Keep inline comments brief - just the ADR reference and a short note

---

<!-- SECTION: claude-md -->
## CLAUDE.md

```markdown
# AI Agent Instructions for [PROJECT_NAME]

## Project Context

[Project description]

## Architecture Decisions

All tech choices and their rationale are documented in `docs/adrs/`.
See `docs/specs/tech-stack.md` for a summary table.

## CRITICAL: Pre-Edit Checklist

**BEFORE writing or editing ANY code, you MUST:**

1. **Check Feature Specs**
   - If implementing a documented feature, READ `docs/specs/features/[feature].md` FIRST
   - Look for `related_adrs` field - these ADRs MUST be followed
   - If no spec exists for a significant feature, ask: "Should I create a feature spec first?" (see Creating Documentation below)

2. **Check Boundaries**
   - Read `docs/specs/boundaries.md` before ANY code changes
   - "Never Do" items are HARD BLOCKERS - refuse to proceed if violated
   - "Ask First" items require explicit user confirmation before proceeding

3. **Reference Patterns**
   - Check `patterns/good/` for examples of how to write this type of code
   - Check `patterns/bad/anti-patterns.md` to know what to avoid
   - Follow existing patterns in the codebase

4. **Traceability**
   - When implementing a decision, add: `// ADR-NNN: [brief note]`
   - Keep it short - the ADR has the full rationale

**BOUNDARY VIOLATIONS**

If a user request would violate a "Never Do" boundary:
1. DO NOT proceed with the implementation
2. INFORM the user: "This request would violate boundary: [rule]"
3. SUGGEST alternative approaches that comply with boundaries

## Documentation

| Directory | Purpose |
|-----------|---------|
| `docs/specs/` | Product requirements, tech decisions, boundaries |
| `docs/specs/features/` | Feature specifications with requirements and acceptance criteria |
| `docs/adrs/` | Architecture Decision Records - the "why" behind choices |
| `patterns/good/` | Approved code examples to follow |
| `patterns/bad/` | Anti-patterns to avoid |

See [docs/specs/boundaries.md](docs/specs/boundaries.md) for agent guardrails (Always/Ask/Never rules).

## Code Comments

Reference ADRs with a brief note - the ADR has the full rationale:

```typescript
// ADR-003: Repository pattern
// ADR-007: Rate limiting
```

**Don't duplicate full rationale in comments:**
```typescript
// Bad: Using repository pattern because it abstracts data access and makes testing easier
// Good: // ADR-003: Repository pattern
```

## Pattern Discovery

When the user corrects or discourages a code pattern during development:
- If they show a better way → Suggest: "Should I capture this as a good pattern?" (see Creating Documentation below)
- If they say "don't do X" → Suggest: "Should I document this as an anti-pattern?" (see Creating Documentation below)

This captures lessons learned organically during development.

## Creating Documentation

This section explains how to create and update documentation without any plugins.

### Adding a New ADR

**Naming:** `docs/adrs/NNN-[slug].md` (e.g., `004-redis-caching.md`)

**Find next number:** Check existing files in `docs/adrs/` and use the next sequential number.

**Template:**
```markdown
---
status: Active
date: YYYY-MM-DD
---

# ADR-NNN: [Choice] for [Purpose]

## Context
[What problem are we solving? What constraints exist?]

## Decision
We chose **[choice]** because [primary motivation].

## Consequences
**Positive:**
- [benefit]

**Negative:**
- [tradeoff]
```

**Status values:** `Draft` (incomplete), `Active` (current), `Superseded` (replaced), `Deprecated` (retired)

### Adding a Feature Spec

**Location:** `docs/specs/features/[feature-slug].md`

**Template:**
```markdown
---
status: Active
module: src/[module-path]/
related_adrs: []
---

# [Feature Name]

## Overview
[1-2 sentence description]

## User Stories
- As a [user type], I want [capability] so that [benefit]

## Requirements
- [Requirement 1]
- [Requirement 2]
```

### Adding a Good Pattern

**Location:** `patterns/good/[descriptive-name].[ext]`

**Template:**
```
/**
 * [Pattern Name]
 *
 * USE THIS PATTERN WHEN:
 * - [Situation 1]
 * - [Situation 2]
 *
 * KEY ELEMENTS:
 * 1. [Important aspect]
 * 2. [Important aspect]
 *
 * Related ADRs: ADR-NNN
 */

// --- Example Implementation ---
[actual code example]
```

### Adding an Anti-Pattern

**Location:** Edit `patterns/bad/anti-patterns.md` and add a new section:

```markdown
## [Category]: [Brief Description]

**Severity:** Critical | High | Medium | Low

### Don't Do This
```[language]
[bad code example]
```

**Problems:**
- [Issue]

### Do This Instead
```[language]
[correct code example]
```

**Why:** [Explanation]
```

## Commands

```bash
[commands]
```
```

---

## Usage in Skills

Skills should reference these templates rather than duplicating them:

```markdown
Create files using templates from `_templates/TEMPLATES.md`:
- `docs/specs/product.md` - Project vision, users, success metrics
- `docs/specs/features/[feature].md` - Feature specifications (discovered via globbing)
- `docs/specs/tech-stack.md` - Technology decisions and commands
- `docs/specs/non-functional/[category].md` - NFRs by category (discovered via globbing)
- `docs/specs/boundaries.md` - Agent guardrails (Always/Ask/Never)
- `docs/adrs/NNN-*.md` - Individual ADRs (discovered via globbing)
```

---

<!-- SECTION: flexible-input -->
## Flexible Information Gathering

### Core Principle: Accept Any Order

**Parse ALL information from input before asking ANY questions.**

Users should be able to provide information in whatever order makes sense to them. The skill extracts what's given and only asks about genuine gaps.

### Information Extraction Rules

When parsing user input, look for these patterns:

| Signal | Extracts |
|--------|----------|
| "because [reason]" | Rationale |
| "for [purpose]" | Context / Problem being solved |
| "instead of [X]" / "not [X]" | Alternative considered (rejected) |
| "[X] over [Y]" | Decision + rejected alternative |
| "in [path]" / "at [path]" | File location |
| "team knows" / "familiar with" | Rationale: team experience |
| "we need [X]" / "requires [X]" | Requirement / constraint |
| "industry standard" / "best practice" | Rationale: convention |
| "[tech] because [reason]" | Decision + rationale together |

### Example Parsing

**Input:** `/blueprint:decide PostgreSQL because the team knows it and we need ACID`

**Extracts:**
- Decision: PostgreSQL
- Rationale: Team familiarity
- Context: Data integrity needs (ACID requirement)

**Result:** Create ADR immediately with minimal or no questions.

**Input:** `/blueprint:setup-repo TaskAPI: Node REST API with Express and Postgres, team knows these`

**Extracts:**
- Name: TaskAPI
- Description: Node REST API
- Runtime: Node.js
- Framework: Express
- Database: PostgreSQL
- Rationale: Team familiarity

**Result:** Show preview and create, no questions needed.

### Never Ask For What's Already Provided

If the user said "because the team knows it", do NOT ask "Why this choice?" - the rationale was already given.

---

<!-- SECTION: interview -->
## Interview Standards (Simplified)

### Core Principle: Create First, Refine Later

**Don't block on missing information. Use TBD markers and let users run the skill again.**

1. Parse input for any provided information
2. Create artifact immediately with what you have
3. Mark missing sections with `<!-- TODO: ... -->` or "TBD"
4. Report what was created and what needs refinement

### Questions: Content Only, Never Scope

**Allowed questions** (about content gaps):
- "Why was X chosen?" - to fill TBD rationale
- "Who are the users?" - if not found in docs

**Forbidden questions** (about scope):
- "What would you like to create?"
- "Full setup or partial?"
- "Which artifacts should I generate?"

### TBD Markers

Missing information → TBD marker, not blocking question:

```markdown
## Rationale
TBD - edit this section to add rationale
```

```markdown
<!-- TODO: Add user stories -->
```

### After Creation

```markdown
Created [artifact] at [path]

TBD sections can be filled by running [command] again.
```

---

<!-- SECTION: progress-indicators -->
### Progress Indicators

For operations with 3+ steps or that may take significant time, provide status updates:

```markdown
**Multi-step operations:**
- "Analyzing codebase structure (step 1/4)..."
- "Scanning for patterns (step 2/4)..."
- "Generating report (step 3/4)..."
- "Finalizing results (step 4/4)..."

**Long-running scans:**
- "Scanning src/ directory... found 15 matches so far"
- "Analyzing 50 commits... processing batch 2 of 4"
```

**When to use progress indicators:**
- Git history analysis (onboard)
- Codebase validation (validate)
- Large file scans (>100 files)
- Any operation the user might think is stuck

**Format:**
- Use "step X/Y" format for discrete steps
- Use "processing batch X of Y" for chunked operations
- Include running counts where meaningful ("found 15 matches so far")

---

<!-- SECTION: system-error-recovery -->
### System Error Recovery

If a tool or operation fails (not user error):

```markdown
## System Error Recovery

**If file/tool errors occur:**
1. Log the specific failure but continue other operations
2. Report partial results clearly:
   "Completed 4/5 checks. 1 check failed (permission denied on .env)"
3. Offer to retry: "Retry failed checks?"

**If context limits approached:**
1. Summarize results so far
2. Offer to continue in batches: "Found 50+ issues. Show Critical/High only, or continue with all?"

**If operation partially completes:**
1. Save/report what was accomplished
2. Clearly indicate what remains: "Created 3/5 ADRs. Remaining: [list]"
3. Offer to continue: "Continue with remaining items?"
```

**Principles:**
- Never fail silently - always report what happened
- Partial success is better than complete failure
- Give the user control over how to proceed
- Preserve work done so far (don't rollback unless explicitly requested)
