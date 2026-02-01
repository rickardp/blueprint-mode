# AI Agent Instructions for Blueprint Mode

## Project Context

Blueprint Mode is a Claude Code plugin that creates a stable source of truth for AI-assisted development. It captures decision rationale (ADRs), patterns, and boundaries so AI agents maintain consistency across sessions.

**Key principle:** We capture WHY decisions were made, not detailed specs of WHAT to build. Rationale is stable; code is volatile.

## Architecture Decisions

All tech choices and their rationale are documented in `docs/adrs/`.
See `docs/specs/tech-stack.md` for a summary table.

Key decisions:
- **ADR-001:** Markdown as documentation format (universal, zero-tooling)
- **ADR-002:** Claude Code Plugin System for distribution (native integration)
- **ADR-003:** Shell scripts for hooks (zero dependencies)
- **ADR-004:** Decision capture over spec-driven development (rationale > specs)

## CRITICAL: Pre-Edit Checklist

**BEFORE writing or editing ANY code, you MUST:**

1. **Check Feature Specs**
   - If implementing a documented feature, READ `docs/specs/features/[feature].md` FIRST
   - Look for `related_adrs` field - these ADRs MUST be followed
   - If no spec exists for a significant feature, ask: "Should I create a feature spec first?"

2. **Check Boundaries**
   - Read `docs/specs/boundaries.md` before ANY code changes
   - "Never Do" items are HARD BLOCKERS - refuse to proceed if violated
   - "Ask First" items require explicit user confirmation before proceeding

3. **Reference Patterns**
   - Check `patterns/good/` for examples of how to write this type of code
   - Check `patterns/bad/anti-patterns.md` to know what to avoid
   - Follow existing patterns in the codebase

4. **Traceability**
   - When implementing a decision, add: `// ADR-NNN: [brief note]`
   - Keep it short - the ADR has the full rationale

**BOUNDARY VIOLATIONS**

If a user request would violate a "Never Do" boundary:
1. DO NOT proceed with the implementation
2. INFORM the user: "This request would violate boundary: [rule]"
3. SUGGEST alternative approaches that comply with boundaries

## Documentation

| Directory | Purpose |
|-----------|---------|
| `docs/specs/` | Product requirements, tech decisions, boundaries |
| `docs/specs/features/` | Feature specifications with requirements |
| `docs/adrs/` | Architecture Decision Records - the "why" behind choices |
| `patterns/good/` | Approved code examples to follow |
| `patterns/bad/` | Anti-patterns to avoid |

See [docs/specs/boundaries.md](docs/specs/boundaries.md) for agent guardrails (Always/Ask/Never rules).

## Code Comments

Reference ADRs with a brief note - the ADR has the full rationale:

```bash
# ADR-003: Shell hooks for zero dependencies
grep -h "^status:" docs/adrs/*.md
```

**Don't duplicate full rationale in comments:**
```bash
# Bad: Using grep because we need zero dependencies and jq would require installation
# Good: # ADR-003: Zero-dependency hooks
```

## Pattern Discovery

When the user corrects or discourages a code pattern during development:
- If they show a better way -> Suggest: "Should I capture this as a good pattern?"
- If they say "don't do X" -> Suggest: "Should I document this as an anti-pattern?"

## Zero-Dependency Principle

This is a **zero-dependency plugin**. Before adding ANY code:
- No Node.js, Python, or other runtimes
- No external packages or libraries
- No build steps or compilation
- Only bash built-ins and standard Unix tools in hooks

If a feature requires dependencies, it doesn't belong in Blueprint Mode.

## Commands

```bash
# Run plugin locally
claude --plugin-dir ./plugins/blueprint-mode

# Test installation
/plugin marketplace add rickardp/blueprint-mode
/plugin install blueprint-mode
```

## Skills Structure

Skills live in `plugins/blueprint-mode/skills/[name]/SKILL.md`:
- Keep under 100 lines
- Use imperative commands ("Create X"), not scope questions ("What would you like?")
- Follow templates from `plugins/blueprint-mode/skills/_templates/TEMPLATES.md`
