---
name: blueprint:capture
description: Capture decisions and context from the current conversation into blueprint docs
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

**COMMAND:** Extract decisions, rationale, and context from the current conversation and persist them into the appropriate blueprint documents (ADRs, feature specs, patterns).

## Execute

1. **Scan** the current conversation for:
   - Architectural decisions (technology choices, design approaches, trade-offs discussed)
   - Requirements discovered or refined during discussion
   - Patterns agreed upon (good or bad)
   - Open questions that were resolved
   - Implementation state changes (progress, blockers, new constraints)

2. **If argument provided:** Focus capture on that specific topic only.

3. **Read** existing docs to avoid duplicates:
   - `docs/adrs/*.md` — existing decisions
   - `docs/specs/features/*.md` — existing feature specs
   - `patterns/good/` and `patterns/bad/anti-patterns.md` — existing patterns

4. **Classify** each captured item:

   | Type | Destination | Action |
   |------|-------------|--------|
   | New architectural decision | `docs/adrs/NNN-slug.md` | Create Draft ADR |
   | Refinement of existing decision | Existing ADR | Update (add context, resolve TODOs, promote Draft→Active) |
   | New feature/requirement | `docs/specs/features/slug.md` | Create with maturity: Exploring |
   | Refinement of existing feature | Existing feature spec | Update requirements, implementation state, maturity |
   | Implementation progress | Existing feature spec | Update Implementation State section |
   | Good pattern agreed on | `patterns/good/name.ext` | Create pattern file |
   | Anti-pattern identified | `patterns/bad/anti-patterns.md` | Append section |
   | Open question resolved | Existing spec or ADR | Remove TODO, fill in answer |

5. **Preview** — Show the user what will be captured before writing:
   ```
   Found N items to capture:

   1. [UPDATE] docs/specs/features/foo.md — Add implementation state, advance maturity to Building
   2. [CREATE] docs/adrs/005-caching-strategy.md — Draft ADR for Redis caching decision
   3. [UPDATE] docs/adrs/003-shell-hooks.md — Resolve TODO: add alternatives considered
   ```

6. **Confirm** — Ask: "Proceed with all, or select specific items?"

7. **Write** confirmed items using templates from `_templates/TEMPLATES.md`

8. **Report** what was captured and where

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
