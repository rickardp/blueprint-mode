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
- Pro: Hooks system for context injection
- Pro: Skills system for command expansion
- Con: Tied to Claude Code ecosystem

### Option 2: NPM package
- Pro: Familiar distribution model
- Pro: Broader ecosystem reach
- Con: Requires Node.js runtime
- Con: Doesn't integrate with Claude Code's skill/hook system
- Con: Additional complexity for users

### Option 3: Standalone CLI tool
- Pro: Independent of any AI tool
- Pro: Could work with multiple AI assistants
- Con: Requires separate installation and invocation
- Con: No integration with AI assistant context

## Decision

We chose **Claude Code Plugin System** because the team is already using Claude Code and the plugin system provides native integration with skills (commands) and hooks (context injection).

The plugin marketplace enables one-command installation (`/plugin marketplace add rickardp/blueprint-mode`), and the hooks system allows Blueprint documentation to be automatically injected into Claude's context.

## Consequences

**Positive:**
- Seamless integration with Claude Code workflow
- Skills appear as native commands (`/blueprint:decide`, etc.)
- Hooks inject context automatically on prompts
- No runtime dependencies beyond Claude Code

**Negative:**
- Only works with Claude Code (not Cursor, Copilot, etc.)
- Users must have Claude Code installed
- Feature set limited by plugin API capabilities

## Related

- Tech stack overview: [docs/specs/tech-stack.md](../specs/tech-stack.md)
