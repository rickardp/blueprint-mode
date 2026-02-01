---
status: Active
module: plugins/blueprint-mode/
related_adrs: []
---

# Decision Capture (Not Spec Generation)

## Overview

Blueprint Mode captures rationale for decisions rather than generating code from specifications. This is a deliberate departure from spec-driven development (SDD) approaches like Kiro, Spec-Kit, and similar tools.

## User Stories

- As a developer, I want to document WHY I chose a technology so that AI agents maintain consistency across sessions
- As a team lead, I want decisions captured without spec maintenance overhead so that documentation doesn't drift from code
- As an AI agent, I want clear rationale so that I can make consistent implementation choices without re-inventing decisions

## Requirements

- Capture decision rationale, not implementation details
- Validate that code respects decisions (not that it matches specs)
- Patterns are examples to follow, not templates to instantiate
- Support multi-tool workflows (Claude + Cursor + Copilot)
- Skills are informational (document decisions), not generative (produce code)

## Rationale

### Why Not Spec-Driven Development?

Traditional SDD treats specifications as the source of truth: **Specs → Generate Code**

Blueprint Mode inverts this: **Code exists → Capture decisions → Validate consistency**

| SDD Problem | Blueprint Mode Solution |
|-------------|------------------------|
| High friction to update specs | Lightweight decision capture via `/decide` |
| Spec drift as code evolves | Validate code respects decisions, not matches specs |
| Premature detail focus | Document only what matters (the WHY) |
| Specs say *what*, not *why* | Rationale is the source of truth |
| Detailed specs duplicate code | ADRs capture constraints, not implementation |

### The Core Insight

In an era of AI-assisted development:
- **Code is volatile** - AI agents rewrite it constantly
- **Rationale is stable** - WHY decisions were made rarely changes
- **Specs become stale** - Detailed specs require constant maintenance
- **Decisions persist** - Architecture choices survive implementation changes

### Multi-Tool Reality

Senior developers juggle Claude (planning), Cursor (multi-file edits), and Copilot (inline completions). Detailed specs don't survive context switches between tools. But rationale does:

- "We use PostgreSQL because the team knows it" travels across any tool
- "Implement database layer per schema.sql lines 1-50" doesn't

## References

- [Vibe Coding research (2025-2026)](https://stackoverflow.blog/2025/10/31/vibe-coding-needs-a-spec-too/) - Source of truth problem
- [Kiro spec-driven approach](https://kiro.dev) - The alternative we're not following
- [Anthropic context engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) - Why rationale > specs for agents
