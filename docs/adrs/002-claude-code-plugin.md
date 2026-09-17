---
status: Active
date: 2026-01-31
---

# ADR-002: Claude Code Plugin System as Distribution Mechanism

## Context

Blueprint Mode needs a distribution mechanism that allows users to install and use the tool easily, integrates with Claude Code's existing workflow, and doesn't require external package managers or build systems.

## Options Considered

### Option 1: Claude Code Plugin System
- Pro: Native integration with Claude Code
- Pro: Simple installation via `/plugin marketplace add`
- Pro: Skills system for command expansion
- Con: Tied to Claude Code ecosystem

### Option 2: NPM package
- Pro: Familiar distribution model
- Pro: Broader ecosystem reach
- Con: Requires Node.js runtime
- Con: Doesn't integrate with Claude Code's skill system
- Con: Additional complexity for users

### Option 3: Standalone CLI tool
- Pro: Independent of any AI tool
- Pro: Could work with multiple AI assistants
- Con: Requires separate installation and invocation
- Con: No integration with AI assistant context

## Decision

We chose **Claude Code Plugin System** because the team is already using Claude Code and the plugin system provides native integration with skills (commands).

The plugin marketplace enables one-command installation (`/plugin marketplace add rickardp/blueprint-mode`). Skills are plain Markdown, so the same files load in other runtimes (see ADR-005).

## Consequences

**Positive:**
- Seamless integration with Claude Code workflow
- Skills appear as native commands (`/blueprint-mode:decide`, etc.)
- No runtime dependencies beyond Claude Code

**Negative:**
- Tied to the Claude Code ecosystem for the Claude workflow
- Users who want the Claude workflow must have Claude Code installed
- Feature set limited by plugin API capabilities

## Related

- Tech stack overview: [docs/specs/tech-stack.md](../specs/tech-stack.md)
- See also: [ADR-005: Dual Claude Code and Codex Plugin Packaging](005-dual-runtime-plugin-packaging.md), [ADR-006: Skills and Repo Files Only](006-skills-and-repo-files-only.md)
