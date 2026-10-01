---
name: help
description: Explain Blueprint Mode and its workflows. Use when the user asks how Blueprint works, how to get started, or where a kind of document belongs.
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

## Natural-language requests

Users describe the outcome; the agent selects the skill. Explain workflows without requiring skill names or command syntax. Skill selection does not authorize additional work.

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

## Workflow

Ask to set up or upgrade Blueprint once. State decisions and reasons as they arise, and ask to record requirements or patterns. Ask to save agreed intent from a conversation or check changes against documented decisions. Changed decisions are rewritten in place with their number preserved; Options Considered explains the previous option and why it changed. Git preserves earlier contents and retired decisions; unresolved conflicts remain explicit.

## Design

The design tree is separate from the code tree so design reviewers can own `design/**`. It exists only when the user has requested design intent capture. A cross-cutting rule ("never more than three colours on a screen") goes in `DESIGN.md`; one choice among alternatives ("modal over page for destructive confirmation") is a UX decision. Undocumented UI code is not evidence of intent; agents flag unclear UI with `// UX-TBD:` rather than inventing a reason.

## Where does X go

Tech or architecture choice: ADR. UX choice with alternatives: UX decision. Broad design rule: `DESIGN.md`. "Users can": feature spec. Latency or uptime target: NFR. Code to copy or avoid: patterns.
