# Blueprint Mode

<p align="center">
  <img src="./assets/logo-s.png" />
</p>

Spec-first development for AI-assisted coding.

> When code *is* the spec, AI rewrites your source of truth at will.
> Blueprint Mode keeps humans in control of system design — for maintainable AI-assisted development.

## The Problem

If AI can rewrite code freely, you lose stability:

- **Lost intent** — you can't tell if code reflects a conscious decision or AI just picking *something*
- **Lost memory** — AI forgets why you chose PostgreSQL over MongoDB last week
- **Lost consistency** — different architectural choices each session
- **Lost boundaries** — AI doesn't know your team's constraints and banned patterns

## How It Works

1. **Interview** — Claude asks about your project, tech choices, and *why* you made them
2. **Document** — Decisions become ADRs, patterns get captured, boundaries get set
3. **Develop** — AI follows your documented decisions consistently
4. **Evolve** — Update decisions with `/blueprint:decide` or `/blueprint:supersede`

## Quick Start

```bash
/plugin marketplace add rickardp/blueprint-mode
/plugin install blueprint-mode
```

<details>
<summary>Local development</summary>

```bash
git clone https://github.com/rickardp/blueprint-mode.git
claude --plugin-dir ./blueprint-mode/plugins/blueprint-mode
```
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
