---
name: blueprint:onboard-design
description: Opt-in. Add the design/UX tree to a Blueprint repo. Interviews the user, ingests external artifacts (Figma, Storybook, design docs), and seeds UX decisions. Run again any time to refine.
argument-hint: ""
disable-model-invocation: true
allowed-tools:
  - Glob
  - Grep
  - Read
  - Write
  - Edit
  - Bash
  - AskUserQuestion
  - EnterPlanMode
  - ExitPlanMode
---

# Onboard Design Tree

**OPT-IN:** This skill is the only way the `design/` tree gets created. Other Blueprint skills do not auto-scaffold it. Run this when the repo has UX/design artifacts worth capturing.

**COMMAND:** Scaffold `design/` (UX decisions), record external design sources, and interview the user to seed initial content.

## DO NOT ASK FOR SCOPE

**DO NOT** ask "Would you like me to..." or offer numbered scope options. **DO** scaffold the design tree and walk the interview.

The user is allowed to skip any individual interview question — but never ask about whether to do it at all.

---

## Process

**FIRST ACTION: Enter plan mode by calling `EnterPlanMode`.**

### Step 1: Detect existing UI signals

Read in parallel (Glob/Grep):
- `package.json` / `pyproject.toml` / `Cargo.toml` — frontend frameworks (React, Vue, Svelte, SwiftUI, etc.)
- `src/components/`, `src/ui/`, `app/components/`, `packages/ui/`, `apps/*/src/components/` — component directories
- `**/*.{tsx,jsx,vue,svelte}` — UI source files (count, top dirs)
- `**/tailwind.config.*`, `**/theme.*`, `**/tokens.*`, `**/design-system*` — design system signals
- `**/.storybook/`, `**/storybook/` — Storybook setup

If no UI signals at all and the user hasn't insisted, ask once: *"This repo doesn't look like it has UI code. Set up the design tree anyway?"* (Skip if user invoked this skill explicitly with awareness — assume yes.)

### Step 2: Detect existing design tree

Check for:
- `design/ux-decisions/`

If any of these already exist, the skill is in **refine mode** — don't recreate, just fill gaps and add seeds based on the interview.

### Step 3: Show the plan

```
I will set up the design tree:

Scaffolding:
- design/ux-decisions/         (NNN-[slug].md, populated by /blueprint:decide)
- design/sources.md            (external design references)

Detected UI signals:
- Frontend: [framework]
- Component dirs: [paths]
- Design system: [tailwind | tokens | none]
- Storybook: [yes/no]

After scaffolding I will interview you about:
- External design tools (Figma, Sketch, Penpot, Storybook URLs, etc.)
- External documentation (design system docs, brand guidelines, research repos)
- Initial UX decisions to record (with rationale)

Skip any question with "skip" — TBD markers are fine.

[Call ExitPlanMode to proceed]
```

### Step 4: Exit plan mode and scaffold

Create directories and base files:
- `design/ux-decisions/.gitkeep`
- `design/sources.md` (template below)

### Step 5: Interview — External Sources

Use `AskUserQuestion`. Allow skip on every question. Batch up to 4 source types per call.

```json
{
  "questions": [{
    "question": "Which external design tools or docs should be referenced from the design tree?",
    "header": "External Sources",
    "options": [
      {"label": "Figma", "description": "Component library or working files"},
      {"label": "Storybook", "description": "Hosted component playground"},
      {"label": "Design system docs", "description": "Wiki, Notion, dedicated site"},
      {"label": "Brand guidelines", "description": "Visual language reference"},
      {"label": "User research", "description": "Interview notes, usability tests"},
      {"label": "Skip for now", "description": "Add later by editing design/sources.md"}
    ],
    "multiSelect": true
  }]
}
```

For each selected option, ask for the URL (plain text question allowed, since this is content, not scope). Record into `design/sources.md`.

### Step 6: Interview — Seed UX Decisions

```json
{
  "questions": [{
    "question": "Are there UX decisions the team has already made and should record?",
    "header": "UX Decisions",
    "options": [
      {"label": "Yes, list a few", "description": "I'll capture them as Draft UX decisions"},
      {"label": "Skip for now", "description": "Capture later with /blueprint:decide"}
    ],
    "multiSelect": false
  }]
}
```

If "Yes": ask for a short title and one-line rationale per decision. Create each as a Draft UX decision in `design/ux-decisions/NNN-[slug].md` using the template from `_templates/TEMPLATES.md` (`<!-- SECTION: ux-decision-template -->`). Use TBD markers for missing context/options/consequences.

### Step 7: Update CLAUDE.md / AGENTS.md

Detect the agent instructions file (same logic as `/blueprint:onboard` — check symlinks first). Add or update the design tree section so future agent sessions know the tree exists. Keep it brief; reference don't duplicate.

If a Documentation table exists in CLAUDE.md, add the design tree rows. If not, append a section.

### Step 8: Report

```
Design tree set up:
- design/ux-decisions/         [N seeds, M TBD]
- design/sources.md            [N external sources recorded]

Updated CLAUDE.md (or AGENTS.md) with design tree references.

Next steps:
- /blueprint:decide [topic]    Record a UX decision (now triages tech vs UX)

Run /blueprint:onboard-design again any time to add more seeds or sources.
```

---

## Templates

### design/sources.md

```markdown
# External Design Sources

External design assets and documentation referenced by this design system. Update when new sources are added or removed.

## Design Tools

| Source | URL | Purpose |
|--------|-----|---------|
<!-- TODO: Add Figma / Sketch / Penpot / etc. or remove this table -->

## Documentation

| Source | URL | Purpose |
|--------|-----|---------|
<!-- TODO: Add design system docs, brand guidelines, etc. -->

## Research

| Source | URL | Purpose |
|--------|-----|---------|
<!-- TODO: Add user research repos, usability test logs, etc. -->
```

### Other templates

| Artifact | Section in TEMPLATES.md |
|----------|-------------------------|
| UX decision (Draft) | `<!-- SECTION: ux-decision-template -->` |
| Tree separation rules | `<!-- SECTION: design-separation -->` |

---

## Idempotency

Running this skill again on a repo that already has `design/`:
- Does NOT recreate or overwrite existing files
- DOES add new sources to `design/sources.md`
- DOES create new seed UX decisions based on the interview
- DOES NOT delete TBD markers — those persist until the user fills them in

## Error Recovery

If creation partially fails (permission denied, etc.):
1. Report what was created and what wasn't
2. Don't roll back — partial structure is better than none
3. Suggest re-running the skill to fill the gaps
