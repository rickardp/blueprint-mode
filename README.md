# Blueprint Mode

<p align="center">
  <img src="./assets/logo-s.png" />
</p>

Blueprint Mode is an attempt at creating a stable source of truth in the era of vibe coding and agentic AI assistants.

It attempts to solve the problem if maintainability in code repositories with large amounts of AI code while trying to
stay out of the way. The following axioms are what Blueprint Mode is built on:

> When code *is* the spec, AI rewrites your source of truth at will. We need a high level ground truth that is not changed on a whim.
> We want to keep humans in control of system design while letting AI deal with the details of the bulk of the code
> More time is spent *maintaining* a code base than writing the first version

## The Problem

### Code as the source of truth

This is what you typically get from vibe coding platforms like Lovable or Cursor (out of the box). Documentation is usually
in the form of a README file and code comments.

- **Lost intent** — you can't tell if code reflects a conscious decision or AI just picking *something*
- **Lost memory** — AI forgets why you chose PostgreSQL over MongoDB last week
- **Lost consistency** — different architectural choices each session
- **Lost boundaries** — difficult to set up constraints and coding practices

### Spec driven development and similar approaches

Traditional spec-driven development tries to solve the "code as truth" problem by creating detailed specifications before writing code. But this introduces its own set of problems:

- **Premature detail** — you are forced to focus on details that is not yet on top of your mind
- **High friction** — updating specs is tedious, so developers skip it or stop reading them entirely
- **Spec drift** — specifications become outdated as code evolves, creating a second source of truth that contradicts the first
- **Wrong abstraction level** — specs either become too detailed (duplicating code in English) or too vague (unhelpful)
- **No context for decisions** — specs say *what* but rarely *why* - this is important to know when they are outdated


## How It Works

1. **Interview** — Your AI assistant asks about your project, tech choices, and *why* you made them
2. **Document** — Decisions become ADRs, patterns get captured, boundaries get set
3. **Develop** — AI follows your documented decisions consistently
4. **Evolve** — Update decisions with `/blueprint:decide` or `/blueprint:supersede`

## Quick Start

### Claude Code

```bash
/plugin marketplace add rickardp/blueprint-mode
/plugin install blueprint-mode
```

### Codex

Codex reads repo-local plugin marketplaces from `.agents/plugins/marketplace.json`.
This repo now includes one that points at `plugins/blueprint-mode`.

After cloning the repo, restart Codex and enable the `Blueprint Mode` plugin from the
repo marketplace.

<details>
<summary>Local development</summary>

To run a locally checked out version of the plugin (useful during development):

```bash
git clone https://github.com/rickardp/blueprint-mode.git
cd blueprint-mode
claude --plugin-dir ./plugins/blueprint-mode
```

The `--plugin-dir` flag loads the plugin directly from the specified directory, **overriding any installed version** with the same name. This allows you to test changes immediately without reinstalling.

You can also use an absolute path:

```bash
claude --plugin-dir /path/to/blueprint-mode/plugins/blueprint-mode
```

</details>

<details>
<summary>Codex local development</summary>

Codex loads repo-local plugins from `$REPO_ROOT/.agents/plugins/marketplace.json`.
This repo ships a marketplace entry for `plugins/blueprint-mode`, so local development is:

```bash
git clone https://github.com/rickardp/blueprint-mode.git
cd blueprint-mode
# Restart Codex, then enable Blueprint Mode from the repo marketplace
```

Codex installs the plugin into its local cache and loads the installed copy from there,
so restart Codex after changing plugin metadata or skill files.

Codex currently reuses the shared `SKILL.md` files only. The existing
`plugins/blueprint-mode/agents/` directory remains Claude-oriented reference material for
now because Codex documents custom agents as repo/user configuration rather than as a
plugin-bundled surface.

</details>

## Commands

| Command | Purpose |
|---------|---------|
| `/blueprint:setup-repo` | Set up new repository with spec structure |
| `/blueprint:onboard` | Add spec structure to existing codebase |
| `/blueprint:require` | Add functional or non-functional requirements |
| `/blueprint:decide` | Record technology/architecture decisions as ADRs |
| `/blueprint:good-pattern` | Capture approved code patterns |
| `/blueprint:bad-pattern` | Document anti-patterns to avoid |
| `/blueprint:supersede` | Replace previous decisions with new ones |
| `/blueprint:list-adrs` | List all ADRs with status and summaries |
| `/blueprint:status` | Show overview of project's Blueprint structure |
| `/blueprint:validate` | Check code against documented patterns and decisions |
| `/blueprint:help` | Explain Blueprint features and available commands |

These Blueprint skills are now packaged for both Claude Code and Codex. Claude keeps the
native slash-command UX; Codex currently reuses the same `SKILL.md` files via the plugin
manifest and marketplace wiring added in this repo.

## Onboarding an existing codebase

```
/blueprint:onboard
````

Also, the onboarding pushes the limits for what a skill can really do, so on more complex cases it may be worth running the onboarding multiple times (it will fill in gaps if it skipped over some files in the first run).


## Setting up a new repo

```
/blueprint:setup-repo
````

Note that this functionality is in its early stages.

## What Gets Created

```
project/
├── docs/
│   ├── specs/
│   │   ├── product.md          # What, who, why
│   │   ├── features/           # Feature specifications (discovered via globbing)
│   │   │   └── [feature].md
│   │   ├── tech-stack.md       # Technology choices
│   │   ├── non-functional/     # NFRs by category (discovered via globbing)
│   │   │   └── [category].md   # Performance, security, scalability, etc.
│   │   └── boundaries.md       # Always / Ask First / Never rules
│   └── adrs/
│       ├── 001-runtime-choice.md
│       ├── 002-framework-choice.md
│       └── ...                 # One ADR per motivated decision (discovered via globbing)
├── patterns/
│   ├── good/
│   │   └── [name].[ext]        # Approved code examples
│   └── bad/
│       └── anti-patterns.md    # What NOT to do
└── CLAUDE.md                   # AI agent instructions
```

## Comparison

How Blueprint Mode differs from other AI development approaches:

| Aspect | Intent-Driven (AIDD) | Interface-Driven (Farrugia) | Blueprint Mode |
|--------|---------------------|----------------------------|----------------|
| Core question | "What do you want?" | "What's the interface?" | "Why did you choose this?" |
| Human role | Sets high-level goals | Defines formal grammar | Makes & explains decisions |
| AI role | Autonomous implementer | Strict spec follower | Consistency maintainer |
| Artifacts | Evolving code | Interface blueprints | ADRs + patterns |
| Philosophy | Adaptive, emergent | Formal, contractual | Stable, grounded |

## License

MIT
