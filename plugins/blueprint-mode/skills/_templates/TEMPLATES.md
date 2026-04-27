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
| Patterns: good | `<!-- SECTION: good-patterns -->` | Capturing good code patterns |
| Patterns: bad | `<!-- SECTION: bad-patterns -->` | Documenting code anti-patterns |
| Design: separation | `<!-- SECTION: design-separation -->` | Understanding code vs design split |
| Design: UX decisions | `<!-- SECTION: ux-decision-template -->` | Creating UX decisions |
| Design: UX-TBD marker | `<!-- SECTION: ux-tbd-comment -->` | Flagging unclear UI intent in code |
| Triage: code vs design | `<!-- SECTION: triage-design -->` | Routing UX vs tech decisions |
| CLAUDE.md | `<!-- SECTION: claude-md -->` | Creating agent instructions |
| Interview Standards | `<!-- SECTION: interview -->` | Following interview patterns |

**To read a specific section:** Search for the marker, then read ~50-100 lines.

---

## Plugin Scope

**Blueprint is for:** Making human intent explicit so agents can tell deliberate choices from coincidental implementation.

### In Scope
- Documenting architectural decisions (ADRs) with rationale
- Capturing good/bad code patterns with real examples
- Capturing deliberate UX/design decisions when the opt-in design tree exists
- Reading and updating repo-root `DESIGN.md` for cross-cutting design rules and prohibitions
- Defining product requirements and feature specs
- Setting agent boundaries (Always/Ask/Never rules) in `docs/specs/boundaries.md`
- Validating code against documented specs
- Tracking non-functional requirements

### Out of Scope
- **Task decomposition**: Blueprint documents what and why, not how to break down work. Use your preferred task management approach.
- **Code generation**: Specs document decisions, they don't generate code. This is intentional to support iterative refinement.
- **Parallel design source of truth for what exists**: Code remains canonical for UI state. `DESIGN.md` and UX decisions record why important design choices should persist.
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
DESIGN.md                   # Top-level design context — optional, cross-cutting UI rules

docs/                       # CODE / ARCHITECTURE TREE — engineering audience
├── specs/
│   ├── product.md          # Project vision, users, success metrics
│   ├── features/           # Feature specifications (discovered via globbing)
│   │   └── [feature].md    # Individual feature specs
│   ├── tech-stack.md       # Technology decisions
│   ├── non-functional/     # NFR directory (discovered via globbing)
│   │   └── [category].md   # Performance, security, scalability, etc.
│   └── boundaries.md       # Always / Ask / Never rules
├── adrs/
│   └── NNN-[slug].md       # Architecture decisions (discovered via globbing)
patterns/                   # CODE patterns only (engineering audience)
├── good/
│   └── [name].[ext]        # Approved code examples
└── bad/
    └── anti-patterns.md    # Code anti-patterns to avoid

design/                     # DESIGN / UX TREE — OPT-IN, set up by /blueprint:onboard-design
├── sources.md              # External design sources (Figma, Storybook, docs URLs)
└── ux-decisions/
    └── NNN-[slug].md       # UX decisions (discovered via globbing)

CLAUDE.md                   # AI agent instructions
```

**The `design/` tree is opt-in.** It is created by `/blueprint:onboard-design` and never auto-scaffolded by other skills. Repos without UI in scope (backend services, libraries, CLIs) typically won't have it. Skills that triage code vs design must check tree existence before producing design output paths.

<!-- SECTION: design-separation -->
## Code/Architecture vs Design/UX: Strict Separation

**The `docs/` + `patterns/` tree and the `design/` tree are NEVER interchangeable.**

Different audiences review different trees (CODEOWNERS-style routing):
- `docs/**`, `patterns/**` → engineering reviewers
- `design/**` → design reviewers (only if the tree exists)

**The design tree is opt-in.** Set it up with `/blueprint:onboard-design`. Until then, triage skills only produce code-tree output and warn the user when they see strong UX/UI signals.

| Concern | Tree | Captured by |
|---------|------|-------------|
| Tech/architecture decision (e.g. "Postgres over Mongo") | `docs/adrs/` | `/blueprint:decide` |
| UX/design decision (e.g. "modal over page for X", "destructive confirm") | `design/ux-decisions/` | `/blueprint:decide` (triages) |
| Cross-cutting design rule (e.g. "never more than 3 colours") | `DESIGN.md` | `/blueprint:decide` or `/blueprint:capture` |
| Functional or non-functional requirement | `docs/specs/...` | `/blueprint:require` |
| Pattern (any subject — code, schema, UI) | `patterns/good/` or `patterns/bad/` | `/blueprint:good-pattern` / `/blueprint:bad-pattern` |

**UX decisions are NOT ADRs** — they live in their own tree with independent numbering even though the document shape is similar.

### Deliberate vs Coincidental UI

Current UI code is not automatically design intent. Agents should treat:

- **`DESIGN.md` rules** (cross-cutting prohibitions, visual rules, voice/tone) as constraints that apply on every UI generation task.
- **Documented UX decisions** as deliberate per-context constraints to preserve or consciously supersede.
- **Documented UI patterns** as approved examples to follow.
- **Undocumented UI code** as implementation state that may be coincidental, especially if generated by an agent.

When a user or designer says a UI choice was intentional, capture the rationale where it belongs (see `DESIGN.md` vs UX decisions below) instead of relying on the current code shape to carry that meaning. When the agent encounters UI code that has no governing decision and no clear rationale, mark it with the `// UX-TBD:` flag (see `<!-- SECTION: ux-tbd-comment -->`) rather than inventing rationale.

### `DESIGN.md` vs `design/ux-decisions/`: when to use which

Both layers carry design intent, but at different scopes. Pick by asking *"is this a rule that applies broadly, or one decision among alternatives?"*

| Goes in `DESIGN.md` (repo root) | Goes in `design/ux-decisions/UX-NNN-*.md` |
|---|---|
| Cross-cutting rules that apply across the product | A specific choice with alternatives considered |
| "Never use more than 3 colours on a screen" | "Modal vs full page for destructive confirmation — chose modal because…" |
| Visual rules, voice/tone, type scale, token usage | Per-flow or per-component rationale |
| The kind of statement that's true on every screen | The kind of statement that's about *one thing* and what it was chosen over |
| Read by agents on every UI generation task | Read by agents when working on the affected surface |

**Don't duplicate.** A UX decision that derives from or codifies a `DESIGN.md` rule should *reference* the rule, not restate it. If a draft UX decision is really a cross-cutting prohibition with no alternatives, move it to `DESIGN.md` instead.

**On `DESIGN.md` itself:** It's a community convention (Google Stitch / awesome-design-md), not a Blueprint-owned format. Blueprint stays compatible with it — `/blueprint:onboard-design` can scaffold a minimal stub when the user wants one, and Blueprint reads/respects the file when present. The team owns the file's contents; Blueprint avoids duplicating information that belongs there. Authoring stays conversational; never hand-fill it from a template — the same anti-ritual rule that applies to ADRs and UX decisions applies here.

---

<!-- SECTION: ux-tbd-comment -->
## UX-TBD Code Comment Convention

When UI code has no governing UX decision and the agent isn't sure if the choice is deliberate, mark it explicitly rather than inventing rationale.

```tsx
// UX-TBD: empty-state copy — agent-generated, not reviewed
<EmptyState message="..." />
```

```tsx
// UX-TBD: card layout — carried over from prototype, no UX decision yet
<ProductCard ... />
```

**What `UX-TBD:` means:**
- This UI element exists in code but has no documented UX rationale.
- The agent (or whoever wrote it) is flagging it for designer review.
- It is NOT a decision. It does NOT mean "deliberate".
- It signals: *if this matters, capture it as a UX decision; if not, the next agent is free to change it.*

**When to use it:**
- Agent generates UI without an existing UX decision to follow.
- Code is carried over from a prototype, mockup, or earlier session and its intent is unclear.
- The reviewer (human or agent) wants to surface "is this deliberate?" without forcing a premature UX decision.

**When NOT to use it:**
- A UX decision already exists — use `// UX-NNN: brief note` instead.
- The choice is purely engineering (state shape, performance) — that's an `// ADR-NNN:` reference, not UX.
- The UI is trivial scaffolding with no design weight (a `<div>` wrapper, layout primitives) — silence is fine.

**Lifecycle:**
- A `UX-TBD:` is a flag, not a permanent annotation. It should resolve in one of three ways:
  1. Designer confirms intent → upgrade to a UX decision (`/blueprint:decide`) and replace the comment with `// UX-NNN: [brief]`.
  2. Designer says it doesn't matter → remove the comment.
  3. Code is rewritten → the comment goes with it.

**Symmetry note:** This is the design-tree counterpart to "deliberate vs coincidental" architecture. ADRs already answer the question for tech choices; `UX-TBD:` + UX decisions answer it for UI.

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

Everything is a work-in-progress. The `maturity` field tracks how evolved a feature is — there are no separate "WIP" documents.

```markdown
---
status: Active
maturity: Exploring | Building | Hardening | Stable
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

## Implementation State
<!-- Update this section as work progresses. It is the "living" part of the spec. -->

**Current focus:** [What's being worked on now, or "None" if idle]

| Milestone | Status |
|-----------|--------|
| [milestone 1] | Done / In Progress / Not Started |

**Open questions:**
- [Unresolved decision or unknown that blocks progress]

**Constraints:**
- [Active constraint affecting implementation]

## Acceptance Criteria (optional)
[Add when ready for test automation]
- Given [context], when [action], then [outcome]
```

### Maturity Levels

| Level | Meaning | Typical state |
|-------|---------|---------------|
| Exploring | Idea or early investigation | Sparse spec, many TODOs, no/little code |
| Building | Active development | Requirements solidifying, code in progress |
| Hardening | Feature complete, stabilizing | Tests, edge cases, polish |
| Stable | Production-ready, low churn | Complete spec, full test coverage |

Maturity can go backwards (e.g., Stable → Building when a major rework begins).

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

Status is read from each ADR's frontmatter (`status: Active|Draft|Superseded|Deprecated`).

To list all ADRs, read files in `docs/adrs/*.md` and check the `status` field in each file's frontmatter.

---

<!-- SECTION: adr-template -->
## docs/adrs/NNN-[slug].md (ADR Template)

ADRs are meant to evolve. Start as Draft and iterate toward Active — don't wait for a perfect decision before writing it down.

ADR statuses:
- **Draft**: Emerging decision. Has TODO markers, options may still be open. Iterate freely.
- **Active**: Decision is settled and being followed.
- **Superseded**: Replaced by a newer ADR.
- **Deprecated**: No longer relevant.

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

<!-- SECTION: triage-design -->
## Triage: Code/Architecture vs Design/UX

Skills that handle both trees (`decide`, `good-pattern`, `bad-pattern`, `capture`, `supersede`) MUST classify the input before writing.

### Decision triage (`/blueprint:decide`)

| Signal in input | Type | Destination |
|-----------------|------|-------------|
| Tech choice, library, infra, "[X] over [Y]" technical, design pattern (code), runtime/framework/database | Architectural | `docs/adrs/NNN-[slug].md` |
| User flow, navigation, "modal vs page", confirmation, copy/voice, empty state, error state, interaction model, layout, visual hierarchy | UX | `design/ux-decisions/NNN-[slug].md` |
| Cross-cutting visual/voice/prohibition rule | Design rule | `DESIGN.md` |
| Functional requirement, user capability | Functional | `docs/specs/features/` (redirect to `/blueprint:require`) |
| Latency, uptime, encryption, scale targets | Non-functional | `docs/specs/non-functional/` (redirect to `/blueprint:require`) |

### Patterns

`/blueprint:good-pattern` and `/blueprint:bad-pattern` are **tree-agnostic**: every pattern (code, schema, UI, build script) files under `patterns/good/[name].[ext]` or `patterns/bad/anti-patterns.md`. The header comment can link to ADRs (tech rationale) and/or UX decisions (UX rationale) — whichever apply.

---

<!-- SECTION: ux-decision-template -->
## design/ux-decisions/NNN-[slug].md (UX Decision Template)

UX decisions document **why** a design/UX choice was made. Same shape as ADRs (Context, Options, Decision, Consequences) but separate file tree, separate numbering, and a design audience.

**Reference style:** `UX-NNN` (e.g. `UX-007`) — parallel to `ADR-NNN`, never conflated.

UX decisions are discovered via globbing `design/ux-decisions/*.md`. Status from frontmatter `status:` field.

### Status Values

- **Draft**: Emerging decision, has TODOs. Iterate freely.
- **Active**: Decision is settled and being followed.
- **Superseded**: Replaced by a newer UX decision.
- **Deprecated**: No longer relevant.

### Minimal UX Decision (Draft)

```markdown
---
status: Draft
date: [TODAY]
---

# UX-[NNN]: [Choice] for [Context]

## Decision

We chose **[CHOICE]** because [primary motivation].

<!-- TODO: Add context — what user problem or interaction is this solving? -->
<!-- TODO: Add alternatives considered -->
<!-- TODO: Add consequences (positive and negative) -->
```

### Complete UX Decision (Active)

```markdown
---
status: Active
date: [TODAY]
---

# UX-[NNN]: [Choice] for [Context]

## Context

[What user problem, interaction, or design tension is this solving? Who experiences it?]

## Options Considered

### Option 1: [Alternative A]
- Pro: [advantage]
- Con: [disadvantage]

### Option 2: [Alternative B]
- Pro: [advantage]
- Con: [disadvantage]

## Decision

We chose **[CHOICE]** because [primary motivation].

[Additional reasoning — user research, heuristics, constraints]

## Consequences

**Positive:**
- [benefit]

**Negative:**
- [tradeoff]

## Related

- Related UX decisions: [UX-NNN]
```

### UX Decision Format Enforcement (CRITICAL)

| DO NOT use | USE instead |
|------------|-------------|
| `# ADR-NNN` (this is a UX decision) | `# UX-NNN` |
| `## Status` with "Accepted" in body | YAML frontmatter `status: Active` |
| `**Benefits:**` | `**Positive:**` |
| `**Trade-offs:**` | `**Negative:**` |
| `## References` | `## Related` |
| Filing in `docs/adrs/` | File in `design/ux-decisions/` |

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

4. **For UI work, also check design intent**
   - Read `DESIGN.md` if it exists for cross-cutting design rules and prohibitions
   - Check `design/ux-decisions/` if it exists for UX choices that constrain the work
   - Treat documented UX decisions as deliberate design intent
   - Do not assume undocumented UI code is deliberate; preserve it when practical, but flag unclear intent with `// UX-TBD: [what's unclear]` instead of inventing rationale

5. **Traceability**
   - When implementing an architectural decision, add: `// ADR-NNN: [brief note]`
   - When implementing a UX decision, add: `// UX-NNN: [brief note]`
   - Keep it short - the ADR / UX decision has the full rationale

**BOUNDARY VIOLATIONS**

If a user request would violate a "Never Do" boundary:
1. DO NOT proceed with the implementation
2. INFORM the user: "This request would violate boundary: [rule]"
3. SUGGEST alternative approaches that comply with boundaries

## Documentation

Blueprint splits artifacts into separate repo paths. Different reviewers can own different files — never mix ADRs and UX decisions.

| Directory | Purpose |
|-----------|---------|
| `DESIGN.md` | Top-level design context: cross-cutting UI rules and prohibitions |
| `docs/specs/` | Product requirements, tech decisions, boundaries |
| `docs/specs/features/` | Feature specs with requirements, maturity, and implementation state |
| `docs/adrs/` | Architecture Decision Records - the "why" behind tech choices |
| `patterns/good/` | Approved code examples to follow |
| `patterns/bad/` | Anti-patterns to avoid |
| `design/sources.md` | External design sources (Figma, Storybook, docs URLs) |
| `design/ux-decisions/` | UX decisions (UX-NNN) - the "why" behind UX/design choices |

See [docs/specs/boundaries.md](docs/specs/boundaries.md) for agent guardrails (Always/Ask/Never rules).

## Code Comments

Reference ADRs / UX decisions with a brief note - the source doc has the full rationale:

```typescript
// ADR-003: Repository pattern
// ADR-007: Rate limiting
// UX-002: Destructive actions require confirmation
```

**Don't duplicate full rationale in comments:**
```typescript
// Bad: Using repository pattern because it abstracts data access and makes testing easier
// Good: // ADR-003: Repository pattern
```

**Flagging unclear UI intent (`// UX-TBD:`):** When UI code has no governing UX decision and the agent isn't sure if a choice is deliberate, mark it explicitly rather than inventing rationale:

```typescript
// UX-TBD: empty-state copy - agent-generated, not reviewed
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
maturity: Exploring | Building | Hardening | Stable
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

## Implementation State

**Current focus:** [What's being worked on now]

| Milestone | Status |
|-----------|--------|
| [milestone] | Done / In Progress / Not Started |

**Open questions:**
- [Unresolved decisions]
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
Code / architecture tree (engineering audience):
- `docs/specs/product.md` - Project vision, users, success metrics
- `docs/specs/features/[feature].md` - Feature specifications (discovered via globbing)
- `docs/specs/tech-stack.md` - Technology decisions and commands
- `docs/specs/non-functional/[category].md` - NFRs by category (discovered via globbing)
- `docs/specs/boundaries.md` - Agent guardrails (Always/Ask/Never)
- `docs/adrs/NNN-*.md` - Individual ADRs (discovered via globbing)
- `patterns/good/*` - Patterns to follow (any subject)
- `patterns/bad/anti-patterns.md` - Anti-patterns to avoid (any subject)

Design / UX tree (design audience):
- `design/ux-decisions/NNN-*.md` - UX decisions (discovered via globbing)
- `design/sources.md` - External Figma / Storybook / docs URLs
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
