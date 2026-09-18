# Technology Stack

| Component | Technology | ADR |
|-----------|------------|-----|
| Distribution (Claude) | Claude Code Plugin System | [ADR-002](../adrs/002-claude-code-plugin.md) |
| Distribution (Codex) | Codex repo-local plugin marketplace | [ADR-005](../adrs/005-dual-runtime-plugin-packaging.md) |
| Documentation | Markdown | [ADR-001](../adrs/001-markdown-docs.md) |
| Hooks | None | [ADR-006](../adrs/006-skills-and-repo-files-only.md) |
| Build system | None | |

## Architecture

Blueprint Mode is Markdown only: `SKILL.md` files, one shared `TEMPLATES.md`, and the documents the skills write into a user's repo. There is no runtime, no shell, no build step, and no external service. Claude Code and Codex share the single `skills/` directory ([ADR-005](../adrs/005-dual-runtime-plugin-packaging.md)).

## File Structure

```
.agents/plugins/marketplace.json  # Codex repo-local marketplace
.claude-plugin/marketplace.json   # Claude marketplace
plugins/blueprint-mode/
├── .claude-plugin/plugin.json    # Claude plugin manifest
├── .codex-plugin/plugin.json     # Codex plugin manifest
└── skills/
    ├── _templates/TEMPLATES.md   # Every file format, one copy
    └── [skill]/SKILL.md          # Short router: steps plus the template section to use
```

## Commands

```bash
# Claude Code
/plugin marketplace add rickardp/blueprint-mode
/plugin install blueprint-mode
claude --plugin-dir ./plugins/blueprint-mode      # local development

# Codex
codex plugin marketplace add rickardp/blueprint-mode
codex plugin marketplace add ./                   # local development, then restart Codex
```

## Dependencies

None at runtime or for development. Users need Claude Code or Codex.
