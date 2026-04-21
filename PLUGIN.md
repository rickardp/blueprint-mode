# Building the Blueprint Mode Plugin

Documentation for developers and maintainers of the Blueprint Mode plugin.

## Plugin Structure

```
blueprint-mode/
├── .claude-plugin/
│   └── marketplace.json          # Claude marketplace definition
├── .agents/
│   └── plugins/
│       └── marketplace.json      # Codex repo marketplace definition
├── plugins/
│   └── blueprint-mode/
│       ├── .codex-plugin/
│       │   └── plugin.json       # Codex plugin manifest
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin manifest
│       └── skills/
│           ├── _templates/
│           │   └── TEMPLATES.md  # Shared file templates
│           ├── setup-repo/SKILL.md
│           ├── onboard/SKILL.md
│           ├── require/SKILL.md
│           ├── decide/SKILL.md
│           ├── good-pattern/SKILL.md
│           ├── bad-pattern/SKILL.md
│           ├── supersede/SKILL.md
│           ├── status/SKILL.md
│           ├── list-adrs/SKILL.md
│           ├── validate/SKILL.md
│           └── help/SKILL.md
├── PLUGIN.md
└── README.md
```

## Marketplace Manifest

The `.claude-plugin/marketplace.json` defines the marketplace:

```json
{
  "name": "blueprint-mode",
  "owner": { "name": "rickardp" },
  "plugins": [
    {
      "name": "blueprint-mode",
      "source": "./plugins/blueprint-mode",
      "description": "Spec-driven development with documented decision rationale"
    }
  ]
}
```

Codex uses the repo-local `.agents/plugins/marketplace.json`:

```json
{
  "name": "blueprint-mode-local",
  "interface": { "displayName": "Blueprint Mode Local" },
  "plugins": [
    {
      "name": "blueprint-mode",
      "source": { "source": "local", "path": "./plugins/blueprint-mode" },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    }
  ]
}
```

## Plugin Manifest

Each plugin has `.claude-plugin/plugin.json`:

```json
{
  "name": "blueprint-mode",
  "description": "Spec-driven development with documented decision rationale",
  "version": "1.0.0"
}
```

Codex packaging lives alongside it at `.codex-plugin/plugin.json` and points at the
existing `skills/` directory instead of introducing a second skill tree.

The existing `plugins/blueprint-mode/agents/` directory is not currently wired into the
Codex plugin package. Current Codex docs describe custom agents as project/user config
under `.codex/agents/` or `~/.codex/agents/`, not as a documented plugin-bundled
component, so these files remain Claude-oriented/shared reference material for now.

## Skill File Format

Each skill is a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: skill-name
description: One-line description shown in skill discovery
---

# Skill Title

**Invoked by:** `/blueprint:skill-name` or natural language triggers

## Process

[Step-by-step instructions for Claude to follow]

## Templates

[File templates to create]
```

## Installation

### Option 1: Plugin Marketplace (Recommended)

```bash
# Add the marketplace
/plugin marketplace add rickardp/blueprint-mode

# Install the plugin
/plugin install blueprint-mode
```

### Option 2: Local Development

```bash
git clone https://github.com/rickardp/blueprint-mode.git
claude --plugin-dir ./blueprint-mode/plugins/blueprint-mode
```

### Codex Local Development

Codex reads the repo-local `.agents/plugins/marketplace.json`, copies the plugin from
`./plugins/blueprint-mode`, and loads the installed copy from its plugin cache after a restart.

## Verification

After installation, Claude skills appear as:

```
/blueprint:setup-repo
/blueprint:onboard
/blueprint:require
/blueprint:decide
/blueprint:good-pattern
/blueprint:bad-pattern
/blueprint:supersede
/blueprint:status
/blueprint:list-adrs
/blueprint:validate
/blueprint:help
```

In Codex, the same bundled `skills/` directory is exposed through the plugin rather than
through Claude slash commands.

## Updating Skills

1. Edit the relevant `SKILL.md` file in `plugins/blueprint-mode/skills/`
2. Test locally with `claude --plugin-dir ./plugins/blueprint-mode`
3. Restart Codex to validate that the repo marketplace still loads the plugin cleanly
4. Bump version in both `plugins/blueprint-mode/.claude-plugin/plugin.json` and `plugins/blueprint-mode/.codex-plugin/plugin.json`
5. Commit and push changes

## Skills Reference

| Skill | File | Purpose |
|-------|------|---------|
| setup-repo | [SKILL.md](plugins/blueprint-mode/skills/setup-repo/SKILL.md) | Set up new repository with spec structure |
| onboard | [SKILL.md](plugins/blueprint-mode/skills/onboard/SKILL.md) | Add spec structure to existing codebase |
| require | [SKILL.md](plugins/blueprint-mode/skills/require/SKILL.md) | Add functional or non-functional requirements |
| decide | [SKILL.md](plugins/blueprint-mode/skills/decide/SKILL.md) | Record technology/architecture decisions |
| good-pattern | [SKILL.md](plugins/blueprint-mode/skills/good-pattern/SKILL.md) | Capture approved code patterns |
| bad-pattern | [SKILL.md](plugins/blueprint-mode/skills/bad-pattern/SKILL.md) | Document anti-patterns to avoid |
| supersede | [SKILL.md](plugins/blueprint-mode/skills/supersede/SKILL.md) | Replace or deprecate previous decisions |
| status | [SKILL.md](plugins/blueprint-mode/skills/status/SKILL.md) | Show overview of Blueprint structure |
| list-adrs | [SKILL.md](plugins/blueprint-mode/skills/list-adrs/SKILL.md) | List all ADRs with status and summaries |
| validate | [SKILL.md](plugins/blueprint-mode/skills/validate/SKILL.md) | Check codebase against patterns and ADRs |
| help | [SKILL.md](plugins/blueprint-mode/skills/help/SKILL.md) | Explain Blueprint features and commands |

## Shared Templates

The `_templates/TEMPLATES.md` file contains shared file templates used by multiple skills:
- Product spec, tech stack, boundaries templates
- ADR discovery (via globbing) and individual ADR templates
- Pattern file templates
- CLAUDE.md template with code comment guidelines

Skills reference these templates rather than duplicating them. When updating a template, changes apply to all skills that use it.
