# Technology Stack

## Runtime

| Component | Technology | ADR |
|-----------|------------|-----|
| Distribution (Claude) | Claude Code Plugin System | [ADR-002](../adrs/002-claude-code-plugin.md) |
| Distribution (Codex) | Codex repo-local plugin marketplace | [ADR-005](../adrs/005-dual-runtime-plugin-packaging.md) |
| Documentation | Markdown | [ADR-001](../adrs/001-markdown-docs.md) |
| Hooks | Shell scripts (Bash) | [ADR-003](../adrs/003-shell-hooks.md) |
| Build system | None | Simplicity - no compilation needed |

## Architecture

Blueprint Mode is a **zero-dependency plugin**:
- No runtime (Node.js, Python, etc.) required
- No build step or compilation
- No external services
- Files are plain Markdown and shell scripts

Per [ADR-005](../adrs/005-dual-runtime-plugin-packaging.md), Claude Code and Codex share a single plugin tree and a single `skills/` directory; runtime-specific packaging lives alongside it.

## File Structure

```
.agents/
└── plugins/
    └── marketplace.json          # Codex repo-local marketplace (ADR-005)
plugins/blueprint-mode/
├── .claude-plugin/
│   └── plugin.json               # Claude plugin manifest
├── .codex-plugin/
│   └── plugin.json               # Codex plugin manifest (ADR-005)
├── hooks/
│   ├── hooks.json                # Hook definitions
│   └── blueprint-context.sh      # Context injection script
└── skills/
    ├── _templates/               # Shared templates
    └── [skill]/                  # Individual skills
        └── SKILL.md              # Skill definition
```

## Commands

```bash
# Claude Code installation
/plugin marketplace add rickardp/blueprint-mode
/plugin install blueprint-mode

# Claude Code local development
claude --plugin-dir ./plugins/blueprint-mode

# Codex: reads .agents/plugins/marketplace.json from the repo root.
# After cloning, restart Codex and enable Blueprint Mode from the repo marketplace.
```

## Dependencies

**Runtime dependencies:** None

**Development dependencies:** None

**User requirements:**
- Claude Code or Codex installed (either runtime works — see [ADR-005](../adrs/005-dual-runtime-plugin-packaging.md))
- Bash shell (macOS/Linux native, Windows via WSL/Git Bash)
