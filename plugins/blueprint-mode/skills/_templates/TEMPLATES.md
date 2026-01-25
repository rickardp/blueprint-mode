# Shared Blueprint Templates

These templates are used by multiple skills. When creating files, use the appropriate template and fill in the placeholders.

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

## Never Do

### Security
- Commit secrets or credentials
- Disable authentication
- [Project-specific items]

### Code
- Commit with type errors
- [Project-specific items]

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

Use `/blueprint:list-adrs` to see all decisions grouped by status.

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

Running `/blueprint:decide` on an existing Draft ADR will prompt to fill in missing sections and upgrade status to Active.

---

<!-- SECTION: bad-patterns -->
## patterns/bad/anti-patterns.md

```markdown
# Anti-Patterns

Common mistakes to avoid in this codebase.

Use `/blueprint:bad-pattern [description]` to add anti-patterns.
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

## Tech Stack

- **Runtime**: [CHOICE]
- **Framework**: [CHOICE]
- **Database**: [CHOICE]

## CRITICAL: Pre-Edit Checklist

**BEFORE writing or editing ANY code, you MUST:**

1. **Check Feature Specs**
   - If implementing a documented feature, READ `docs/specs/features/[feature].md` FIRST
   - Look for `related_adrs` field - these ADRs MUST be followed
   - If no spec exists for a significant feature, ask: "Should I create a spec first with `/blueprint:require`?"

2. **Check Boundaries**
   - Read `docs/specs/boundaries.md` before ANY code changes
   - "Never Do" items are HARD BLOCKERS - refuse to proceed if violated
   - "Ask First" items require explicit user confirmation before proceeding

3. **Reference Patterns**
   - Check `patterns/good/` for examples of how to write this type of code
   - Check `patterns/bad/anti-patterns.md` to know what to avoid
   - Follow existing patterns in the codebase

4. **Traceability**
   - When implementing an ADR decision, add: `// ADR-NNN: [brief note]`
   - Keep comments brief - the ADR contains the full rationale

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

**Traceability**: Link code to decisions when relevant:
```typescript
// ADR-003: Using repository pattern for data access
// See: docs/adrs/003-repository-pattern.md
```

**Keep comments brief**: Document intent in specs, not inline prose.
- DO: `// ADR-007: Rate limiting per user`
- DON'T: Long explanations of why we chose this approach (put that in the ADR)

Only add comments when:
1. Tracing back to an ADR or spec
2. Explaining non-obvious behavior that can't be captured elsewhere
3. Warning about edge cases or gotchas

## Pattern Discovery

When the user corrects or discourages a code pattern during development:
- If they show a better way → Suggest: "Should I capture this as a good pattern? `/blueprint:good-pattern`"
- If they say "don't do X" → Suggest: "Should I document this as an anti-pattern? `/blueprint:bad-pattern`"

This captures lessons learned organically during development.

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
## Interview Standards

All skills with user interviews should follow these patterns for consistency.

### Core Principle: Low Friction

**Accept what users give, ask only for what's missing.**

Before asking any questions:
1. **Parse first:** Extract all information from input using the patterns above
2. **Skip answered:** Never ask for information already provided (even in different words)
3. **Batch questions:** Present remaining questions together, not one-at-a-time
4. **Show exit:** Every prompt must show how to proceed with partial info

### Batched Questions Format

**Present all remaining questions in a single categorized prompt:**

```markdown
"Recording [artifact] for [topic]. Quick questions (answer any, or 'create now'):

**Context:**
1. What problem does this solve?
2. What alternatives did you consider?

**Rationale:**
3. Why this choice?

_(Say 'create now' to proceed with what you've shared)_"
```

**Batching rules:**
- Group related questions under category headers (Context, Rationale, Details, etc.)
- Number all questions sequentially across categories
- Always end with the exit hint in italics
- Never ask questions one-at-a-time across multiple turns

### Exit Visibility

**Every prompt that asks questions MUST end with an explicit exit option:**

```markdown
_(Say 'create now' to proceed with what you've shared)_
```

**Accepted exit phrases** (all equivalent):
- "create now", "proceed", "continue", "done", "that's enough"
- "just do it", "skip", "later", "create", "go ahead"

**Format by prompt type:**
- Multi-question: `_(Say 'create now' to proceed with what you've shared)_`
- Single question: `"Why this choice? [skip to proceed]"`
- Confirmation: `"Proceed? [yes / change something]"`

### Handling "Later" Responses

When user says "I'll add this later", "not sure", "skip this", or similar:
- Create the artifact with `<!-- TODO: ... -->` markers for missing sections
- Use `status: Draft` for ADRs with incomplete sections
- Inform user: "Created with TODO markers. Run the command again to refine."

**TODO markers are the source of truth** for what's missing - no need to track in frontmatter.

### Completion Criteria

**For full interviews (5+ questions):**

```markdown
### Interview Completion

Continue asking questions until:
- You are confident the user's intent is fully captured, OR
- The user explicitly says "done", "that's all", "I'll add more later", or similar, OR
- You've completed the structured questions above

**If user wants to proceed with partial info, create with TODO markers.**
```

**For short interviews (2-3 questions):**

```markdown
Ask for missing info. If user says "I'll add this later", proceed with TODO markers.
```

**For minimal interviews (1 question):**

```markdown
Proceed once the user answers or indicates they'll add details later.
```

### Confirmation Before Action

**For additive actions (new ADR, new pattern, new requirement):**
Skip confirmation. User invoking the skill = intent to create.

**For destructive/complex actions (supersede, deprecate, delete):**
Summarize and confirm.

**For confirmations with clear choices, use AskUserQuestion:**

See `<!-- SECTION: interactive-questions -->` for tool format and guidelines.

**For open-ended follow-up after confirmation, use plain text:**

```markdown
"What needs to change?"
```

### Preview Before Create (Inferred Values)

When creating artifacts with inferred or default values, show what will be created:

```markdown
"Creating with:
- Name: TaskAPI ← provided
- Runtime: Node.js ← provided
- Framework: Express ← inferred (Node default)
- Testing: Vitest ← inferred (Node default)

Proceed? [yes / change something]"
```

**When to preview:**
- `setup-repo`: Always (many inferences possible)
- `decide`: Only if rationale was inferred from shorthand ("team knows")
- `require`: Only if type (FR/NFR) was auto-detected
- Other skills: When 2+ values were inferred or defaulted

**Skip preview when:**
- User said "just create" / "proceed" during questions
- All values were explicitly provided
- Only 1 simple default applied

### After Action Section

Use consistent verbs for post-action communication:

```markdown
## After Creation

1. Confirm: "[Artifact] created at [path]"
2. Inform: "[Relevant context about the artifact]"
3. Suggest: "[Related actions user might want to take]"
4. Remind: "PR merge = approved"
```

**Verb meanings:**
- `Confirm:` - State what was done
- `Inform:` - Provide additional context
- `Suggest:` - Offer next actions
- `Remind:` - Important policies or workflow notes

### Error Recovery

If user indicates a mistake after creation ("wait, that was wrong", "I need to change that"):

```markdown
## Error Recovery

1. Acknowledge: "I can update or remove the [artifact]"
2. Clarify: "What needs to change?"
3. Execute: Update or delete as needed
4. Confirm: "[Artifact] has been [updated/removed]"
```

**Guidelines:**
- Never require the user to manually fix skill-created artifacts
- Offer both edit and delete options when appropriate
- For ADRs: updating is preferred over deleting (preserves history)
- For patterns: simple replacement is fine

---

<!-- SECTION: interactive-questions -->
## Interactive Question Standards

**CRITICAL: You MUST invoke the `AskUserQuestion` tool - do NOT output questions as plain text.**

When this documentation shows JSON examples, they are parameters for the AskUserQuestion tool. You must actually call the tool, not print the JSON or rephrase it as text.

**Wrong:** Outputting "Would you like to: 1) Option A 2) Option B"
**Right:** Invoking AskUserQuestion tool with the options as parameters

### When to Use AskUserQuestion vs Plain Text

| Scenario | Use AskUserQuestion | Keep Plain Text |
|----------|---------------------|-----------------|
| Binary confirmation (yes/no) | Yes | - |
| 2-4 discrete choices | Yes | - |
| Multi-select from options | Yes | - |
| Open-ended rationale/context | - | Yes |
| File paths or descriptions | - | Yes |
| Freeform answers | - | Yes |

**Rationale:** Use structured UI when it reduces cognitive load, but avoid forcing users into predefined boxes when they need to express nuanced information.

### AskUserQuestion Format

```json
{
  "questions": [{
    "question": "Clear question text ending with ?",
    "header": "ShortHdr",
    "options": [
      {"label": "Option 1", "description": "When to choose this"},
      {"label": "Option 2", "description": "When to choose this"}
    ],
    "multiSelect": false
  }]
}
```

**Constraints:**
- `header`: Max 12 characters
- `options`: 2-4 options per question
- `multiSelect`: Set `true` when choices aren't mutually exclusive
- Users can always select "Other" to provide custom text

### Header Guidelines

Keep headers under 12 characters:
- `Confirm` (7) - for confirmations
- `Action` (6) - for choosing what to do
- `Select` (6) - for picking from options
- `Create` (6) - for creation confirmations
- `File` (4) - for file selection

### Option Design

- **Label**: Short, actionable (1-3 words)
- **Description**: Explains when/why to choose this option
- First option should be the most common/recommended choice

### Response Handling

After using AskUserQuestion:

```markdown
**Response handling:**
- "[Option 1 label]" → [What to do]
- "[Option 2 label]" → [What to do]
- "Other" → Treat their text as if question was asked in plain text
```

**Always handle "Other"**: Users can provide custom text. Parse it for intent signals and continue the flow accordingly.

### When to Skip AskUserQuestion

Skip structured questions if:
- User already said "create now" / "proceed" / "just do it"
- Intent was clearly expressed in initial input
- Only 1 simple default applies

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
