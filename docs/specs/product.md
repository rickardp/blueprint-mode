---
last_updated: 2026-01-31
---

# Blueprint Mode

## Vision

Blueprint Mode makes the repo a complete source of truth for the era of vibe coding and agentic AI assistants. Code carries *what-is*; Blueprint's ADRs, UX decisions, and DESIGN.md context carry *why-it-is*. Both layers are first-class, both live in version control, both are agent-readable. Humans stay in control of system and design rationale; AI handles implementation details.

## Problem Statement

Code expresses *what is*. Run it and you see the behaviour. It does not express *why* a particular pattern was chosen, what alternatives were considered, or which constraints produced the current state. Without a rationale layer, deliberate decisions and expedient fills look identical from the outside — a primary CTA at the bottom of a checkout screen looks the same in JSX whether someone made a deliberate ergonomic choice or was finishing a feature on Friday afternoon.

Pre-AI, tribal knowledge disambiguated this. Coding agents have only what's in the context window — and "the existing code" doesn't tell them what was deliberate versus what was expedient. The cost rises sharply as more code is written by agents:

- **Lost intent** - you can't tell if code reflects a conscious decision or an agent just picking something
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

### Designers reviewing AI-generated UI
- Need to disambiguate *deliberate* design choices from *expedient* fills produced by agents — they look identical in JSX
- Want agents to preserve documented UX intent while treating undocumented UI as implementation that may be accidental
- Need cross-cutting design rules in `DESIGN.md` and per-context rationale in UX decisions
- Need a lightweight way to answer "was this deliberate?" without maintaining a parallel design canvas

### AI Agents
- Need clear rationale to make consistent implementation choices
- Need to know what patterns to follow and avoid
- Need boundaries (Always/Ask/Never rules) for autonomous operation

## Success Metrics

- Decisions captured take less than 2 minutes each
- AI agents follow documented patterns consistently
- Developers can distinguish deliberate UX decisions from coincidental generated UI
- Agents read `DESIGN.md` and UX decisions before UI work
- Onboarding extracts meaningful decisions from existing codebases
- Documentation stays current (no drift) because it captures WHY, not WHAT

## Features

See `docs/specs/features/` for detailed feature specifications.

## Quality Standards

- Run `/blueprint:validate` to check code against documented patterns, DESIGN.md, and decisions
- Follow templates from `plugins/blueprint-mode/skills/_templates/TEMPLATES.md`
