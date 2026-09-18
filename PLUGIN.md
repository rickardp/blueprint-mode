# Building the Blueprint Mode Plugin

Documentation for developers and maintainers of the Blueprint Mode plugin.

## Plugin Structure

```
blueprint-mode/
├── .claude-plugin/marketplace.json        # Claude marketplace definition
├── .agents/plugins/marketplace.json       # Codex repo marketplace definition
├── plugins/blueprint-mode/
│   ├── .claude-plugin/plugin.json         # Claude plugin manifest
│   ├── .codex-plugin/plugin.json          # Codex plugin manifest (points at skills/)
│   └── skills/
│       ├── _templates/TEMPLATES.md        # Every file format, one copy
│       ├── setup-repo/SKILL.md
│       ├── onboard/SKILL.md
│       ├── onboard-design/SKILL.md
│       ├── decide/SKILL.md
│       ├── supersede/SKILL.md
│       ├── require/SKILL.md
│       ├── good-pattern/SKILL.md
│       ├── bad-pattern/SKILL.md
│       ├── capture/SKILL.md
│       ├── status/SKILL.md
│       ├── list-adrs/SKILL.md
│       ├── validate/SKILL.md
│       └── help/SKILL.md
├── PLUGIN.md
└── README.md
```

The plugin is Markdown only. There are no hooks, agents, scripts, or dependencies ([ADR-006](docs/adrs/006-skills-and-repo-files-only.md)). Both runtimes load the same `skills/` directory ([ADR-005](docs/adrs/005-dual-runtime-plugin-packaging.md)).

## Skill File Format

```markdown
---
name: skill-name                 # bare; Claude Code exposes it as /blueprint-mode:skill-name
description: What it does and when to use it, in one or two sentences.
argument-hint: "[shape of the argument]"
disable-model-invocation: true   # only for skills that write many files or change history
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Skill Title

One line of purpose, then which `../_templates/TEMPLATES.md` section holds the format.

## Steps

1. Numbered, imperative steps.

## Output

The exact shape of the final report.
```

Rules, from `docs/specs/boundaries.md`:

- Under 80 lines. The skill is a router; the format lives in the templates file.
- State the scope once. Ask only for content that cannot be found, accept "skip", write `TBD`.
- No plan-mode checkpoints, no confirmation before creating files, no MUST or CRITICAL language.
- The description says when the skill should be used, precisely enough that it does not fire on tangential prompts.

## Installation

```bash
# Claude Code
/plugin marketplace add rickardp/blueprint-mode
/plugin install blueprint-mode

# Claude Code, local development
claude --plugin-dir ./plugins/blueprint-mode

# Codex
codex plugin marketplace add rickardp/blueprint-mode

# Codex, local development (restart Codex afterwards)
codex plugin marketplace add ./
```

## Updating Skills

1. Edit the `SKILL.md`, or the template section it points at.
2. Test with `claude --plugin-dir ./plugins/blueprint-mode`; restart Codex and confirm the repo marketplace still loads.
3. Bump the version in `plugins/blueprint-mode/.claude-plugin/plugin.json`, `plugins/blueprint-mode/.codex-plugin/plugin.json`, and `.claude-plugin/marketplace.json`.
4. Commit and push.

## Skills Reference

| Skill | Purpose |
|-------|---------|
| setup-repo | Scaffold a new project with the Blueprint structure |
| onboard | Add the Blueprint code tree to an existing codebase |
| onboard-design | Opt in to the design tree and `DESIGN.md` |
| decide | Record a decision as an ADR, UX decision, or `DESIGN.md` rule |
| supersede | Replace or deprecate a decision |
| require | Add a functional or non-functional requirement |
| good-pattern | Save an approved example |
| bad-pattern | Document an anti-pattern |
| capture | Persist what the conversation decided |
| status | Show what is documented |
| list-adrs | List ADRs by status |
| validate | Check code and docs against documented intent |
| help | Explain Blueprint and its commands |
