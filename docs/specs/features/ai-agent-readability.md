---
status: Active
module: plugins/blueprint-mode/
related_adrs: []
---

# AI-Agent Readability

## Overview

Blueprint Mode optimizes documentation for AI agent consumption over human historian completeness. This drives several deliberate deviations from traditional Architecture Decision Record (ADR) practices.

## User Stories

- As an AI agent, I want only active decisions visible so that I don't parse outdated content
- As a developer, I want git as the archive so that the docs folder stays clean and scannable
- As a team, I want PR reviews to capture advice so that we don't duplicate context in ADR documents

## Requirements

- Delete superseded/deprecated ADRs when no code references them (git is the archive)
- Use PR reviews as the advice mechanism (no explicit Advice section in ADRs)
- Simplified status flow: Draft → Active → Superseded/Deprecated
- Clear terminology: "Active" (not Adopted), "Deprecated" (not Retired)
- Docs folder reflects current state only

## Rationale

### Why Deviate from Traditional ADR Practices?

Traditional ADR philosophy (Nygard, Fowler, ThoughtWorks) treats ADRs as permanent historical records. Blueprint Mode treats them as current-state documentation for AI agents.

| Traditional Practice | Blueprint Mode | Why |
|---------------------|----------------|-----|
| Never delete ADRs | Delete when no code references | Signal over noise for AI agents |
| Advice section with names/dates | PR reviews capture it | Avoid duplication, use existing workflow |
| Draft → Proposed → Adopted → Retired | Draft → Active → Superseded/Deprecated | PR merge = approval; simpler flow |
| "Adopted" terminology | "Active" | Clearer for current validity |
| "Retired" terminology | "Deprecated" | Standard software term |

### The Primary Consumer

Traditional ADRs optimize for:
- Future human developers joining the team
- Auditors reviewing decision history
- Historians understanding evolution

Blueprint Mode ADRs optimize for:
- AI agents reading project context in every session
- Developers scanning current state quickly
- Multi-tool workflows where context must be minimal

### Git as Archive

The controversial choice: deleting superseded ADRs.

**Traditional view:** ADRs are historical records; never delete.

**Blueprint Mode view:**
- Git history preserves everything
- Docs folder should reflect current reality
- AI agents waste tokens parsing superseded decisions
- Developers mentally filter outdated content

When an ADR is superseded and no code references it, delete it. `git log` is the archive.

### PR Reviews as Advice

Fowler recommends an explicit Advice section recording "who said what" with names and dates.

Blueprint Mode relies on PR reviews instead:
- Advice is captured in PR comments
- Decisions are approved by merge
- "PR merge = approved" principle
- No duplication between PR and ADR

This works for teams with PR-based workflows. Teams requiring formal audit trails may need the explicit section.

## References

- [ThoughtWorks Radar: Lightweight ADRs](https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records)
- [Martin Fowler: Decision Records](https://martinfowler.com/articles/scaling-architecture-conversationally.html)
- [Michael Nygard: Original ADR proposal](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
