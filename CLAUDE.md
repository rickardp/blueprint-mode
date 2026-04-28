# AI Agent Instructions for Blueprint Mode

## Project Context

Blueprint Mode is a Claude Code plugin that turns the repo into a complete source of truth for AI-assisted development. Code carries *what-is*; Blueprint's ADRs, UX decisions, DESIGN.md context, patterns, and boundaries carry *why-it-is*. Both layers are first-class, both are agent-readable, and they sit next to each other in version control.

**Key principle:** Code shows what the system does; without a rationale layer, agents can't tell *deliberate decisions* from *expedient fills* — they look identical from the outside. Blueprint records the WHY so future humans and agents can disambiguate.

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
   - Check `patterns/good/` for approved examples relevant to this change
   - Check `patterns/bad/anti-patterns.md` to know what to avoid
   - Follow existing patterns in the codebase

4. **For UI work, also check design intent**
   - Read `DESIGN.md` if it exists for cross-cutting design rules and prohibitions
   - Check `design/ux-decisions/` for UX choices that constrain the work
   - Treat documented UX decisions as deliberate design intent
   - Do not assume undocumented UI code is deliberate; preserve it when practical, but flag unclear intent with `// UX-TBD: [what's unclear]` instead of inventing rationale

5. **Traceability**
   - When implementing an architectural decision, add: `// ADR-NNN: [brief note]`
   - When implementing a UX decision, add: `// UX-NNN: [brief note]`
   - Keep it short - the ADR / UX decision has the full rationale

**BOUNDARY VIOLATIONS**

If a user request would violate a "Never Do" boundary:
1. DO NOT proceed with the implementation
2. INFORM the user: "This request would violate boundary: [rule]"
3. SUGGEST alternative approaches that comply with boundaries

## Documentation

Blueprint splits owned artifacts into two strictly separate trees. `DESIGN.md` is important adjacent repo context, not part of the Blueprint structure. Different reviewers (engineering vs design) own different paths — never mix ADRs and UX decisions.

**Code / architecture tree:**

| Directory | Purpose |
|-----------|---------|
| `docs/specs/` | Product requirements, tech decisions, boundaries |
| `docs/specs/features/` | Feature specs with requirements, maturity, and implementation state |
| `docs/adrs/` | Architecture Decision Records - the "why" behind tech choices |
| `patterns/good/` | Approved examples to follow (code, schema, UI, scripts) |
| `patterns/bad/` | Anti-patterns to avoid (code, schema, UI, scripts) |

**Important adjacent design context:**

| Path | Purpose |
|------|---------|
| `DESIGN.md` | Top-level design context: cross-cutting UI rules and prohibitions |

**Design / UX tree (opt-in — only present if `/blueprint:onboard-design` was run):**

| Directory | Purpose |
|-----------|---------|
| `design/sources.md` | External design sources (Figma, Storybook, docs URLs) |
| `design/ux-decisions/` | UX decisions (UX-NNN) - the "why" behind UX/design choices |

The design tree is **not** auto-created. Run `/blueprint:onboard-design` once if you want it; the skill scaffolds the directories, records external Figma/Storybook references, and can optionally surface a small number of candidate UX decisions found in existing UI/code for the user, developer, or designer to confirm. Existing code is only a prompt for the conversation; capture the why only when a human states it. Anything not covered there is captured later, on demand, via `/blueprint:decide`.

See [docs/specs/boundaries.md](docs/specs/boundaries.md) for agent guardrails (Always/Ask/Never rules).

## Code Comments

Reference ADRs / UX decisions with a brief note - the source doc has the full rationale:

```bash
# ADR-003: Shell hooks for zero dependencies
grep -h "^status:" docs/adrs/*.md
```

```tsx
// UX-002: Destructive actions require confirmation
<ConfirmDialog ... />
```

**Don't duplicate full rationale in comments:**
```bash
# Bad: Using grep because we need zero dependencies and jq would require installation
# Good: # ADR-003: Zero-dependency hooks
```

**Flagging unclear UI intent (`// UX-TBD:`):** When UI code has no governing UX decision and the agent isn't sure if a choice is deliberate, mark it explicitly rather than inventing rationale:

```tsx
// UX-TBD: empty-state copy — agent-generated, not reviewed
<EmptyState message="..." />
```

`UX-TBD:` is a flag, not a decision. It signals "deliberate review needed", not "deliberate design". Resolve it by either capturing a UX decision (`/blueprint:decide`) and replacing with `// UX-NNN:`, or by removing the comment when designer confirms it doesn't matter.

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
