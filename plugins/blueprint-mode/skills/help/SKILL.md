---
name: blueprint:help
description: Explain Blueprint Mode plugin and available commands. Use when the user asks about Blueprint features, how to use skills, or needs guidance on spec-driven development workflow.
argument-hint: "[topic: commands|workflow|specs|adrs|patterns|design]"
allowed-tools:
  - Glob
  - Read
---

# Blueprint Help

Explain Blueprint Mode plugin and available commands.

**Invoked by:** `/blueprint:help` or when user asks "how does blueprint work?", "what commands are available?", "how do I use specs?".

## Principles

1. **Context-aware**: Focus on the topic the user asked about.
2. **Actionable**: Always suggest concrete next steps.
3. **Discoverable**: Help users find related commands.

## Process

### Step 1: Determine Help Topic

If a specific topic is provided, focus on that area. Otherwise, provide a general overview.

**Topics:**
- `commands` - List all available skills with descriptions
- `workflow` - Explain the recommended development workflow
- `specs` - How to work with specifications
- `adrs` - How to work with Architecture Decision Records
- `patterns` - How to work with patterns (any subject)
- `design` - How the design tree works (UX decisions)

### Step 2: Display Help

#### General Overview (default)

```markdown
## Blueprint Mode

Blueprint Mode keeps humans in control of system design during AI-assisted development by documenting:

**Code / architecture tree** (engineering audience):
- **Specs** - What you're building and why (`docs/specs/`)
- **ADRs** - Architecture decisions with rationale (`docs/adrs/`)
- **Code patterns** - Code examples to follow and avoid (`patterns/`)
- **Boundaries** - Rules for AI agents (`docs/specs/boundaries.md`)

**Design / UX tree** (design audience):
- **UX decisions** - The "why" behind UX/design choices (`design/ux-decisions/`)

The two trees are strictly separate so different reviewers (engineering vs design) can own different paths via CODEOWNERS.

### Getting Started

**New project:**
```
/blueprint:setup-repo
```

**Existing codebase:**
```
/blueprint:onboard
```

### Available Commands

| Command | Purpose |
|---------|---------|
| `/blueprint:setup-repo` | Create new project with spec structure |
| `/blueprint:onboard` | Add spec structure to existing codebase (code/architecture tree only) |
| `/blueprint:onboard-design` | Opt in to the design tree — interviews user, ingests Figma/Storybook refs |
| `/blueprint:require` | Add functional or non-functional requirements |
| `/blueprint:decide` | Record decisions — triages tech (ADR) vs UX (UX decision, only if design tree exists) |
| `/blueprint:good-pattern` | Capture approved patterns (any subject — code, schema, UI) |
| `/blueprint:bad-pattern` | Document anti-patterns (any subject — code, schema, UI) |
| `/blueprint:supersede` | Replace or deprecate a previous decision (ADR or UX) |
| `/blueprint:list-adrs` | List all ADRs with status (architectural only) |
| `/blueprint:status` | Show overview of Blueprint structure (both trees if present) |
| `/blueprint:validate` | Check code against documented specs and design |
| `/blueprint:help` | Show this help |

### Before Writing Code

**IMPORTANT:** Before implementing any feature, you should:

1. Check if a feature spec exists in `docs/specs/features/`
2. Read relevant ADRs (check `related_adrs` field in specs)
3. Review `docs/specs/boundaries.md` for rules
4. Check `patterns/good/` for examples to follow
5. Check `patterns/bad/anti-patterns.md` for what to avoid

Run `/blueprint:validate` to check if your code follows documented specs.
```

#### Commands Topic

```markdown
## Blueprint Commands

### Setup & Onboarding
| Command | Use When |
|---------|----------|
| `/blueprint:setup-repo` | Starting a brand new project |
| `/blueprint:onboard` | Adding Blueprint to an existing codebase (code/architecture tree only) |
| `/blueprint:onboard-design` | Opting in to the design tree (UX decisions) |

### Documentation
| Command | Use When |
|---------|----------|
| `/blueprint:require [desc]` | Adding a feature or non-functional requirement (NOT for components) |
| `/blueprint:decide [topic]` | Making a technology or UX/design choice (skill triages) |
| `/blueprint:good-pattern [file]` | Capturing examples to emulate (any subject) |
| `/blueprint:bad-pattern [desc]` | Documenting things to avoid (any subject) |
| `/blueprint:supersede [ADR\|UX]` | Replacing or retiring a previous ADR or UX decision |

### Discovery & Validation
| Command | Use When |
|---------|----------|
| `/blueprint:status` | Checking what's been documented |
| `/blueprint:list-adrs` | Reviewing all architecture decisions |
| `/blueprint:validate` | Verifying code matches specs |
| `/blueprint:help [topic]` | Getting help with Blueprint |
```

#### Workflow Topic

```markdown
## Recommended Workflow

### 1. Set Up (Once)

**New project:**
```
/blueprint:setup-repo
```
This interviews you about your project and creates the full spec structure.

**Existing project:**
```
/blueprint:onboard
```
This analyzes your codebase and creates specs from what exists.

### 2. Document Decisions

When making a tech choice:
```
/blueprint:decide Use PostgreSQL because the team knows it well
```

When adding a feature requirement:
```
/blueprint:require Users can reset password via email
```

### 3. Capture Patterns

When you see good code:
```
/blueprint:good-pattern src/repositories/user.repository.ts
```

When you see code to avoid:
```
/blueprint:bad-pattern Using any type in TypeScript
```

### 4. Before Implementing

Always check specs before coding:
1. Read `docs/specs/features/` for what to build
2. Read `docs/adrs/` for how to build it
3. Read `docs/specs/boundaries.md` for rules to follow
4. Check `patterns/good/` for examples

### 5. Validate

After implementing:
```
/blueprint:validate
```
This checks your code against documented specs and patterns.

### 6. Evolve

When decisions change:
```
/blueprint:supersede ADR-003
```
This preserves history while recording the new decision.
```

#### Specs Topic

```markdown
## Working with Specs

Specs live in `docs/specs/` and define **what** you're building.

### Files

| Path | Purpose |
|------|---------|
| `product.md` | Project vision, users, success metrics |
| `tech-stack.md` | Technology choices |
| `boundaries.md` | Rules for AI agents (Always/Ask/Never) |
| `features/*.md` | Feature specs (discovered via globbing) |
| `non-functional/*.md` | NFRs by category (discovered via globbing) |

### Adding Requirements

**Functional requirement:**
```
/blueprint:require Users can export data as CSV
```
Creates a feature spec in `docs/specs/features/`.

**Non-functional requirement:**
```
/blueprint:require API response under 100ms P95
```
Creates `docs/specs/non-functional/performance.md`.

### Feature Spec Structure

```markdown
---
status: Planned | Active | Deprecated
module: src/[path]/
related_adrs: [001, 003]
---

# Feature Name

## Overview
What this feature does.

## User Stories
- As a [user], I want [capability] so that [benefit]

## Requirements
What must be true for this feature to work.

## Acceptance Criteria (optional)
- Given [context], when [action], then [outcome]
```
```

#### ADRs Topic

```markdown
## Working with ADRs

Architecture Decision Records live in `docs/adrs/` and capture **why** you made choices.

### Creating ADRs

```
/blueprint:decide Use PostgreSQL because the team has experience
```

ADRs can be:
- **Active** - Current decisions in use
- **Draft** - Incomplete, needs more info
- **Superseded** - Replaced by a newer decision
- **Deprecated** - Retired without replacement

### ADR Structure

```markdown
---
status: Active
date: 2025-01-25
---

# ADR-001: PostgreSQL as Database

## Context
What problem we're solving.

## Options Considered
- Option A: pros/cons
- Option B: pros/cons

## Decision
We chose X because [reason].

## Consequences
What this means for the project.

## Related
Links to other ADRs or specs.
```

### Evolving Decisions

When a decision changes:
```
/blueprint:supersede ADR-001
```

This creates a new ADR and marks the old one as superseded, preserving history.

### Listing ADRs

```
/blueprint:list-adrs
/blueprint:list-adrs active
/blueprint:list-adrs database
```
```

#### Patterns Topic

```markdown
## Working with Patterns

Patterns live in `patterns/` and show **how** to write code.

### Good Patterns

Located in `patterns/good/`. These are real code examples to emulate.

**Capturing a pattern:**
```
/blueprint:good-pattern src/repositories/user.repository.ts
```

**Pattern file structure:**
```typescript
/**
 * Repository Pattern Example
 *
 * USE THIS PATTERN WHEN:
 * - Accessing database entities
 * - Need consistent data access layer
 *
 * KEY ELEMENTS:
 * 1. Single responsibility
 * 2. Interface-based
 *
 * Related ADRs:
 * - ADR-003: Repository pattern
 */

// --- Example Implementation ---
// ADR-003: Repository pattern
export class UserRepository {
  // ... actual code
}
```

### Anti-Patterns

Located in `patterns/bad/anti-patterns.md`. These document what NOT to do.

**Documenting an anti-pattern:**
```
/blueprint:bad-pattern Inline SQL without parameterization
```

**Anti-pattern entry structure:**
```markdown
## Security: SQL Injection Risk

**Severity:** Critical

### Don't Do This
[bad code example]

### Do This Instead
[good code example]

**Why:** [explanation]
```

### Using Patterns

Before writing code:
1. Check `patterns/good/` for relevant code examples
2. Check `patterns/bad/anti-patterns.md` for code to avoid
3. Follow the patterns you find

```

#### Design Topic

```markdown
## Working with the Design Tree

The design tree is a **separate, OPT-IN** Blueprint tree from the code/architecture tree. It lives under `design/` and is reviewed by designers (set up CODEOWNERS to route `design/**` to design reviewers).

### Opting in

The design tree is created by:

```
/blueprint:onboard-design
```

This skill:
- Scaffolds `design/ux-decisions/` and `design/sources.md`
- Records external design tool URLs (Figma, Storybook, etc.) in `design/sources.md`
- Updates `CLAUDE.md` / `AGENTS.md` to point at the design tree

You can run it again any time to add more sources to `design/sources.md`.

If you don't run this skill, no other skill will create the design tree for you. `/blueprint:decide` will detect strong UX signals and warn you before filing the content as an ADR.

### Files

| Path | Purpose | Captured by |
|------|---------|-------------|
| `design/sources.md` | External design tool URLs (Figma, Storybook, docs) | `/blueprint:onboard-design` |
| `design/ux-decisions/NNN-*.md` | UX decisions (UX-NNN) — the "why" behind UX choices | `/blueprint:decide` (triages) |

### What goes where

| Concern | Goes to | Skill |
|---------|---------|-------|
| Tech/architecture decision | `docs/adrs/` | `/blueprint:decide` |
| UX decision (modal vs page, copy/voice, interaction) | `design/ux-decisions/` | `/blueprint:decide` |
| Functional requirement (user can do X) | `docs/specs/features/` | `/blueprint:require` |
| Non-functional requirement (latency, uptime) | `docs/specs/non-functional/` | `/blueprint:require` |
| Pattern (any subject — code, schema, UI) | `patterns/` | `/blueprint:good-pattern` / `/blueprint:bad-pattern` |

### Tree separation rules

- UX decisions live under `design/ux-decisions/`, **never** under `docs/adrs/`
- ADRs live under `docs/adrs/`, **never** under `design/`
- UX decisions and ADRs use independent numbering (UX-NNN vs ADR-NNN)
- Patterns are tree-agnostic — `patterns/good/` and `patterns/bad/` hold any subject (code, schema, UI). The header comment links to ADRs and/or UX decisions, whichever apply.

### Reference style in code

```tsx
// UX-002: Destructive actions require confirmation modal
<ConfirmDialog ... />

// ADR-007: Use Tanstack Query for server state
const { data } = useQuery(...)
```
```

## After Display

Offer contextual suggestions based on the topic:

- General → "Run `/blueprint:status` to see what's documented in this project"
- Commands → "Try `/blueprint:help workflow` for the recommended development process"
- Workflow → "Start with `/blueprint:onboard` if you haven't set up Blueprint yet"
- Specs → "Run `/blueprint:require [description]` to add a requirement"
- ADRs → "Run `/blueprint:list-adrs` to see existing decisions"
- Patterns → "Run `/blueprint:good-pattern [file]` to capture an example"
- Design → "Run `/blueprint:decide` to record a UX decision (it triages tech vs UX)"
