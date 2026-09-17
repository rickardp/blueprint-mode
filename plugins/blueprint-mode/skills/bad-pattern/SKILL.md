---
name: bad-pattern
description: Document something to avoid, with the correct alternative, in patterns/bad/anti-patterns.md. Use when the user says "don't do X" or corrects a recurring mistake.
argument-hint: "[what to avoid] - [correct approach]"
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Document Anti-Pattern

Format: `../_templates/TEMPLATES.md` (relative to this skill's directory), section `bad-patterns`. All anti-patterns, any subject, go in `patterns/bad/anti-patterns.md`.

## Steps

1. Extract the anti-pattern and the correct approach from the argument and the conversation. Ask for the alternative only if none was given.
2. Create `patterns/bad/anti-patterns.md` from the template header if it does not exist.
3. Append a section with category, severity, the bad example, the problems, the good example, and why. Use real code from the repo when it exists.
4. Report.

## Output

```
Anti-pattern documented in patterns/bad/anti-patterns.md
```
