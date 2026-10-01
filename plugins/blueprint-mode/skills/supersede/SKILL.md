---
name: supersede
description: Rewrite or retire an existing ADR or UX decision. Use when the user changes a documented choice, asks for an explicit replacement record, or retires a decision.
allowed-tools: Read, Glob, Grep, Write, Edit, Bash
---

# Change or Retire a Decision

Rewrite an existing decision in place when its choice changes; git preserves the previous choice. Formats and cleanup: `../_templates/TEMPLATES.md` (relative to this skill's directory), sections `adr-reading`, `adr-template`, `ux-decision-template`, and `decision-lifecycle`.

## Steps

1. Find the decision. `ADR-NNN` searches `docs/adrs/`, `UX-NNN` searches `design/ux-decisions/`, a bare number searches both and asks if found in both. If nothing matches, say so and suggest recording a decision and its rationale.
2. Read the full existing decision, including rationale. For ADRs, use `adr-reading` to assess the requested choice, scope, and constraints. Determine intent from the request: "switch to X" or "replace with X" changes the existing decision; it does not request a new numbered record. An independent decision uses `decide` and leaves this decision intact. Ask once for unresolved intent or rationale that cannot be found; use Draft TODOs when missing rationale is skipped.
3. For a changed choice or clarification, rewrite the same decision using its complete template and keep its number. Update Decision and rationale to the new intent, carry forward constraints that still apply, and remove obsolete guidance. Note the previously used option and why it changed under Options Considered, as the template describes. Use the settled/Draft status rules; do not mark the previous contents Superseded or create a successor. If the title changes, rename the slug and update incoming references as the template describes. Report and stop.
4. Only when the user explicitly requests a separate replacement record, create it in the same tree with a new unused number and clean up the old record per `decision-lifecycle`. For retirement without replacement, apply that same cleanup and list code still implementing the retired decision. Check archival safety before editing or deleting old contents.
5. Search and classify references per `decision-lifecycle`, including predecessors in an affected supersession chain. Update current guidance to the applicable Active decision and historical references to git history; historical links do not justify retention. Clean up obsolete predecessors reached through that chain.
6. For each retained file, report its concrete migration dependency or unarchived content and what will allow deletion. Do not commit merely to enable deletion.

## Output

```
Updated ADR-NNN at docs/adrs/NNN-slug.md (same number; git preserves the previous choice)
Deleted ADR-OLD (retired); historical references use git history
```
