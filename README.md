# Blueprint Mode

<p align="center">
  <img src="./assets/logo-s.png" />
</p>

> **2.x is skills and repo files only** — hooks and subagent personas are gone; see [Upgrading from 1.x](#upgrading-from-1x).

Blueprint Mode is an attempt at turning the repo into a stable intent record in the era of vibe coding and agentic AI assistants.

It attempts to solve the problem of maintainability in code repositories with large amounts of AI code while trying to
stay out of the way. The following axioms are what Blueprint Mode is built on:

> Code shows what-is, but not why-it-is. We need a high level ground truth that is not changed on a whim.
> We want to keep humans in control of system design while letting AI deal with the details of the bulk of the code
> More time is spent *maintaining* a code base than writing the first version

## The Problem

### Code alone as the source of truth

This is what you typically get from vibe coding platforms like Lovable or Cursor (out of the box). The running code shows
what exists, but the reason behind important choices is usually scattered across a README, comments, chat, or human memory.

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

1. **Interview** — Your AI assistant asks about your project, tech/design choices, and *why* you made them
2. **Document** — Decisions become ADRs or UX decisions, patterns get captured, boundaries get set, and `DESIGN.md` carries cross-cutting UI rules
3. **Develop** — AI follows your documented intent consistently while code remains canonical for what exists
4. **Evolve** — Tell the agent which decision to clarify, replace, or retire

## Quick Start

### Claude Code

```bash
claude plugin marketplace add rickardp/blueprint-mode
claude plugin install blueprint-mode
```

### Codex

```bash
codex plugin marketplace add rickardp/blueprint-mode
```

Then enable `Blueprint Mode` from the Codex plugin directory. In either runtime, ask naturally:
“Set up Blueprint in this repo.”

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

Codex also loads repo-local marketplaces from `$REPO_ROOT/.agents/plugins/marketplace.json`.
For local development against a working copy:

```bash
git clone https://github.com/rickardp/blueprint-mode.git
cd blueprint-mode
codex plugin marketplace add ./
# Restart Codex, then enable Blueprint Mode from the repo marketplace
```

Codex installs the plugin into its local cache and loads the installed copy from there,
so restart Codex after changing plugin metadata or skill files.

</details>

## Working with Blueprint

Describe the outcome you want. The agent selects the relevant skill; you do not need to know skill
names or invocation syntax. Selecting a skill does not authorize work beyond your request.

| Ask naturally | Result |
|---------------|--------|
| “Set up Blueprint in this repo.” | Add or upgrade engineering documentation |
| “Create a new TypeScript project with Blueprint.” | Scaffold a project and documentation |
| “Set up design intent capture.” | Enable UX decisions and optional design context |
| “Record our PostgreSQL choice because we need transactions.” | Capture a decision and its rationale |
| “Replace ADR-012 with this new approach.” | Rewrite ADR-012; explain the previous option and why it changed |
| “Users must be able to export their data.” | Record a requirement |
| “Save this implementation as an example to follow.” | Capture a good pattern |
| “Document why we should avoid this pattern.” | Capture an anti-pattern |
| “Save the decisions from this conversation.” | Persist agreed intent and progress |
| “Show our active architecture decisions.” | List relevant ADRs |
| “What has Blueprint documented?” | Summarize documentation status |
| “Check these changes against our decisions.” | Validate consistency |
| “How does Blueprint work?” | Explain the workflow |

The plugin is Markdown only: short `SKILL.md` routers plus one shared templates file, packaged
for both Claude Code and Codex from the same `skills/` directory. There are no hooks, shell
scripts, or dependencies. Skills are written for current models: they state the scope once, ask
only for rationale they cannot find, and the generated `CLAUDE.md` routes an agent to the right
document when a change touches it rather than demanding every file be read before every edit
(see [ADR-006](docs/adrs/006-skills-and-repo-files-only.md)).

### Changes in 2.1.2

Changed decisions are rewritten in place, keeping their number. `Options Considered` explains the
previously used option and why it changed. Retired records are removed after reference cleanup;
historical links do not keep obsolete files alive. Git history is the archive. Validation checks
the complete decision format and lifecycle, including temporary retention blockers.

### Changes in 2.1.1

Describe what you want in ordinary language; all skills support automatic selection. Requests to save
conversation intent use the same decision-writing workflow as direct requests, with conversation
scanning loaded only when needed. Requirements, patterns, and progress use their existing workflows.
Skill selection does not expand the user’s request, and new-project setup commits only when authorized.

### Reading architecture decisions

ADRs put the operational decision first: the choice, where it applies, constraints, and exceptions.
Routine implementation retrieves only the prefix through Decision, stopping before Context, and
follows it after checking status. Unclear applicability or proposed features and requirements that
may conflict or extend the decision's scope call for reading the full motivation, options, and
consequences before distinguishing a clarification from a conflict. Agents discover relevant
decisions through feature links, code references, and searches of applicability, including
repository-wide choices. Older ADRs require full reads until onboarding reorganizes
them without changing their meaning; unknown scope stays explicit.

### Upgrading to 2.1.0

In each repository, ask “Upgrade this repo’s Blueprint documentation.” This migrates ADRs to the
Decision-first layout and refreshes agent instructions. Existing rationale, status, and meaning are
preserved; uncertain scope is reported rather than inferred.

If `docs/specs/tech-stack.md` exists, onboarding verifies its content against the target repo’s
maintained documentation and checks incoming references. It suggests removal only when the file is
fully redundant, showing where its content is covered. Unique, conflicting, or uncertain content is
raised to the user instead. The file and its references remain intact until removal is authorized.

### Upgrading from 1.x

1. Reinstall the plugin (Codex loads a cached copy, so restart it).
2. Ask “Upgrade this repo’s Blueprint documentation.” It replaces the 1.x "Pre-Edit Checklist" in
   `CLAUDE.md` with conditional routing and inlined limits, and adds `maturity` and Implementation State to older
   feature specs.
3. In `boundaries.md`, `## Always Do` is now `## Safe Without Asking` and holds autonomy grants,
   not obligations. Drop "read X before Y" rules (routing now handles that), move "run lint
   before commit" style rules to the Commands section of `CLAUDE.md`, and keep what is genuinely
   safe to do unasked. Validation accepts the old heading and reports obligation-style
   bullets under it.
4. Removed with no replacement: the prompt hooks that injected rules when a prompt mentioned a
   skill or the word "ADR", the write hook that rewrote heading synonyms (validation
   reports them now), and the `blueprint-mode:*` subagent personas.

## Onboarding an existing codebase

> Set up Blueprint in this existing repository.

Also, the onboarding pushes the limits for what a skill can really do, so on more complex cases it may be worth running the onboarding multiple times (it will fill in gaps if it skipped over some files in the first run).


## Setting up a new repo

> Create a new project with Blueprint, using [stack] because [reasons].

Note that this functionality is in its early stages.

## What Gets Created

Blueprint keeps engineering and design intent in distinct repo paths so different reviewers can own different files via CODEOWNERS.

```
project/
├── DESIGN.md                       # Important adjacent design context (optional; not Blueprint structure)
├── docs/                          # CODE / ARCHITECTURE TREE
│   ├── specs/
│   │   ├── product.md             # What, who, why
│   │   ├── features/              # Feature specifications (discovered via globbing)
│   │   │   └── [feature].md
│   │   ├── non-functional/        # NFRs by category (discovered via globbing)
│   │   │   └── [category].md      # Performance, security, scalability, etc.
│   │   └── boundaries.md          # Safe Without Asking / Ask First / Never Do
│   └── adrs/
│       ├── 001-runtime-choice.md
│       └── ...                    # One ADR per motivated decision
├── patterns/                      # Pattern examples and anti-patterns (any subject)
│   ├── good/
│   │   └── [name].[ext]           # Approved examples
│   └── bad/
│       └── anti-patterns.md       # Anti-patterns to avoid
├── design/                        # DESIGN / UX TREE (OPT-IN — enabled by request)
│   └── ux-decisions/
│       └── NNN-[slug].md          # UX decisions (UX-NNN), independent numbering
└── CLAUDE.md                      # AI agent instructions
```

**Tree separation is strict.** UX decisions are NOT ADRs — they live in their own tree with independent numbering even though the document shape is similar.

**The design tree is opt-in.** Repository onboarding only sets up the code/architecture tree. To capture UX decisions, ask to set up design intent capture separately — it scaffolds the directories and can optionally surface a small number of candidate UX choices found in existing UI/code for the user, developer, or designer to confirm. Existing code is only a prompt for the conversation; Blueprint captures the why only when a human states it. Anything not covered there is captured later, on demand, by asking to record a decision.

**Deliberate vs coincidental UI.** The repo gives agents the same "is this deliberate?" coverage that ADRs give for architecture. Three layers answer the question for UI: `DESIGN.md` (cross-cutting design rules), `design/ux-decisions/` (per-decision rationale), and `// UX-TBD: [what's unclear]` comments to flag UI that has no governing decision yet — without inventing rationale. Documented UX decisions mean "this was intentional." Undocumented UI code is just implementation state; agents should not infer design rationale from it.

**`DESIGN.md` is the top-level design context, not part of the Blueprint structure.** A short living `DESIGN.md` at the repo root (Google Stitch / awesome-design-md format) holds cross-cutting design rules and prohibitions ("never use more than 3 colours on a screen"). It's a community convention Blueprint stays *compatible with* rather than owning — Design onboarding can scaffold a minimal stub when the user wants one, agents read it on every UI generation task, and authoring stays conversational. Blueprint avoids duplicating information that belongs in `DESIGN.md`: cross-cutting rules go there, per-decision rationale goes in `design/ux-decisions/`.

## Comparison

How Blueprint Mode differs from other AI development approaches:

| Aspect | Intent-Driven (AIDD) | Interface-Driven (Farrugia) | Blueprint Mode |
|--------|---------------------|----------------------------|----------------|
| Core question | "What do you want?" | "What's the interface?" | "Why did you choose this?" |
| Human role | Sets high-level goals | Defines formal grammar | Makes & explains decisions |
| AI role | Autonomous implementer | Strict spec follower | Consistency maintainer |
| Artifacts | Evolving code | Interface blueprints | ADRs + UX decisions + DESIGN.md + patterns |
| Philosophy | Adaptive, emergent | Formal, contractual | Stable, grounded |

## License

MIT
