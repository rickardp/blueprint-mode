---
name: good-pattern
description: Save code, schema, UI, or a script as an approved example in patterns/good. Use when the user points at code and says it is the way to do it.
argument-hint: "[file path or description]"
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Capture Good Pattern

Format: `../_templates/TEMPLATES.md` (relative to this skill's directory), section `good-patterns`. Patterns cover any subject and all live under `patterns/good/`.

## Steps

1. Locate the code. A path is read directly; a description is searched for, asking which file only if several match; no argument means the code most recently discussed, asking only if nothing is in context.
2. Extract the representative part, not the whole file.
3. Write `patterns/good/[descriptive-name].[ext]` with the header block: when to use it, key elements, the ADRs or UX decisions that motivate it (only those that genuinely apply), and the source path.
4. If the agent instructions file lists the good patterns by name, add the new one.

## Output

```
Pattern captured at patterns/good/name.ext
```
