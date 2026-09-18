---
name: capture
description: Persist decisions, requirements, patterns, and progress from the current conversation into Blueprint docs. Use at the end of a working session or when the user says to save what was discussed.
argument-hint: "[optional topic to focus on]"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Capture Conversation

Formats are in `../_templates/TEMPLATES.md` (relative to this skill's directory). Respect the code tree vs design tree split in section `design-separation`.

## Steps

1. Scan the conversation (or the given topic) for: decisions with rationale, requirements discovered or refined, patterns agreed on, resolved open questions, and implementation progress or new constraints. For UI, capture intent only where a person confirmed a choice was deliberate.
2. Map each item to a destination:
   - New architectural decision: Draft ADR
   - New UX decision: Draft UX decision, only if `design/ux-decisions/` exists
   - Cross-cutting design rule: bullet in `DESIGN.md`, only if it exists
   - New feature: feature spec at `maturity: Exploring`
   - Refinement or progress: update the existing spec or decision, including its Implementation State; set a Draft to Active when its last TODO is resolved
   - Pattern or anti-pattern: `patterns/`
3. For each item, check its target directory for an existing document on the topic and update that instead of creating. Skip anything already documented or derivable from code.
4. Write the creates and updates. In the report, show old and new text for any update that replaces existing rationale rather than adding to it.
5. If a UX decision or `DESIGN.md` rule was skipped because its destination does not exist, list it separately and point at `/blueprint-mode:onboard-design`. Omit that note when nothing was skipped.
6. If a retitle makes a decision filename stale, rename the file and update references as the template describes.

## Output

```
Captured from conversation:
- Created docs/adrs/005-caching-strategy.md (Draft)
- Updated docs/specs/features/notifications.md: maturity Exploring -> Building, 2 requirements, implementation state
```
