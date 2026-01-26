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

## Onboarding an existing codebase

```
/plan
/blueprint:onboard
````

It is important that you run this in *plan* mode, otherwise Claude tends to race to implementation too early. Also, the onboarding
pushes the limits for what a skill can really do, so best results are usually had by running onboarding several times.


## Setting up a new repo

```
/plan
/blueprint:setup-repo
````

It is important that you run this in *plan* mode, otherwise Claude tends to race to implementation too early. Note that this
functionality is in its early stages.

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
