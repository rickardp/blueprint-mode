---
name: help
description: Explain Blueprint Mode and its commands. Use when the user asks how Blueprint works, which command to use, or where a kind of document belongs.
argument-hint: "[topic: commands|workflow|design|formats]"
allowed-tools: Read, Glob
---

# Blueprint Help

Answer the question asked. Use the material below; do not print all of it unless no topic was given. File formats are in `../_templates/TEMPLATES.md` (relative to this skill's directory); read the relevant section when asked about a format.

## What Blueprint is

Code shows what a system does. Blueprint records why, so agents and people can tell deliberate choices from expedient ones. Everything is Markdown in the repo, discovered by globbing.

| Document | Path | Purpose |
|----------|------|---------|
| ADRs | `docs/adrs/` | Architecture decisions with rationale |
| Feature specs | `docs/specs/features/` | What a feature does, its maturity and state |
| NFRs | `docs/specs/non-functional/` | Measurable targets |
| Boundaries | `docs/specs/boundaries.md` | Safe without asking / Ask first / Never |
| Patterns | `patterns/good/`, `patterns/bad/anti-patterns.md` | Examples to follow and avoid, any subject |
| UX decisions | `design/ux-decisions/` | UX choices with rationale (opt-in tree) |
| Design context | `DESIGN.md` | Cross-cutting design rules (community format) |

## Commands

| Command | Use when |
|---------|----------|
| `/blueprint-mode:setup-repo` | Starting a new project |
| `/blueprint-mode:onboard` | Adding Blueprint to an existing codebase, or upgrading a 1.x setup |
| `/blueprint-mode:onboard-design` | Opting in to UX decisions and `DESIGN.md` |
| `/blueprint-mode:decide [topic] because [reason]` | Recording a tech or UX decision |
| `/blueprint-mode:supersede ADR-NNN` | Replacing or retiring a decision |
| `/blueprint-mode:require [description]` | Adding a functional or non-functional requirement |
| `/blueprint-mode:good-pattern [path]` | Saving code as an example to follow |
| `/blueprint-mode:bad-pattern [description]` | Documenting something to avoid |
| `/blueprint-mode:capture` | Saving what the conversation decided |
| `/blueprint-mode:status`, `/blueprint-mode:list-adrs` | Seeing what is documented |
| `/blueprint-mode:validate` | Checking code and docs against documented intent |

## Workflow

Set up once with `onboard` or `setup-repo`. Record decisions as they happen with `decide`, requirements with `require`, corrections with `good-pattern` and `bad-pattern`. Run `capture` at the end of a session and `validate` before a release or after large changes. Change a decision with `supersede`; superseded decisions with no code references are deleted because git is the archive.

## Design

The design tree is separate from the code tree so design reviewers can own `design/**`. It only exists after `/blueprint-mode:onboard-design`. A cross-cutting rule ("never more than three colours on a screen") goes in `DESIGN.md`; one choice among alternatives ("modal over page for destructive confirmation") is a UX decision. Undocumented UI code is not evidence of intent; agents flag unclear UI with `// UX-TBD:` rather than inventing a reason.

## Where does X go

Tech or architecture choice: ADR. UX choice with alternatives: UX decision. Broad design rule: `DESIGN.md`. "Users can": feature spec. Latency or uptime target: NFR. Code to copy or avoid: patterns.
