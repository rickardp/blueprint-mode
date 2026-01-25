---
name: blueprint:list-adrs
description: List all Architecture Decision Records with their status and summaries. Use when the user wants to see all decisions, review ADR history, or find a specific decision.
argument-hint: "[filter: active|superseded|deprecated|outdated|draft|keyword]"
allowed-tools:
  - Glob
  - Grep
  - Read
---

# List ADRs

Display all Architecture Decision Records with status and brief summaries.

**Invoked by:** `/blueprint:list-adrs` or when user asks "list decisions", "show ADRs", "what decisions exist?".

## Principles

1. **Use globbing**: Find ADRs via `docs/adrs/*.md`, no index file needed
2. **Parse frontmatter**: Extract status from each ADR file
3. **Efficient batching**: For large sets, show summary first

## Process

### Step 1: Find ADRs

**Tool Preferences:**
- **Glob tool**: Find ADR files with `docs/adrs/*.md`
- **Read tool**: Read individual ADR files for metadata

```
docs/adrs/*.md
```

**If no files found:**
```
No ADRs found.

Use `/blueprint:decide` to record your first architecture decision.
```

### Step 2: Parse Each ADR

For each ADR file, extract from frontmatter and content:

| Field | Source |
|-------|--------|
| Number | From filename (e.g., `001-postgres.md` → 001) |
| Title | From `# ADR-NNN: [Title]` heading |
| Date | From frontmatter `date:` |
| Status | From frontmatter `status:` (Active/Draft/Outdated/Superseded/Deprecated) |
| Summary | First sentence of "Decision" section (~60 chars) |
| Superseded by | From frontmatter `superseded_by:` |
| Deprecated reason | From frontmatter `deprecated_reason:` |
| Outdated reason | From frontmatter `outdated_reason:` |

### Step 3: Group by Status

Group ADRs into sections:
1. **Active** - Current decisions in effect
2. **Draft** - Decisions with incomplete documentation
3. **Outdated** - Decisions marked for replacement (TBD)
4. **Superseded** - Decisions replaced by newer ones
5. **Deprecated** - Decisions removed entirely

### Step 4: Display Tables

Sort by ADR number (newest first within each section).

```markdown
## Architecture Decision Records

### Active ([count])

| # | Title | Date | Summary |
|---|-------|------|---------|
| 006 | Use Zod for validation | 2025-01-20 | Schema validation with TypeScript inference |
| 005 | PostgreSQL for database | 2025-01-15 | ACID compliance, JSON support |

### Draft ([count])

| # | Title | Date | Missing |
|---|-------|------|---------|
| 007 | Use Redis for sessions | 2025-01-22 | Context, Rationale |

### Outdated ([count])

| # | Title | Marked | Replacement |
|---|-------|--------|-------------|
| 003 | Express framework | 2025-01-25 | TBD |

### Superseded ([count])

| # | Title | Superseded By |
|---|-------|---------------|
| 002 | ESLint + Prettier | ADR-004 |

### Deprecated ([count])

| # | Title | Date | Reason |
|---|-------|------|--------|
| 001 | Redis caching | 2025-01-25 | Caching removed |

---
View full ADR: `docs/adrs/NNN-title.md`
```

## Large ADR Sets (>20)

For projects with many ADRs:

1. **Show summary first:**
   ```
   Found 45 ADRs: 30 Active, 5 Draft, 3 Outdated, 5 Superseded, 2 Deprecated

   View: all | active | draft | outdated | superseded | deprecated | [search term]
   ```

2. **Load details on demand** - only read full ADR content when user requests specific section or search

## Empty Sections

Hide section headers if count is 0, but always show Active:

```markdown
### Active (0)

*No active decisions. Use `/blueprint:decide` to record one.*
```

## Filtering

If user asks for specific filter:

| Command | Action |
|---------|--------|
| `/blueprint:list-adrs active` | Show only Active |
| `/blueprint:list-adrs draft` | Show only Draft (incomplete) |
| `/blueprint:list-adrs outdated` | Show only Outdated (needs replacement) |
| `/blueprint:list-adrs database` | Search titles/content for "database" |

## After Display

Offer contextual actions based on what's shown:

- Draft ADRs exist → "Complete drafts with `/blueprint:decide [topic]`"
- Outdated ADRs exist → "Create replacements with `/blueprint:supersede [ADR]`"
- General → "Add decision: `/blueprint:decide [topic]`"

## Examples

- `/blueprint:list-adrs` → Full list grouped by status
- `/blueprint:list-adrs active` → Only active decisions
- `/blueprint:list-adrs draft` → Incomplete ADRs needing attention
- "What decisions need work?" → Show Draft and Outdated sections
- "Find ADRs about authentication" → Search filter
