---
status: Active
date: 2026-04-21
---

# ADR-005: Dual Claude Code and Codex Plugin Packaging

## Context

Blueprint Mode started as a Claude Code plugin because the initial team workflow relied on Claude's native plugin, skills, and hooks model.

As Codex plugin support matured, the repository needed a way to support both runtimes without introducing a second independently maintained Blueprint implementation. The existing Claude plugin tree already contains the authoritative `skills/`, `hooks/`, `agents/`, and templates used by Blueprint Mode.

We needed to choose how to package Blueprint for Codex while keeping Claude behavior stable.

## Options Considered

### Option 1: Separate Claude and Codex plugin trees
- Pro: Each runtime can be optimized independently
- Pro: No ambiguity about runtime-specific metadata
- Con: Duplicates the Blueprint skill inventory
- Con: Higher maintenance burden and risk of drift
- Con: Makes documentation and releases more complex

### Option 2: Shared plugin root with shared `skills/`
- Pro: Lowest maintenance overhead
- Pro: Keeps the current Claude implementation canonical
- Pro: Lets Codex try the existing skills before any runtime-specific split
- Pro: Preserves the current repository structure
- Con: Some skill text is Claude-shaped and may not be ideal for Codex
- Con: Codex-specific hooks and UX may still need separate follow-up work

### Option 3: Generated runtime artifacts from a shared source model
- Pro: Could produce runtime-specific outputs with less duplication
- Pro: Makes shared concepts explicit
- Con: Adds a build pipeline and artifact management
- Con: Increases complexity before runtime differences are proven
- Con: Risks degrading the Claude plugin if generation diverges from the current hand-tuned skills

## Decision

We chose **Shared plugin root with shared `skills/`**.

Blueprint Mode now keeps `plugins/blueprint-mode/` as the single canonical plugin directory and adds Codex packaging alongside the existing Claude packaging:

- Claude continues to use `.claude-plugin/plugin.json`
- Codex uses `.codex-plugin/plugin.json`
- Both runtimes point at the existing `skills/` directory
- Codex discovery is wired through repo-local marketplace metadata at `.agents/plugins/marketplace.json`

This keeps the current Claude plugin working as-is while testing the simplest possible Codex support path first.

## Consequences

**Positive:**
- Claude behavior remains the primary source of truth
- No second skill tree to maintain
- Minimal repository churn
- Codex support can be validated with real usage before introducing runtime-specific forks

**Negative:**
- Some shared skill text may be suboptimal for Codex
- Codex-specific hook behavior remains a separate problem
- Codex plugin packaging does not currently document plugin-bundled `agents/`, so `plugins/blueprint-mode/agents/` remains Claude-oriented reference material for now
- We may still need to fork a subset of skills later if evidence shows meaningful Codex regressions

## Related

- Builds on: [ADR-002: Claude Code Plugin System as Distribution Mechanism](002-claude-code-plugin.md)
- Tech stack overview: [docs/specs/tech-stack.md](../specs/tech-stack.md)
- Hooks implementation: `plugins/blueprint-mode/hooks/`
- Reference personas: `plugins/blueprint-mode/agents/`
