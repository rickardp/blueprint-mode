# Agent Boundaries

## Safe Without Asking

- Edit skills, templates, and docs in this repo
- Record a decision, pattern, or requirement the user stated
- Rename decision files when a retitle makes the slug stale, updating references
- Run `/blueprint-mode:validate` and act on its findings for docs you changed

## Ask First

### Plugin surface
- Renaming or removing a skill, or changing a skill's argument shape
- Changing the format of an ADR, spec, or pattern file that existing user repos already contain
- Changing the boundaries vocabulary (`Safe Without Asking` / `Ask First` / `Never Do`)

### Distribution
- Changing either plugin manifest or marketplace file beyond a version bump
- Adding any file format beyond Markdown

### Documentation
- Creating ad-hoc Markdown files outside the Blueprint structure

## Never Do

### Dependencies
- Add a runtime, shell script, hook, build step, or external service; the plugin is Markdown only ([ADR-006](../adrs/006-skills-and-repo-files-only.md))

### Security
- Commit secrets or credentials

### Documentation
- Duplicate a format that lives in `_templates/TEMPLATES.md` into a skill
- Restate rationale inline in code or docs that an ADR already holds

## Scoped Rules

### plugins/blueprint-mode/skills/
- Keep a `SKILL.md` under 80 lines and imperative: steps, then output
- State the scope once; ask only about content that cannot be found
- Give every model-invocable skill a description that says when to use it
- Mark skills that write many files or change history `disable-model-invocation: true`
