---
name: blueprint:decide
description: Record a decision (architectural or UX) with rationale. Triages tech vs UX vs requirements into the right document type and tree.
argument-hint: "[topic] [because reason]"
allowed-tools:
  - Glob
  - Grep
  - Read
  - Write
  - Edit
  - AskUserQuestion
  - EnterPlanMode
  - ExitPlanMode
---

# Record Decision

**COMMAND:** Capture a decision with its rationale. Triage between architectural decisions (ADRs), UX decisions, feature specs, and NFRs — write to the correct tree.

## Execute

1. **Parse** argument for topic and rationale
2. **Detect tree availability** — Glob for `design/ux-decisions/` (or any `design/` subdirectory). Design tree is **opt-in** — if it doesn't exist, this skill behaves as ADR-only.
3. **Classify** each concern in the input (see Classification below). UX classification is only available when the design tree exists.
4. **If strong UX signal but no design tree:** Pause and warn the user (see "Strong UX Signal Without Tree" below). Do NOT silently misfile UX content as an ADR.
5. **If mixed or misclassified:** Separate concerns into their document types
6. **Check** the relevant directory for existing decisions (create dir if needed):
   - Architectural → `docs/adrs/`
   - UX (only if `design/` exists) → `design/ux-decisions/`
7. **Detect** conflicts with existing decisions in the same tree
8. **Create** file(s) per concern type
9. **Report** what was created and where

## Classification

Before creating files, classify each distinct concern in the input:

| Signal | Type | Destination | Available |
|--------|------|-------------|-----------|
| Tech choice, library, infra, runtime/framework/database, code-level design pattern, "[X] over [Y]" technical | Architectural | ADR (`docs/adrs/NNN-[slug].md`) | Always |
| User flow, navigation choice, "modal vs page", confirmation pattern, copy/voice, empty/error/loading state, interaction model, layout, visual hierarchy, motion, a11y trade-off | UX | UX decision (`design/ux-decisions/NNN-[slug].md`) | Only if `design/` tree exists |
| "users can", feature behavior, workflow, user story | Functional | Feature spec (`docs/specs/features/`) | Always (redirect to `/blueprint:require`) |
| Latency, throughput, uptime, encryption, SLA, scalability target | Non-functional | NFR (`docs/specs/non-functional/`) | Always (redirect to `/blueprint:require`) |

**Tree separation is strict.** UX decisions live in `design/ux-decisions/`, NEVER in `docs/adrs/`. Different reviewers own each tree.

**Design tree is opt-in.** If `design/` does not exist in the repo, do NOT route anything as a UX decision — even if the input looks like one. See "Strong UX Signal Without Tree" below.

**If input mixes types:**
1. Extract the architectural decision → create ADR
2. Extract the UX decision (only if tree exists) → create UX decision (separate numbering, separate file)
3. Extract functional requirements → suggest `/blueprint:require`
4. Extract NFR targets → suggest `/blueprint:require`
5. Report all files created

**If input is purely functional or non-functional** (no decision rationale):
- Inform: "This is a [functional/non-functional] requirement, not a decision."
- Create the appropriate spec file instead (use templates from `_templates/TEMPLATES.md`)
- Suggest: "Use `/blueprint:require` for future requirements."

**If classification is ambiguous** (e.g. a choice that's both technical and UX-facing) **and `design/` exists**:
- Ask the user once: "Is this primarily a tech/architecture decision (engineering reviewers) or a UX decision (design reviewers)?"
- File in the chosen tree.

**If classification is ambiguous and `design/` is missing**: file as ADR. The user can always re-file later by running `/blueprint:onboard-design` and `/blueprint:supersede`.

## Strong UX Signal Without Tree

If the input clearly looks like a UX decision (e.g. mentions modal vs page, confirmation pattern, navigation, copy/voice, empty state, motion, interaction model) **and** the `design/` tree does NOT exist:

1. **Do NOT silently file as an ADR.** UX rationale in `docs/adrs/` becomes a content classification violation later.
2. **Warn the user, exactly once:**
   ```
   This looks like a UX/design decision, but this repo has no `design/` tree.
   The design tree is opt-in to keep design and engineering review paths separate.

   Options:
   - Run `/blueprint:onboard-design` to set up the design tree, then re-run this command
   - File as ADR anyway (you can move it later with `/blueprint:supersede`)
   - Cancel
   ```
3. Use `AskUserQuestion` to capture the choice.
4. If the user picks "File as ADR anyway": file as ADR with a note in the Context section: `Note: this captures UX rationale but is filed as ADR because no design tree exists. Move with /blueprint:supersede after running /blueprint:onboard-design.`
5. If "Cancel" or no answer: stop and create nothing.

## Input Parsing

| Input | Action |
|-------|--------|
| `/decide PostgreSQL because team knows it` | Create ADR immediately |
| `/decide PostgreSQL` | Ask for rationale |
| `/decide` | Ask what to document |

## Conflict Detection

Search ONLY the relevant tree (architectural conflicts in `docs/adrs/`, UX conflicts in `design/ux-decisions/`).

If new decision conflicts with existing one in the same tree:
- Architectural: "ADR-003 documents PostgreSQL. Is this replacing it?"
- UX: "UX-005 documents using a modal for confirmation. Is this replacing it?"
- Options: Yes (supersede) / No (different purpose) / Cancel

## Templates

**Source of truth:** `_templates/TEMPLATES.md`
- Architectural decisions: `<!-- SECTION: adr-template -->`
- UX decisions: `<!-- SECTION: ux-decision-template -->`

### ADR (`docs/adrs/NNN-[slug].md`)

```markdown
---
status: Active
date: YYYY-MM-DD
---

# ADR-NNN: [Choice] as [CATEGORY]

## Context
[What problem are we solving?]

## Options Considered
### Option 1: [Alternative]
- Pro: [advantage]
- Con: [disadvantage]

## Decision
We chose **[CHOICE]** because [primary motivation].

## Consequences
**Positive:**
- [benefit]

**Negative:**
- [tradeoff]

## Related
- Tech stack: [docs/specs/tech-stack.md](../specs/tech-stack.md)
```

### UX Decision (`design/ux-decisions/NNN-[slug].md`)

Same shape, **different title prefix and tree**.

```markdown
---
status: Active
date: YYYY-MM-DD
---

# UX-NNN: [Choice] for [Context]

## Context
[User problem / interaction tension]

## Options Considered
### Option 1: [Alternative]
- Pro: [advantage]
- Con: [disadvantage]

## Decision
We chose **[CHOICE]** because [primary motivation].

## Consequences
**Positive:**
- [benefit]

**Negative:**
- [tradeoff]

## Related
- Related UX decisions: [UX-NNN]
```

**Status values:** Draft (emerging, iterate freely), Active (settled), Superseded (replaced), Deprecated (retired)

**Prefer Draft first.** When the user is still exploring options or rationale is thin, create as Draft. Don't force a premature Active status — decisions are meant to evolve.

### Numbering

ADR and UX decision numbers are **independent**. Get the next number by globbing the relevant directory:
- ADRs: `docs/adrs/*.md` → next number after the highest
- UX decisions: `design/ux-decisions/*.md` → next number after the highest

### Format Enforcement (CRITICAL)

**MANDATORY:** Use the exact format above. DO NOT deviate.

| DO NOT use | USE instead |
|------------|-------------|
| `## Status` with "Accepted" in body | YAML frontmatter `status: Active` |
| `**Benefits:**` | `**Positive:**` |
| `**Trade-offs:**` | `**Negative:**` |
| `## References` | `## Related` |
| Filing UX decision in `docs/adrs/` | File in `design/ux-decisions/` |
| `# ADR-NNN` for a UX decision | `# UX-NNN` |
| `# UX-NNN` for an architectural decision | `# ADR-NNN` |

**Before writing:** Verify YAML frontmatter, title format (ADR-NNN vs UX-NNN), destination tree, and all sections match the template.

## Output

**Architectural decision:**
```
Created ADR-NNN at docs/adrs/NNN-technology.md
```

**UX decision:**
```
Created UX-NNN at design/ux-decisions/NNN-slug.md
```

**Mixed input (triaged across both trees):**
```
Triaged input into 3 concerns:
- ADR-NNN: [architectural decision] → docs/adrs/NNN-slug.md
- UX-NNN: [UX decision] → design/ux-decisions/NNN-slug.md
- Feature: [feature name] → docs/specs/features/slug.md (linked to ADR-NNN)
```

**Redirected (no decision rationale):**
```
This is a functional requirement, not a decision.
Created feature spec at docs/specs/features/slug.md
Tip: Use /blueprint:require for future requirements.
```

If rationale missing, mark as Draft with TBD.
