---
name: onboard-design
description: Opt in to design intent capture by scaffolding design/ux-decisions, optionally a DESIGN.md stub, and optionally reviewing a few existing UI patterns for stated intent. Safe to rerun.
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash
---

# Onboard Design Tree

This is the only skill that creates `design/`. Its purpose is to record conscious UX choices a person can explain. Existing code is a prompt for that conversation, not evidence of intent. Formats are in `../_templates/TEMPLATES.md` (relative to this skill's directory): `ux-decision-template`, `design-separation`, `agent-file-detection`, `agent-instructions`.

## Steps

1. Detect UI signals: frontend frameworks in manifests, component directories, `*.tsx|jsx|vue|svelte` files, design tokens or Tailwind config, Storybook, and an existing `DESIGN.md`.
2. Create `design/ux-decisions/.gitkeep`. If the directory already exists, keep everything in it and only fill gaps.
3. Put every question in one message: whether to proceed if no UI signals were found; whether to scaffold a minimal `DESIGN.md` stub if it is absent (an existing file is left untouched); and whether to review up to five existing UI patterns now.
4. If the stub was accepted, write the community-format stub below with empty sections; do not interview the user to fill them. Rules accumulate later through `/blueprint-mode:decide` and `/blueprint-mode:capture`.
5. If the review was accepted, pick high-confidence candidates (destructive-action confirmation, empty and error states, repeated layout, navigation model, copy conventions), each tied to a file, and ask in one batch which were deliberate and why. Create a Draft UX decision only for those given a reason, titled in the user's words and referencing the observed file. Create nothing for the rest.
6. Update the agent instructions file per `agent-file-detection`. Add the `design/ux-decisions/` line from the `agent-instructions` template to its "Where intent lives" list, and the `DESIGN.md` line only when that file exists, whether pre-existing or scaffolded in step 4. Never add a line pointing at a file the user declined. If the file has no such list, it predates 2.0: regenerate the Blueprint section as `/blueprint-mode:onboard` does, then add the lines that apply.
7. Rerunning never overwrites existing files or UX decisions; it may offer new candidates for UI not yet covered.

## DESIGN.md stub

```markdown
# Design

Cross-cutting design context for this project. Agents read this for any UI work. Keep it short: rules and prohibitions only. Per-decision rationale lives in design/ux-decisions/.

## Visual rules

## Voice and tone

## Prohibitions
```

## Output

```
Design tree set up:
- design/ux-decisions/: N Draft UX decisions (or empty)
- DESIGN.md: scaffolded | pre-existing | skipped
- CLAUDE.md updated to route UI work to DESIGN.md and UX decisions

Record UX decisions with /blueprint-mode:decide.
```
