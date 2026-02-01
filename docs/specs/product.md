---
last_updated: 2026-01-31
---

# Blueprint Mode

## Vision

Blueprint Mode is a stable source of truth for the era of vibe coding and agentic AI assistants. It keeps humans in control of system design while letting AI handle implementation details.

## Problem Statement

When code IS the spec, AI rewrites your source of truth at will:
- **Lost intent** - you can't tell if code reflects a conscious decision or AI just picking something
- **Lost memory** - AI forgets why you chose PostgreSQL over MongoDB last week
- **Lost consistency** - different architectural choices each session
- **Lost boundaries** - difficult to set up constraints and coding practices

Traditional spec-driven development introduces its own problems:
- **Premature detail** - forced to focus on details not yet on top of mind
- **High friction** - updating specs is tedious
- **Spec drift** - specifications become outdated as code evolves
- **Wrong abstraction level** - specs either duplicate code or are too vague

## Users

### Developers using AI assistants
- Need architectural decisions to persist across AI sessions
- Want AI to follow established patterns consistently
- Need boundaries that AI agents respect

### Team leads
- Want decisions documented without spec maintenance overhead
- Need visibility into architectural choices and their rationale
- Want to onboard new team members (human or AI) efficiently

### AI Agents
- Need clear rationale to make consistent implementation choices
- Need to know what patterns to follow and avoid
- Need boundaries (Always/Ask/Never rules) for autonomous operation

## Success Metrics

- Decisions captured take less than 2 minutes each
- AI agents follow documented patterns consistently
- Onboarding extracts meaningful decisions from existing codebases
- Documentation stays current (no drift) because it captures WHY, not WHAT

## Features

See `docs/specs/features/` for detailed feature specifications.

## Quality Standards

- Run `/blueprint:validate` to check code against documented patterns and decisions
- Follow templates from `plugins/blueprint-mode/skills/_templates/TEMPLATES.md`
