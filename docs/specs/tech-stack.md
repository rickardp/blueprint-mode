# Technology Stack

## Runtime

| Component | Technology | ADR |
|-----------|------------|-----|
| Distribution | Claude Code Plugin System | [ADR-002](../adrs/002-claude-code-plugin.md) |
| Documentation | Markdown | [ADR-001](../adrs/001-markdown-docs.md) |
| Hooks | Shell scripts (Bash) | [ADR-003](../adrs/003-shell-hooks.md) |
| Build system | None | Simplicity - no compilation needed |

## Architecture

Blueprint Mode is a **zero-dependency plugin**:
- No runtime (Node.js, Python, etc.) required
- No build step or compilation
- No external services
- Files are plain Markdown and shell scripts

This simplicity is intentional - the plugin should work anywhere Claude Code works.

## File Structure

```
plugins/blueprint-mode/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── hooks/
│   ├── hooks.json           # Hook definitions
│   └── blueprint-context.sh # Context injection script
└── skills/
    ├── _templates/          # Shared templates
    └── [skill]/             # Individual skills
        └── SKILL.md         # Skill definition
```

## Commands

```bash
# Installation
/plugin marketplace add rickardp/blueprint-mode
/plugin install blueprint-mode

# Local development
claude --plugin-dir ./plugins/blueprint-mode
```

## Dependencies

**Runtime dependencies:** None

**Development dependencies:** None

**User requirements:**
- Claude Code installed
- Bash shell (macOS/Linux native, Windows via WSL/Git Bash)
