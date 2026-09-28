---
status: Active
maturity: Stable
module: plugins/blueprint-mode/
related_adrs: [4, 6]
---

# AI-Agent Readability

## Overview

Blueprint Mode optimizes documentation for AI agent consumption over human historian completeness. This drives several deliberate deviations from traditional Architecture Decision Record (ADR) practices.

## User Stories

- As an AI agent, I want only active decisions visible so that I don't parse outdated content
- As a developer, I want git as the archive so that the docs folder stays clean and scannable
- As a team, I want PR reviews to capture advice so that we don't duplicate context in ADR documents

## Requirements

- Users describe desired outcomes in natural language; no skill names or command syntax are required
- All skills remain automatically discoverable with precise intent triggers; selecting a skill does not expand authorization
- Conversation capture requires a request to save intent; new-project setup commits only when authorized

- Delete superseded/deprecated ADRs when no code references them (git is the archive)
- Use PR reviews as the advice mechanism (no explicit Advice section in ADRs)
- Simplified status flow: Draft → Active → Superseded/Deprecated
- Clear terminology: "Active" (not Adopted), "Deprecated" (not Retired)
- Docs folder reflects current state only
- Discover relevant ADRs through references, titles, applicability, and broader body searches when needed, including cross-cutting decisions
- Keep the ADR Decision section first and self-contained: choice, applicability, constraints, and exceptions; retain motivation and alternatives separately
- Routine implementation retrieves only the prefix through Decision, stopping before Context, and follows it without reopening rationale; tool output excludes the unread rationale
- Unclear applicability, possible conflicts, scope extensions, and legacy or incomplete operational sections require a full ADR read
- Distinguish compatible extensions, clarifications, and conflicts before proposing changes to settled decisions; work outside scope is not automatically a conflict
- Onboarding preserves existing meaning and status while reorganizing ADRs, and leaves unknown scope explicit
- Scoped validation selects relevant ADRs; completeness checks require full reads and are reported as skipped when only Decision was read

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

## Implementation State

**Current focus:** None (stable)

| Milestone | Status |
|-----------|--------|
| Simplified ADR status flow | Done |
| Git-as-archive deletion policy | Done |
| PR reviews as advice | Done |
| Maturity field in feature specs | Done |
| Shared ADR selection and reading convention | Done |
| Operational Decision template and skill routing | Done |
| Legacy ADR migration guidance and scoped validation | Done |

**Open questions:**
- None

## Acceptance Scenarios

Use these cases to review retrieval and classification behavior; agent-run evaluation remains separate from this specification.

| Case | Expected reading and behavior |
|------|-------------------------------|
| Implement within a clear Active ADR | Tool output contains status and complete Decision but excludes Context and later sections; follow the rule without reconsidering alternatives |
| Use an explicit exception | Read complete Decision; apply the exception only within its stated conditions |
| Add an unrelated feature | Search applicability and cross-cutting decisions; do not label the feature conflicting merely because one ADR does not cover it |
| Extend a feature beyond an unclear scope | Read full ADR; classify from established intent, leaving unresolved scope explicit |
| Rewrite a requirement to contradict an Active constraint | Read full ADR; identify the affected rule and raise the conflict unless the user already authorized its replacement |
| Clarify wording without changing established intent | Read full ADR; update in place rather than superseding |
| Follow a reference to a Superseded ADR | Follow the replacement link and assess the current decision; report a broken link |
| Use a legacy ADR with constraints in Consequences | Read full ADR; onboarding moves operative constraints into Decision without changing meaning |
| Validate a small change governed by a repository-wide rule | Include the global ADR despite no direct code reference; do not load unrelated ADR bodies |

## References

- [ThoughtWorks Radar: Lightweight ADRs](https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records)
- [Martin Fowler: Decision Records](https://martinfowler.com/articles/scaling-architecture-conversationally.html)
- [Michael Nygard: Original ADR proposal](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
