---
name: blueprint:status
description: Show overview of project's Blueprint structure plus important adjacent DESIGN.md context. Use when the user asks about documented decisions, project status, or wants to see what's been captured.
argument-hint: "[focus: specs|adrs|patterns|design]"
allowed-tools:
  - Glob
  - Grep
  - Read
---

# Blueprint Status

Display an overview of the project's Blueprint intent-capture structure.

**Invoked by:** `/blueprint:status` or when user asks "what's documented?", "show me the specs", or "blueprint status".

## Principles

1. **Parallel operations**: Batch file reads and globs for efficiency.
2. **Use globbing**: Discover ADRs via `docs/adrs/*.md`, no index needed.
3. **Graceful degradation**: Show what exists, suggest what's missing.

## Process

1. Check if Blueprint structure exists, and separately whether `DESIGN.md` exists
2. Read and summarize all documented artifacts
3. Display formatted overview

**Tool Preferences:**
- **File finding**: Use Claude's Glob tool (not `find` or `ls`)
- **File reading**: Use Claude's Read tool (not `cat`)
- **Content search**: Use Claude's Grep tool for pattern counts

## Step 1: Check Structure Exists

Look for these paths across the Blueprint trees and adjacent design context:

**Code / architecture tree:**
- `docs/specs/`
- `docs/adrs/`
- `patterns/`

**Important adjacent design context:**
- `DESIGN.md` (not part of the Blueprint structure)

**Design / UX tree:**
- `design/ux-decisions/`

If none of these paths exist:
```
No Blueprint structure found.

Run `/blueprint:setup-repo` for a new project, or `/blueprint:onboard` for an existing codebase.
```

Both trees are optional independently — a backend-only repo may have no `design/` tree, and a design-system repo may have no `docs/adrs/`. `DESIGN.md` is reported separately as important adjacent design context. Show only the sections that exist.

## Step 2: Gather Information

**Use parallel operations** to minimize latency. Gather all information in a single batch:

### Efficient Batch Approach

Run these checks in parallel (single glob + batch file reads):

```bash
# Single glob to find all relevant files
# Pattern: DESIGN.md, docs/specs/*.md, docs/adrs/*.md, patterns/good/*, patterns/bad/*.md, CLAUDE.md
```

**Glob patterns to check:**

Code / architecture tree:
- `docs/specs/{product,tech-stack,boundaries}.md` - Core spec files
- `docs/specs/features/*.md` - Feature specs (discovered via globbing)
- `docs/specs/non-functional/*.md` - NFR files (discovered via globbing)
- `docs/adrs/*.md` - All ADR files (discovered via globbing)
- `patterns/good/*` - Good code pattern files (excluding .gitkeep)
- `patterns/bad/anti-patterns.md` - Code anti-patterns file

Important adjacent design context:
- `DESIGN.md` - top-level design context (cross-cutting UI rules/prohibitions), not part of the Blueprint structure

Design / UX tree:
- `design/ux-decisions/*.md` - UX decisions (discovered via globbing)

Other:
- `CLAUDE.md` - Agent instructions

**In one batch read:**
1. Read each `docs/adrs/*.md` file - parse frontmatter for status
2. Read `DESIGN.md` if present - count non-placeholder bullets/headings
3. Read each `design/ux-decisions/*.md` file - parse frontmatter for status
4. Read both anti-patterns files - count `## ` headings
5. Read `CLAUDE.md` - check for "Pre-Edit Checklist" section

### Information to Extract

| Category | Check | Source |
|----------|-------|--------|
| Specs | product.md exists | glob |
| Specs | tech-stack.md exists | glob |
| Specs | boundaries.md exists | glob |
| Specs | Feature spec count | glob `docs/specs/features/*.md` |
| Specs | NFR file count | glob `docs/specs/non-functional/*.md` |
| ADRs | Active/Draft/Superseded/Deprecated counts | frontmatter status |
| ADRs | Most recent | highest number in Active ADRs |
| Patterns | Good count | glob `patterns/good/*` (exclude .gitkeep) |
| Patterns | Bad count | `## ` headings in `patterns/bad/anti-patterns.md` |
| DESIGN.md | Exists + non-placeholder rules | file check + content scan |
| UX decisions | Active/Draft/Superseded/Deprecated counts | frontmatter status |
| UX decisions | Most recent | highest number in Active UX decisions |
| CLAUDE.md | Exists + has checklist | file check + "Pre-Edit Checklist" search |

## Step 3: Display Summary

Show the design section if `DESIGN.md` or `design/` exists. Show the code tree section only if `docs/` or `patterns/` exists.

```markdown
## Blueprint Status for [Project Name]

## Code / Architecture Tree

### Specs
- Product: docs/specs/product.md [exists ? "✓" : "✗ missing"]
- Tech Stack: docs/specs/tech-stack.md [exists ? "✓" : "✗ missing"]
- Boundaries: docs/specs/boundaries.md [exists ? "✓" : "✗ missing"]
- Features: [count] feature specs
- Non-Functional: [count] NFR files

### ADRs
- Active: [count]
- Draft: [count] (needs refinement)
- Superseded: [count] (consider deleting if no code references)
- Deprecated: [count] (consider deleting if no code references)
- Recent: ADR-[NNN] "[title]" ([date])

### Patterns
- Good: [count] examples in patterns/good/
- Bad: [count] anti-patterns in patterns/bad/anti-patterns.md

## Design / UX Tree

### Design Context
- DESIGN.md: [exists ? "✓ N rules/headings" : "✗ missing"]

### UX Decisions
- Active: [count]
- Draft: [count] (needs refinement)
- Superseded: [count]
- Deprecated: [count]
- Recent: UX-[NNN] "[title]" ([date])

## CLAUDE.md
[exists && hasChecklist ? "✓ Pre-Edit Checklist present" : "✗ Missing or incomplete"]
```

**Note:** All artifacts are discovered via globbing — no index files are required. ADRs and UX decisions are numbered independently and never share files.

## Minimal Output (if structure is sparse)

If only partial structure exists:

```markdown
## Blueprint Status

### Found
- docs/adrs/ (2 ADRs)

### Missing
- docs/specs/ - Run `/blueprint:onboard` to create
- patterns/ - Run `/blueprint:good-pattern` to add examples
- CLAUDE.md Documentation section

Run `/blueprint:onboard` to complete the setup.
```

## After Display

Offer helpful next actions based on what's missing or incomplete:

**Onboarding:**
- Partial onboarding? → "Run `/blueprint:onboard` to continue. Pending: [list pending sections]"
- No onboarding tracking? → "Run `/blueprint:onboard` to set up incremental tracking"

**ADRs:**
- No ADRs? → "Use `/blueprint:decide` to record your first architectural decision"
- Draft ADRs? → "These ADRs need refinement: [list]. Run `/blueprint:decide [topic]` to complete them"

**UX decisions:**
- No DESIGN.md but design tree exists? → "Use `/blueprint:onboard-design` to scaffold DESIGN.md when you want cross-cutting design rules"
- No UX decisions but design tree exists? → "Use `/blueprint:decide` (it triages — UX inputs land in `design/ux-decisions/`)"
- Draft UX decisions? → "These UX decisions need refinement: [list]"

**Patterns:**
- No patterns? → "Use `/blueprint:good-pattern` to capture an approved example (any subject)"

**Structure:**
- No boundaries? → "Consider adding `docs/specs/boundaries.md` with `/blueprint:onboard`"

## Examples

- `/blueprint:status` → Full overview
- "What decisions have we documented?" → Status with focus on ADRs
- "Is this repo set up for Blueprint?" → Quick structure check
