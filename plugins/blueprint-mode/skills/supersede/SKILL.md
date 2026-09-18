---
name: supersede
description: Replace or deprecate an existing ADR or UX decision. Use when the user is changing a documented choice or retiring one.
argument-hint: "[ADR-NNN or UX-NNN]"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Supersede or Deprecate a Decision

Replacements stay in the same tree as the original: ADRs replace ADRs in `docs/adrs/`, UX decisions replace UX decisions in `design/ux-decisions/`. Formats: `../_templates/TEMPLATES.md` (relative to this skill's directory), sections `adr-template` and `ux-decision-template`.

## Steps

1. Find the decision. `ADR-NNN` searches `docs/adrs/`, `UX-NNN` searches `design/ux-decisions/`, a bare number searches both and asks if found in both. If nothing matches, say so and suggest `/blueprint-mode:decide`.
2. Determine intent from what the user said. "Switching to X" or "replace with X" is a replacement; "removing", "no longer needed" is a deprecation. Ask once, in the same message as any missing rationale, if unclear.
3. Replacement:
   - Create the new decision with the next number in the same tree. Its Context references the old decision; its Related section has `Supersedes: [ADR-OLD](./OLD-file.md)`. Add a `## Migration` section when the user gave migration notes.
   - Set the old file's frontmatter to `status: Superseded` and `superseded_by: NNN-new-slug`.
4. Deprecation:
   - Set frontmatter to `status: Deprecated`, `deprecated_date: [TODAY]`, `deprecated_reason: [reason]` (default "No longer needed"), and add a `> **Deprecated on [TODAY]:** [reason]` note under the title.
   - Locate code that implements the retired decision and list it in the report.
5. Search the repo for references to the old decision (`ADR-NNN`, `UX-NNN`, its filename, its extensionless stem), then discount the ones this skill just wrote or is about to remove: the old file's own title and frontmatter, and the replacement's Context and `Supersedes:` references to it. If nothing else refers to it, delete the old file, rewrite the Supersedes line as plain text (`Supersedes: ADR-OLD, deleted; see git history`), and say so. If code, specs, patterns, agent instructions, or another decision still refer to it, list those and keep the file.
6. If a retitle made a filename slug stale, rename the file and update references as the template describes.

## Output

```
Created ADR-NEW at docs/adrs/NEW-slug.md
ADR-OLD marked Superseded and deleted (no code references; git history keeps it)
```
