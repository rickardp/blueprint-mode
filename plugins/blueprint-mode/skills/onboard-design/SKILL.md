---
name: blueprint:onboard-design
description: Opt-in. Add design intent capture to a Blueprint repo. Scaffolds design/ux-decisions/ and design/sources.md, records external artifact URLs (Figma, Storybook, design docs), offers to scaffold a minimal community-format DESIGN.md if absent, and surfaces a small number of candidate UX decisions found in existing UI/code for the user or designer to confirm.
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

**COMMAND:** Scaffold `design/ux-decisions/` and `design/sources.md`, record external design source URLs (Figma, Storybook, etc.), and surface a small number of candidate UX decisions found in existing UI/code for the user or designer to confirm. Capture only the ones they confirm as deliberate. Skipping is always fine.

**Capture intent, not inferred structure.** The point of a UX decision is to record a *conscious* choice the user or designer made. Surface candidates the agent can point to in code/UI (a confirmation modal, a destructive-action pattern, a recurring layout) so the human has something concrete to react to — but only capture the choice if they articulate the *why*. If the rationale is "the code happens to look like that," the decision isn't ready and the agent should not invent one.

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
- `DESIGN.md` at repo root — top-level design context (Google Stitch / awesome-design-md style)

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
- DESIGN.md at repo root: [yes/no]

After scaffolding I will interview you about:
- External design tools (Figma, Sketch, Penpot, Storybook URLs, etc.)
- External documentation (design system docs, brand guidelines, research repos)
- Whether to scaffold a minimal `DESIGN.md` at the repo root for cross-cutting design context (skipped if it already exists)
- A small number of UI patterns I found in the code, so you can tell me which were deliberate choices (with a short reason) and which were coincidental

The goal is to capture *conscious* design decisions — the why behind the
choice. If a pattern is in the code but you don't have a clear reason for
it, that's fine: we leave it as implementation, not as a UX decision.

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

### Step 5b: Top-level `DESIGN.md`

`DESIGN.md` is a community convention (Google Stitch / awesome-design-md), not a Blueprint-owned format and not part of the Blueprint structure. Blueprint stays compatible with it: respects existing files, can scaffold a minimal stub, and avoids duplicating information that belongs there.

If `DESIGN.md` already exists at the repo root: do NOT modify it. Note the file in `design/sources.md` so it's discoverable, and ensure the agent-instructions update in Step 7 includes "read DESIGN.md on UI work."

If `DESIGN.md` does not exist, ask once via `AskUserQuestion`:

```
Scaffold a minimal DESIGN.md at the repo root?

DESIGN.md is a community convention (Google Stitch / awesome-design-md)
for cross-cutting design context — visual rules, voice/tone, prohibitions
("never use more than 3 colours on a screen"). Agents read it on every UI
generation task. Blueprint just stays compatible with it; you own the
file's contents.

I'd write a small stub following the community format. Rules are added
later, conversationally, as decisions accumulate — never hand-filled.

Options: Scaffold / Skip
```

If the user accepts, write a minimal stub that follows the community format:

```markdown
# Design

Top-level design context for this project. Agents read this on every UI generation task. Keep it short; cross-cutting rules and prohibitions only.

## Visual rules

<!-- e.g. token usage, colour limits, type scale. Empty until rules accumulate. -->

## Voice and tone

<!-- e.g. imperative CTAs, no jargon. Empty until rules accumulate. -->

## Prohibitions

<!-- e.g. "Never use more than 3 colours on a screen." Empty until rules accumulate. -->
```

**Do not interview the user to fill these sections.** Leave the placeholders empty. Rules are added later, conversationally, when actual decisions are made.

**Delineation reminder for the agent:** cross-cutting rules go in `DESIGN.md`; per-decision rationale (one choice + alternatives) goes in `design/ux-decisions/`. UX decisions reference `DESIGN.md` rules rather than restating them.

### Step 6: Day-One Design Intent Triage (candidate-driven)

Scan the detected UI for **a small number** of high-confidence candidate UX choices the agent can point to in code. Cap the candidate list at five — fewer is fine. Look for evidence-bearing patterns such as:

- Confirmation / destructive-action treatment (modal vs inline, copy patterns)
- Empty / error / loading state shape (consistent across screens?)
- Repeated card or list layout used in core flows
- Navigation model (tabs vs stack vs drawer)
- Copy/voice conventions (e.g. all CTAs use imperative verbs)

For each candidate, prepare a one-line description that names the file or component the agent observed it in.

Then ask the user/designer once, batched via `AskUserQuestion`:

```
I found these candidate UX choices in the existing UI. For each one:
mark it as deliberate (with a short reason) or skip.

1. [observed pattern] — seen in [file:line or component]
2. ...
```

For each item the user marks deliberate **with a short rationale**:
- Create a Draft UX decision in `design/ux-decisions/` (Draft because the rationale will usually be terse on day one)
- Title from the user's framing, not the agent's
- Reference the observed file or component in the decision's `Context` or `Related` section

For each item the user skips, marks "not deliberate", or provides no rationale for: create nothing. Coincidental UI is the default; UX decisions exist only for confirmed intent.

**Stay in intent-capture mode:**
- Keep the candidate list small (≤5) — this is triage, not an audit of the codebase.
- If the user can't articulate the *why* for a candidate, don't capture it. Blueprint records conscious decisions; coincidental code is not intent.
- Don't infer rationale from how the code currently looks. The fact that a pattern exists in code is not evidence it was a deliberate choice.

### Step 7: Update CLAUDE.md / AGENTS.md

Detect the agent instructions file (same logic as `/blueprint:onboard` — check symlinks first). Add or update the design tree section so future agent sessions know the tree exists. Keep it brief; reference don't duplicate.

If a Documentation table exists in CLAUDE.md, add the design tree rows. If not, append a section.

If `DESIGN.md` exists (or was just scaffolded), add a line to the pre-edit checklist for UI work: "Read `DESIGN.md` for cross-cutting design rules and prohibitions." This is what makes the file load-bearing — the doc says it should be consulted on every UI generation task.

### Step 8: Report

```
Design tree set up:
- design/ux-decisions/         [N confirmed UX decisions, or "empty — populate with /blueprint:decide"]
- design/sources.md            [N external sources recorded]
- DESIGN.md (repo root)        [pre-existing | scaffolded stub | skipped]

Day-one triage: [N candidates surfaced, M confirmed as deliberate, rest skipped]

Updated CLAUDE.md (or AGENTS.md) with design tree references [and DESIGN.md read instruction for UI work].

Next steps:
- /blueprint:decide [topic]    Record a UX decision (skill triages tech vs UX)
- Edit DESIGN.md conversationally as cross-cutting rules accumulate (or via /blueprint:decide)

Run /blueprint:onboard-design again any time to add more sources to design/sources.md.
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
- Does NOT recreate or overwrite existing files (including `DESIGN.md` if it already exists)
- DOES add new sources to `design/sources.md`
- DOES NOT modify existing UX decisions; it may create new Draft UX decisions only from freshly confirmed triage candidates
- MAY surface fresh day-one triage candidates if new UI areas have appeared since the last run, but never re-asks about UI already covered by an existing UX decision
- MAY offer to scaffold `DESIGN.md` if it still doesn't exist and the user previously skipped

## Error Recovery

If creation partially fails (permission denied, etc.):
1. Report what was created and what wasn't
2. Don't roll back — partial structure is better than none
3. Suggest re-running the skill to fill the gaps
