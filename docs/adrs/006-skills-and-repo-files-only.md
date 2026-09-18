---
status: Active
date: 2026-09-13
---

# ADR-006: Skills and Repo Files Only, No Hooks or Injected Personas

## Context

Blueprint Mode 1.x shipped two hooks. A `UserPromptSubmit` hook injected mandatory execution rules and a 200 to 380 line format persona whenever a prompt mentioned a Blueprint skill, and injected a reference sheet whenever a prompt contained words like "adr" or "blueprint". A `PostToolUse` hook rewrote files after every Write to normalize heading synonyms. The generated `CLAUDE.md` told agents to read boundaries, feature specs, and patterns before every edit.

That design targeted models that needed to be pushed to act, to follow a format, and to avoid asking scope questions. Current models (Claude Fable and Opus 5, GPT-6 Astra) are post-trained to test their own work, handle ambiguity, and stop for approval only on real safety signals. OpenAI's guidance for GPT-6 Astra and Anthropic's for the Claude 5 family both say the same thing: precise triggers, progressive disclosure, conditional file routing instead of mandatory pre-reads, explicit autonomy grants, and the full scope stated once. Against that, the hooks were pure overhead: three copies of every format, a phrase blacklist, a plan-mode checkpoint next to a "create files now" rule, and a `jq` dependency plus a macOS-only `sed` flag in a plugin that calls itself zero-dependency.

Codex already ran the plugin without hooks, since its manifest exposes only `skills/`, which proved the hook-free path works.

## Options Considered

### Option 1: Keep the hooks, fix portability
- Pro: Deterministic vocabulary normalization survives
- Con: Keeps three copies of every format in sync
- Con: Keeps older-model scaffolding that now overconstrains
- Con: Claude-only behaviour diverges from Codex

### Option 2: Skills and repo files only
- Pro: One copy of each format in `_templates/TEMPLATES.md`; skills are short routers
- Pro: Identical behaviour on every runtime that loads `SKILL.md`
- Pro: No shell, no `jq`, nothing to keep portable
- Con: Format drift is caught by `/blueprint-mode:validate` rather than prevented on write

### Option 3: Keep only the auto-fix hook
- Pro: Smallest change
- Con: Still Claude-only, still shell portability work, and it only ran on Write, not Edit

## Decision

We chose **skills and repo files only**. The plugin is now `SKILL.md` files, one shared `TEMPLATES.md`, and the documents it writes into the user's repo. Skills state the scope once, ask only about missing content, and point at the template section they need. The generated agent instructions route conditionally ("read the ADR when a change touches a documented choice") and grant autonomy explicitly through a "Safe Without Asking" boundary section. Vocabulary drift is reported by `/blueprint-mode:validate`.

This supersedes ADR-003, which chose shell scripts for hooks. That file is deleted because nothing references it; git history is the archive.

## Consequences

**Positive:**
- Plugin shrinks from roughly 6,400 lines to under 1,000 with no loss of function
- No runtime, shell, or tool dependencies at all
- Guidance written for current model behaviour instead of against older behaviour
- Generated `CLAUDE.md` stops burning context on every edit

**Negative:**
- Heading synonyms in hand-written decisions are flagged later, not fixed on write
- Repos onboarded with 1.x keep the old mandatory checklist until `/blueprint-mode:onboard` is rerun
- Boundaries vocabulary changed: `## Always Do` became `## Safe Without Asking` and now holds autonomy grants rather than obligations; validation accepts the old heading and reports obligation-style bullets under it
- Prompts that merely mention ADRs no longer receive injected guidance; the generated agent instructions carry the routing instead
- The `blueprint-mode:*` subagent personas no longer exist

## Related

- Supersedes ADR-003 (shell hooks), deleted in this change
- [ADR-002](002-claude-code-plugin.md), [ADR-005](005-dual-runtime-plugin-packaging.md)
- [docs/specs/tech-stack.md](../specs/tech-stack.md)
- OpenAI, "Rethinking skills and prompts for GPT-6 Astra" (developers.openai.com/blog)
