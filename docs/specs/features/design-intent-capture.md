---
status: Active
maturity: Building
module: plugins/blueprint-mode/skills/
related_adrs: [4]
---

# Design Intent Capture

## Overview

Blueprint Mode helps teams distinguish deliberate UX/design choices from expedient fills produced by agents — the two look identical in JSX. The design tree records the WHY behind important UI choices and the top-level design context (`DESIGN.md`) carries cross-cutting rules. Together they form the *why-it-is* layer for UI, sitting next to the code without trying to replace the design canvas as a parallel source of truth for *what-is*.

## User Stories

- As a developer, I want to know whether a UI behavior or layout exists for a deliberate design reason so that I do not remove intent accidentally.
- As a designer, I want to mark important generated UI choices as intentional without editing code or maintaining a full design-system spec.
- As an AI agent, I want documented UX decisions to constrain UI changes while treating undocumented UI as implementation, not rationale.

## Requirements

- Capture deliberate UX choices as `design/ux-decisions/UX-NNN-*.md` records when the design tree exists. Authoring is conversational (via `/blueprint:onboard-design` day-one triage or `/blueprint:decide`), never a hand-filled template.
- Provide a `// UX-TBD: [what's unclear]` code comment convention so agents can flag UI with no governing decision *without* inventing rationale.
- Treat undocumented UI code as not-yet-explained implementation, not as design authority.
- `/blueprint:onboard-design` may run a day-one triage that scans the existing UI/code for a small number (≤5) of patterns and uses them as prompts: it asks the user or designer whether each was a conscious choice and what the rationale was, then captures only those with articulated intent. Code is the prompt, not the source of truth — the human supplies the why.
- Be compatible with `DESIGN.md` at the repo root as the top-level design context — cross-cutting rules, voice/tone, prohibitions. `DESIGN.md` is a community convention (Google Stitch / awesome-design-md); Blueprint does not own the format. `/blueprint:onboard-design` may scaffold a minimal stub when the user wants one and reference it from agent instructions so it's read on every UI generation task. Authoring stays conversational; the file is never hand-filled.
- Maintain a clear delineation: cross-cutting design rules belong in `DESIGN.md`; per-decision rationale (one choice with alternatives considered) belongs in `design/ux-decisions/`. UX decisions reference `DESIGN.md` rules rather than restating them, and a draft UX decision that turns out to be a broad rule with no alternatives is moved to `DESIGN.md` instead.
- `/blueprint:validate` checks UI code against Active UX decisions and surfaces `// UX-TBD:` flag counts for review.
- Preserve the research direction: code remains canonical for what exists; Blueprint records why important choices should persist.

## Implementation State

**Current focus:** None

| Milestone | Status |
|-----------|--------|
| Product spec includes designers as users | Done |
| Design tree supports deliberate-vs-coincidental framing | Done |
| `/blueprint:onboard-design` runs intent-capture day-one triage (scan UI → user articulates which were conscious choices and why → capture those) | Done |
| Agent instructions warn against inferring design rationale from undocumented UI | Done |
| `// UX-TBD:` comment convention documented in CLAUDE.md template + TEMPLATES.md | Done |
| `/blueprint:validate` checks UX decision compliance and reports UX-TBD flag inventory | Done |
| `DESIGN.md` treated as community-owned top-level design context — `/blueprint:onboard-design` offers to scaffold a compatible stub and wires it into agent instructions | Done |
| `DESIGN.md` vs `design/ux-decisions/` delineation documented in TEMPLATES.md and help skill | Done |
| `/blueprint:decide`, `/blueprint:capture`, `/blueprint:status`, and `/blueprint:validate` treat `DESIGN.md` as a first-class repo artifact | Done |

**Open questions:**
- Whether design intent candidates should later be detected from visual diffs, Storybook stories, or code heuristics.
- Whether a parallel `// ADR-TBD:` flag is worth introducing for symmetry, or whether architecture's "deliberate vs coincidental" question is already adequately served by ADRs alone.

**Constraints:**
- Do not create a new parallel design source of truth.
- Do not require designers to hand-fill markdown templates. Authoring is conversational via `/blueprint:onboard-design` triage or `/blueprint:decide`.
- Never hand-fill `DESIGN.md` from a template. The file is a living artefact maintained conversationally as decisions accumulate, same anti-ritual rule as ADRs and UX decisions.
- Do not claim ownership of the `DESIGN.md` format. It's a community convention Blueprint stays compatible with — Blueprint reads/respects it, can scaffold a minimal stub, and avoids duplicating information that belongs there.
- Capture intent, not inferred structure. UX decisions exist for *conscious* choices with a stated rationale; current code shape on its own is not evidence a choice was deliberate. Day-one triage caps candidates at ~5 to keep the conversation focused on choices the human can articulate.
