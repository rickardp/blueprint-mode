---
status: Active
date: 2026-01-31
---

# ADR-004: Decision Capture over Spec-Driven Development

## Context

AI-assisted development has changed how code is written. Tools like Claude, Cursor, and Copilot can generate large amounts of code quickly, but this creates a problem: when code IS the spec, AI rewrites your source of truth at will.

We needed to choose between traditional spec-driven development (detailed specifications that generate code) and a lighter-weight approach focused on capturing decisions.

## Options Considered

### Option 1: Spec-Driven Development (SDD)
- Pro: Detailed specifications ensure completeness
- Pro: Code can be generated from specs
- Pro: Clear contract between design and implementation
- Con: High friction to update specs
- Con: Specs become stale as code evolves (spec drift)
- Con: Premature detail focus
- Con: Specs say WHAT but not WHY

### Option 2: Decision Capture (ADR-based)
- Pro: Captures WHY, which rarely changes
- Pro: Low friction to document decisions
- Pro: Works across multiple AI tools
- Pro: Validates consistency, not spec compliance
- Con: Less detailed than full specifications
- Con: Requires discipline to capture decisions

## Decision

We chose **Decision Capture (ADR-based)** because rationale is stable while code is volatile.

In an era of AI-assisted development:
- Code is rewritten constantly by AI agents
- Detailed specs require constant maintenance to stay current
- But WHY decisions were made rarely changes
- "We use PostgreSQL because the team knows it" survives any refactor

Blueprint Mode inverts SDD: **Code exists -> Capture decisions -> Validate consistency**

## Consequences

**Positive:**
- Low friction documentation (just the WHY)
- Works across Claude, Cursor, Copilot
- No spec drift - decisions don't detail implementation
- Humans stay in control of architecture

**Negative:**
- Less prescriptive than full specs
- Teams expecting detailed specs may find it insufficient
- Requires cultural shift from "spec everything" mindset

## Related

- Feature spec: [docs/specs/features/decision-capture.md](../specs/features/decision-capture.md)
- Feature spec: [docs/specs/features/ai-agent-readability.md](../specs/features/ai-agent-readability.md)
- Tech stack overview: [docs/specs/tech-stack.md](../specs/tech-stack.md)
