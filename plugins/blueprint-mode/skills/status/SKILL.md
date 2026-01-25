---
name: blueprint:status
description: Show overview of project's Blueprint structure including specs, ADRs, and patterns. Use when the user asks about documented decisions, project status, or wants to see what's been captured.
argument-hint: "[focus: specs|adrs|patterns]"
---

# Blueprint Status

Display an overview of the project's spec-driven development structure.

**Invoked by:** `/blueprint:status` or when user asks "what's documented?", "show me the specs", or "blueprint status".

## Principles

1. **Parallel operations**: Batch file reads and globs for efficiency.
2. **Use globbing**: Discover ADRs via `docs/adrs/*.md`, no index needed.
3. **Graceful degradation**: Show what exists, suggest what's missing.

## Process

1. Check if Blueprint structure exists
2. Read and summarize all documented artifacts
3. Display formatted overview

**Tool Preferences:**
- **File finding**: Use Claude's Glob tool (not `find` or `ls`)
- **File reading**: Use Claude's Read tool (not `cat`)
- **Content search**: Use Claude's Grep tool for pattern counts

## Step 1: Check Structure Exists

Look for these directories:
- `docs/specs/`
- `docs/adrs/`
- `patterns/`

If none exist:
```
No Blueprint structure found.

Run `/blueprint:setup-repo` for a new project, or `/blueprint:onboard` for an existing codebase.
```

## Step 2: Gather Information

**Use parallel operations** to minimize latency. Gather all information in a single batch:

### Efficient Batch Approach

Run these checks in parallel (single glob + batch file reads):

```bash
# Single glob to find all relevant files
# Pattern: docs/specs/*.md, docs/adrs/*.md, patterns/good/*, patterns/bad/*.md, CLAUDE.md
```

**Glob patterns to check:**
- `docs/specs/{product,tech-stack,boundaries}.md` - Core spec files
- `docs/specs/features/*.md` - Feature specs (discovered via globbing)
- `docs/specs/non-functional/*.md` - NFR files (discovered via globbing)
- `docs/adrs/*.md` - All ADR files (discovered via globbing)
- `patterns/good/*` - Good pattern files (excluding .gitkeep)
- `patterns/bad/anti-patterns.md` - Anti-patterns file
- `CLAUDE.md` - Agent instructions

**In one batch read:**
1. Read each `docs/adrs/*.md` file - parse frontmatter for status (Active/Superseded/Deprecated/Outdated/Draft)
2. Read `patterns/bad/anti-patterns.md` - count `## ` headings
3. Read `CLAUDE.md` - check for "Pre-Edit Checklist" section

### Information to Extract

| Category | Check | Source |
|----------|-------|--------|
| Specs | product.md exists | glob |
| Specs | tech-stack.md exists | glob |
| Specs | boundaries.md exists | glob |
| Specs | Feature spec count | glob `docs/specs/features/*.md` |
| Specs | NFR file count | glob `docs/specs/non-functional/*.md` |
| ADRs | Active count | ADR files with `status: Active` |
| ADRs | Superseded count | ADR files with `status: Superseded` |
| ADRs | Deprecated count | ADR files with `status: Deprecated` |
| ADRs | Outdated count | ADR files with `status: Outdated` |
| ADRs | Draft count | ADR files with `status: Draft` |
| ADRs | Most recent | highest number in Active ADRs |
| Patterns | Good count | glob (exclude .gitkeep) |
| Patterns | Bad count | `## ` headings in anti-patterns.md |
| CLAUDE.md | Exists + has checklist | file check + "Pre-Edit Checklist" search |

## Step 3: Display Summary

```markdown
## Blueprint Status for [Project Name]

### Specs
- Product: docs/specs/product.md [exists ? "✓" : "✗ missing"]
- Tech Stack: docs/specs/tech-stack.md [exists ? "✓" : "✗ missing"]
- Boundaries: docs/specs/boundaries.md [exists ? "✓" : "✗ missing"]
- Features: [count] feature specs
- Non-Functional: [count] NFR files

### ADRs
- Active: [count]
- Draft: [count] (needs refinement)
- Outdated: [count] (replacement pending)
- Superseded: [count]
- Deprecated: [count]
- Recent: ADR-[NNN] "[title]" ([date])

### Patterns
- Good: [count] examples in patterns/good/
- Bad: [count] anti-patterns documented

### CLAUDE.md
[exists && hasChecklist ? "✓ Pre-Edit Checklist present" : "✗ Missing or incomplete"]
```

**Note:** ADRs are discovered via globbing `docs/adrs/*.md` and reading their frontmatter status field.

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
- No ADRs? → "Use `/blueprint:decide` to record your first decision"
- Draft ADRs? → "These ADRs need refinement: [list]. Run `/blueprint:decide [topic]` to complete them"

**Patterns:**
- No patterns? → "Use `/blueprint:good-pattern` to capture approved code"

**Structure:**
- No boundaries? → "Consider adding `docs/specs/boundaries.md` with `/blueprint:onboard`"

## Examples

- `/blueprint:status` → Full overview
- "What decisions have we documented?" → Status with focus on ADRs
- "Is this repo set up for Blueprint?" → Quick structure check
