# Agent Instructions for Blueprint Mode

Blueprint Mode is a Claude Code and Codex plugin that makes a repo carry its own rationale. Code shows what a system does; Blueprint's ADRs, specs, patterns, boundaries, and (opt-in) UX decisions record why, so agents can tell deliberate choices from expedient ones. The plugin is Markdown only: skills in `plugins/blueprint-mode/skills/*/SKILL.md` and one shared `_templates/TEMPLATES.md`.

## Where intent lives

- `docs/adrs/` records the plugin's own architecture decisions. Read the relevant ADR when a change touches a documented choice; ADR-006 covers why there are no hooks and how skills are written.
- `docs/specs/features/` holds feature specs. Read one when changing that feature.
- `docs/specs/boundaries.md` says what is safe without asking, what to ask about, and what is never done. Read it before changing the plugin surface, manifests, or file formats.
- Scoped boundaries apply to `plugins/blueprint-mode/skills/`. Before editing those paths, read only the matching sections in `docs/specs/boundaries.md`.
- `patterns/bad/anti-patterns.md` lists mistakes specific to writing skills and agent instructions. Check it when editing a skill or the generated CLAUDE.md template.
- `docs/specs/tech-stack.md` summarizes the stack.

## Autonomy and limits

Safe without asking: edit skills, templates, and docs; record decisions the user states; rename decision files when a retitle makes the slug stale; run `/blueprint-mode:validate` on what you changed.
Ask first: renaming or removing a skill, changing a file format that users' repos already contain, changing the boundaries vocabulary, editing a manifest beyond a version bump.
Never: add a runtime, shell script, hook, build step, or external service; duplicate a template format into a skill. If a request would violate one of these, say which and propose an alternative.

## Writing skills

- A `SKILL.md` is a router: a precise description that says when to use it, numbered steps, and the template section to use. Keep it under 80 lines.
- State the scope once. Ask only about content that cannot be found, and write `TBD` when skipped. No plan-mode checkpoints, no confirmation before creating files.
- Formats live only in `_templates/TEMPLATES.md`. Point at a section; never paste it.
- Write for current models: no MUST, CRITICAL, or forbidden-phrase lists. Say what to do and where to find things.

## Traceability

When code or a skill implements a documented decision, add a one-line reference and leave the rationale in the ADR:

```
# ADR-006: skills point at templates instead of embedding formats
```

## Recording new intent

When the user states a decision with a reason or corrects a pattern, offer to record it with `/blueprint-mode:decide`, `/blueprint-mode:require`, `/blueprint-mode:good-pattern`, or `/blueprint-mode:bad-pattern`. Superseded decisions with no references may be deleted; git history is the archive.

## Commands

```bash
claude --plugin-dir ./plugins/blueprint-mode   # run the plugin locally
codex plugin marketplace add ./                # Codex local development, then restart Codex
```

When skills change, bump the version in `plugins/blueprint-mode/.claude-plugin/plugin.json`, `plugins/blueprint-mode/.codex-plugin/plugin.json`, and `.claude-plugin/marketplace.json`.
