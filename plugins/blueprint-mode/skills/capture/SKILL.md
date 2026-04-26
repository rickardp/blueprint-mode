---
name: blueprint:capture
description: Capture decisions and context from the current conversation into blueprint docs (both code and design trees)
argument-hint: "[optional: specific topic to capture]"
allowed-tools:
  - Glob
  - Grep
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

# Capture Context

**COMMAND:** Extract decisions, rationale, and context from the current conversation and persist them into the appropriate blueprint documents — across both the code/architecture tree and the design/UX tree.

## Execute

1. **Detect tree availability** — Glob for `design/ux-decisions/`. The design tree is **opt-in**. If it doesn't exist, this skill ONLY classifies into the code/architecture tree (ADRs, feature specs, patterns). UX decisions are skipped — never silently filed as ADRs.

2. **Scan** the current conversation for:
   - Architectural decisions (tech choices, code-level approaches, trade-offs)
   - **UX decisions** (only if `design/` exists): interaction model, navigation, modal vs page, copy/voice, empty/error states, motion
   - Requirements discovered or refined during discussion
   - Patterns agreed upon (any subject — code, schema, UI)
   - Open questions that were resolved
   - Implementation state changes (progress, blockers, new constraints)

3. **If argument provided:** Focus capture on that specific topic only.

4. **If design content was discussed but `design/` doesn't exist:** Note this in the preview. Don't capture it. Suggest: *"This conversation also covered [N] UX decisions. The design tree isn't set up — run `/blueprint:onboard-design` to capture those next session."*

5. **Read** existing docs to avoid duplicates:
   - `docs/adrs/*.md` — existing architectural decisions
   - `docs/specs/features/*.md` — existing feature specs
   - `patterns/good/` and `patterns/bad/anti-patterns.md` — existing patterns
   - `design/ux-decisions/*.md` — existing UX decisions (if tree exists)

6. **Classify** each captured item — **respect tree separation**, never file design content under `docs/` or code content under `design/`. Design destinations are only valid when `design/` exists:

   | Type | Destination | Action |
   |------|-------------|--------|
   | New architectural decision | `docs/adrs/NNN-slug.md` | Create Draft ADR |
   | Refinement of existing ADR | Existing ADR | Update (add context, resolve TODOs, promote Draft→Active) |
   | New UX decision | `design/ux-decisions/NNN-slug.md` | Create Draft UX decision |
   | Refinement of existing UX decision | Existing UX decision | Update |
   | New feature/requirement | `docs/specs/features/slug.md` | Create with maturity: Exploring |
   | Refinement of existing feature | Existing feature spec | Update requirements, implementation state, maturity |
   | Implementation progress | Existing feature spec | Update Implementation State section |
   | Good pattern agreed on (any subject) | `patterns/good/name.ext` | Create pattern file |
   | Anti-pattern identified (any subject) | `patterns/bad/anti-patterns.md` | Append section |
   | Open question resolved | Existing spec / ADR / UX decision | Remove TODO, fill in answer |

7. **Preview** — Show the user what will be captured before writing. If design content was scanned but skipped due to missing tree, list those skipped items separately:
   ```
   Found N items to capture:

   1. [UPDATE] docs/specs/features/foo.md — Add implementation state, advance maturity to Building
   2. [CREATE] docs/adrs/005-caching-strategy.md — Draft ADR for Redis caching decision

   Skipped (design tree not set up — run /blueprint:onboard-design to capture these):
   - 1 UX decision (modal vs full page for confirmations)
   ```

8. **Confirm** — Ask: "Proceed with all, or select specific items?"

9. **Write** confirmed items using templates from `_templates/TEMPLATES.md`

10. **Report** what was captured and where (and what was skipped)

## Rules

- **Draft by default** for new ADRs — conversation decisions are emerging, not final
- **Never overwrite** existing content without showing the diff
- **Update > Create** — prefer updating existing docs over creating new ones
- **Skip obvious** — don't capture things already documented or derivable from code
- **Implementation State is first-class** — always update the Implementation State section of affected feature specs

## Output

```
Captured from conversation:

- Created docs/adrs/005-caching-strategy.md (Draft)
- Updated docs/specs/features/notifications.md:
  - Maturity: Exploring → Building
  - Added 2 requirements
  - Updated implementation state: "Database schema designed"
- Updated docs/adrs/003-shell-hooks.md: resolved 1 TODO

Context is now persisted. Safe to start a new session.
```
