---
name: list-adrs
description: List Architecture Decision Records grouped by status. Use when the user wants to see, filter, or search the ADRs.
allowed-tools: Read, Glob, Grep
---

# List ADRs

Use `../_templates/TEMPLATES.md`, sections `adr-reading` and `decision-lifecycle`, for discovery, reading depth, and retirement rules.

## Steps

1. Glob `docs/adrs/*.md`. If empty, say so and suggest recording a decision and its rationale.
2. From each file read the number and slug from the filename, the title from the `# ADR-NNN:` heading, `status`, `date`, `superseded_by`, and `deprecated_reason` from frontmatter, and the choice and applicability from Decision. Use bounded prefix reads per `adr-reading`, stopping before Context; report legacy applicability as unspecified rather than inferring scope from the title. Link each title to its ADR; summaries support selection, not implementation.
3. Apply the filter: a status word keeps that status; any other word searches titles and content.
4. Group by status (Active, Draft, Superseded, Deprecated), newest first within a group. Hide empty groups except Active. For more than 20 ADRs, show counts first and details for the requested group.

## Output

```markdown
## Architecture Decision Records

### Active (N)
| # | Title | Date | Choice | Applies to |
|---|-------|------|--------|------------|

### Draft (N)
| # | Title | Date | Applies to | Missing |
|---|-------|------|------------|---------|

### Superseded (N)
| # | Title | Superseded By |
|---|-------|---------------|

### Deprecated (N)
| # | Title | Date | Reason |
|---|-------|------|--------|
```

Mention Draft ADRs that need completion and obsolete records needing lifecycle cleanup. Superseded and Deprecated groups show temporary retained files, not a historical archive; historical links alone do not justify retention.
