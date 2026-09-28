---
name: setup-repo
description: Scaffold a brand-new project with Blueprint documentation and a test setup. Use when the user asks to create a new project with Blueprint; use onboard for an existing codebase.
allowed-tools: Read, Glob, Grep, Write, Edit, Bash
---

# Set Up New Repository

Formats and working style are in `../_templates/TEMPLATES.md` (relative to this skill's directory): `working-style`, `agent-file-detection`, `adr-template`, `product-spec`, `boundaries`, `bad-patterns`, `agent-instructions`.

## Steps

1. Extract everything from the argument: name, description, runtime, framework, database, and any rationale ("team knows X" is rationale for X). Ask once, in a single message, for what is still missing, and accept "create now" with defaults for the rest.
2. Infer sensible defaults for what is unspecified: the runtime's common framework, its standard test runner, and a database driver if a database was named. Rationale defaults to "Team preference". Add only dependencies that were requested or are the de facto standard.
3. Detect an existing agent instructions file per `agent-file-detection`; default to creating `CLAUDE.md`.
4. Create:
   - `docs/adrs/` with one Active ADR per stack choice
   - `docs/specs/product.md`, `boundaries.md` from the template
   - `docs/specs/features/` and `docs/specs/non-functional/` as empty directories
   - `patterns/good/.gitkeep`, `patterns/bad/anti-patterns.md` with the template header
   - Agent instructions from the `agent-instructions` template, without the design lines, with Autonomy and limits filled from `boundaries.md`
   - A minimal test setup for the runtime and one passing example test
   - Standard project files for the runtime (manifest, ignore file)
5. Initialize git if needed for the requested project. Make an initial commit only when the user requested or already authorized it; otherwise leave the changes uncommitted.
6. Do not create `design/` or `DESIGN.md`. If the project has UI in scope, mention that design intent capture can be enabled by asking for it.

## Output

```
Created [name]:
- N ADRs
- docs/specs/, patterns/, CLAUDE.md
- Tests: [framework], example test passing
- Git: initialized | existing; commit: made | not requested

Describe further requirements or decisions and ask to record them.
```
