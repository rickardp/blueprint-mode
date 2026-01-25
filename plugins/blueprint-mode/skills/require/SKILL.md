---
name: blueprint:require
description: Add a functional or non-functional requirement. Use when the user wants to document a new feature requirement, acceptance criteria, performance target, or quality standard.
argument-hint: "[requirement-description]"
---

# Add Requirement

Add a functional (FR) or non-functional (NFR) requirement to the specs.

**Invoked by:** `/blueprint:require [description]` or automatically when discussing requirements.

## Principles

1. **Ask questions, allow skip**: Gather details, but never block on missing info.
2. **Auto-scaffold**: Create structure if it doesn't exist.
3. **Module path optional**: Use TBD for planned features without known location.
4. **Capture now, refine later**: TODO markers for missing sections.

## Process

### Step 1: Parse User Input

**Before asking ANY questions, extract ALL information and auto-detect type.**

Use the parsing rules from `_templates/TEMPLATES.md` (Flexible Information Gathering section).

**Auto-detect FR vs NFR:**

| Signals | Type |
|---------|------|
| User actions, features, "can", "should be able to" | FR (Functional) |
| Metrics, latency, "P95", "P99", uptime, "under Xms" | NFR (Non-Functional) |
| Security requirements, encryption, auth | NFR (Security) |
| Ambiguous | Default to FR (more common) |

| Input | Extracts | Type |
|-------|----------|------|
| `/blueprint:require Users can reset password via email` | User story | FR |
| `/blueprint:require API response under 100ms P95` | Metric + target | NFR (Performance) |
| `/blueprint:require Add dark mode` | Feature name | FR |
| `/blueprint:require 99.9% uptime` | Metric + target | NFR (Availability) |

### Step 2: Auto-Scaffold (If Needed)

**Tool Preferences:**
- Use Claude's Read tool to view existing spec files
- Use Claude's Glob tool to find spec files
- Use Claude's Write tool to create new files

Check if `docs/specs/` exists.

**If it doesn't exist:**
1. Create `docs/specs/`, `docs/specs/features/`, and `docs/specs/non-functional/` directories
2. Inform: "Created Blueprint specs structure. Run `/blueprint:onboard` to add full project context."
3. Continue with recording the requirement

### Step 3: Gather Missing Information (Single Batch)

**Present all remaining questions based on detected type.**

#### For Functional Requirements:

```
"Adding feature requirement: [description]. Quick details (answer any, or 'add now'):

1. Feature name? [if not obvious from description]
2. User story? (As a [user], I want [X] so that [Y])
3. Module location? (e.g., src/auth/) [default: TBD]

_(Say 'add now' to create with what you've shared)_"
```

#### For Non-Functional Requirements:

```
"Adding non-functional requirement: [description]. Quick details (answer any, or 'add now'):

1. Category? (Performance/Security/Scalability/Availability) [auto-detected: X]
2. How to measure this?
3. Target threshold?

_(Say 'add now' to create with what you've shared)_"
```

**If user exits early or skips:**
- Mark missing sections with `<!-- TODO: ... -->`
- Create requirement with what was provided
- Inform: "Requirement added. Edit the file to add missing details."

### Step 4: Add to Spec File

**Functional Requirements:**
- New feature → Create `docs/specs/features/[feature-name].md`
- Existing feature → Append to existing feature spec

**Non-Functional Requirements:**
- Add to `docs/specs/non-functional/[category].md` (create if doesn't exist)
- Categories: `performance.md`, `security.md`, `scalability.md`, `reliability.md`

## Functional Requirement Template

See `_templates/TEMPLATES.md` (section: `<!-- SECTION: feature-specs -->`) for the base template.

**For new features**, create `docs/specs/features/[feature-name].md`:

```markdown
---
status: Planned
module: TBD
related_adrs: []
---

# [Feature Name]

## Overview
[1-2 sentence description]

## User Stories
- As a [user type], I want [capability] so that [benefit]
<!-- TODO: Add user story if skipped -->

## Requirements
[High-level requirements]

## Acceptance Criteria
<!-- Add when ready for implementation -->
```

**For existing features**, append:

```markdown
## Additional Requirement: [Short Title]

**As a** [user type]
**I want** [capability]
**So that** [benefit]

### Notes
- Affects: [components or TBD]
- Dependencies: [any blockers or TBD]
```

## Non-Functional Requirement Template

Add to `docs/specs/non-functional/[category].md` (create from template if doesn't exist).

**NFR file per category** (e.g., `docs/specs/non-functional/performance.md`):

```markdown
---
category: Performance
---

# Performance Requirements

| Metric | Target | Measured At |
|--------|--------|-------------|
| [metric name] | [target value] | [location] |

## [Specific Requirement Title]

**Requirement:** [Measurable statement]
**Metric:** [How to measure]
<!-- TODO: Add metric if skipped -->
**Target:** [Specific threshold]
<!-- TODO: Add target if skipped -->

### Rationale
[Why this matters - optional]
```

**NFRs are discovered via globbing** `docs/specs/non-functional/*.md` - one file per category.

## NFR Categories

- **Performance** - Latency, throughput, response time
- **Availability** - Uptime, recovery time, failover
- **Security** - Authentication, encryption, audit
- **Scalability** - Users, data volume, concurrent connections
- **Maintainability** - Code quality, documentation, testing

## Examples

**Full input (FR):**
```
User: /blueprint:require Users can reset their password via email - send link valid for 1 hour
Assistant: [Auto-detects FR, creates feature spec immediately with user story extracted]
```

**Batched questions (FR):**
```
User: /blueprint:require Dark mode
Assistant: "Adding feature requirement: Dark mode. Quick details (answer any, or 'add now'):

1. User story? (As a [user], I want [X] so that [Y])
2. Module location? [default: TBD]

_(Say 'add now' to create with what you've shared)_"

User: Users want to reduce eye strain, add now
Assistant: [Creates feature spec with user story, module as TBD]
```

**Auto-detected NFR:**
```
User: /blueprint:require API latency under 100ms P95
Assistant: [Auto-detects NFR (Performance), creates docs/specs/non-functional/performance.md with metric and target extracted]
```

## After Creation

1. Confirm: "Requirement added to `[file path]`"
2. If TODOs exist: "Missing: [list]. Edit the file or run `/blueprint:require` to add details."
3. Suggest related actions:
   - `/blueprint:decide` - If this implies a tech decision
   - `/blueprint:require` - Add related requirements

## Error Recovery

If user indicates a mistake after creation:
1. Acknowledge: "I can update or remove the requirement"
2. Clarify: "What needs to change?"
3. Execute: Update or delete as needed
4. Confirm: "Requirement has been [updated/removed]"
