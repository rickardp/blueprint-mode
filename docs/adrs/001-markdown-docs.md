---
status: Active
date: 2026-01-31
---

# ADR-001: Markdown as Documentation Format

## Decision

Use **Markdown** for Blueprint documentation.

**Applies to:** Repository-wide documentation and the ADRs, specs, patterns, and agent instructions Blueprint writes into user repositories.

**Constraints:** Keep documentation alongside code in git, readable and editable as plain text without specialized tooling or a documentation build step.

**Exceptions:** No exceptions recorded.

## Context

Blueprint Mode needs a documentation format that AI agents can read efficiently across sessions, that developers can edit without specialized tooling, and that works seamlessly with git-based workflows.

We chose **Markdown** because it's the universal format that AI agents, developers, and git all handle natively.

Markdown files live alongside code, diff cleanly, and require zero tooling. AI agents parse prose naturally, making Markdown ideal for rationale-heavy documentation like ADRs.

## Options Considered

### Option 1: Markdown
- Pro: Universal support in editors, git diffs, and AI models
- Pro: No build step or compilation required
- Pro: Human-readable as plain text
- Con: Limited structure enforcement

### Option 2: Structured formats (YAML, JSON, TOML)
- Pro: Machine-parseable with schema validation
- Pro: Strict structure enforcement
- Con: Less readable for humans
- Con: AI agents handle prose better than structured data

### Option 3: Specialized documentation tools (Notion, Confluence)
- Pro: Rich editing experience
- Pro: Collaboration features
- Con: Requires external service
- Con: Not in git, breaks single-source-of-truth principle
- Con: AI agents cannot read without API integration

## Consequences

**Positive:**
- Zero friction to create/edit documentation
- Works with any editor
- Git history tracks all changes
- AI agents read it without transformation

**Negative:**
- No schema validation (mitigated by templates)
- Structure relies on convention, not enforcement

## Related

None.
