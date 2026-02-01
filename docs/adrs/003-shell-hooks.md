---
status: Active
date: 2026-01-31
---

# ADR-003: Shell Scripts for Hooks

## Context

Blueprint Mode needs to inject project context (specs, ADRs, patterns) into Claude's context automatically. The Claude Code plugin system supports hooks that run on events like prompt submission. We need to choose how to implement these hooks.

## Options Considered

### Option 1: Shell scripts (Bash)
- Pro: No runtime dependencies
- Pro: Works on macOS and Linux out of the box
- Pro: Simple file operations (glob, cat, grep)
- Pro: Easy to debug and modify
- Con: Limited on Windows (requires WSL or Git Bash)
- Con: No type safety

### Option 2: Node.js scripts
- Pro: Cross-platform compatibility
- Pro: Rich ecosystem for file manipulation
- Pro: Type safety with TypeScript
- Con: Requires Node.js runtime
- Con: Heavier for simple file operations

### Option 3: Python scripts
- Pro: Clean syntax for file operations
- Pro: Cross-platform
- Con: Requires Python runtime
- Con: Additional dependency for users

## Decision

We chose **Shell scripts (Bash)** because they require zero runtime dependencies and the operations are simple file manipulations (globbing directories, reading files, outputting text).

The hooks need to:
1. Find files matching patterns (`docs/adrs/*.md`)
2. Read file contents
3. Output formatted context

These are native shell operations. Adding a runtime dependency for this would be over-engineering.

## Consequences

**Positive:**
- Zero dependencies - works if Claude Code works
- Fast execution for simple operations
- Easy to inspect and modify hooks
- Follows Unix philosophy (simple tools, text streams)

**Negative:**
- Windows users need WSL or Git Bash
- No type safety (mitigated by simplicity)
- Complex logic would be harder to maintain (but we keep hooks simple)

## Related

- Tech stack overview: [docs/specs/tech-stack.md](../specs/tech-stack.md)
- Hooks implementation: `plugins/blueprint-mode/hooks/`
