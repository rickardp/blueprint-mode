---
name: blueprint:good-pattern
description: Capture good code or UI as a reusable example. Triages code patterns to patterns/good/ and UI patterns to design/patterns/good/.
argument-hint: "[file-path or description]"
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

# Capture Good Pattern

**COMMAND:** Extract a reusable example. If the design tree exists, triage code vs UI; otherwise file as a code pattern.

## Execute

1. **Parse** argument for file path or description
2. **Find** file (search if only description given)
3. **Detect tree availability** — Glob for `design/patterns/good/`. The design tree is **opt-in** — if it doesn't exist, this skill files everything to `patterns/good/`.
4. **Classify** as code pattern or UI pattern (see Triage below). UI classification is only available when the design tree exists.
5. **If strong UI signal but no design tree:** Pause and warn the user (see "Strong UI Signal Without Tree" below). Do NOT silently misfile UI under `patterns/`.
6. **Read** file content
7. **Create** pattern at the correct destination:
   - Code → `patterns/good/[name].[ext]`
   - UI (only if `design/` exists) → `design/patterns/good/[name].[ext]`
8. **Report** what was captured and which tree it landed in

## Triage: Code vs UI

The two trees are strictly separate. UI classification only fires when `design/` exists.

| Signal | Tree |
|--------|------|
| File extension `.tsx`/`.jsx`/`.vue`/`.svelte`/`.css`/`.scss`/`.html` | UI → `design/patterns/good/` (if tree exists) |
| Description mentions component, layout, form, button, modal, navigation, spacing, typography, color, motion, a11y | UI → `design/patterns/good/` (if tree exists) |
| File is a server route, repository, service, util, infra, build script | Code → `patterns/good/` |
| Description mentions API, database, auth, validation, error handling, server logic | Code → `patterns/good/` |

**If ambiguous** (e.g. a `.ts` file that controls UI logic) **and `design/` exists**: ask the user once — "Is this a code pattern (engineering reviewers) or a UI pattern (design reviewers)?" — and use that.

**If ambiguous and `design/` is missing**: file as a code pattern. The user can move it later by running `/blueprint:onboard-design` and re-capturing.

## Strong UI Signal Without Tree

If the file or description is clearly UI (extension is `.tsx`/`.jsx`/`.vue`/`.svelte`/`.css`/`.scss`, or description is dominantly visual/interaction-focused) **and** the `design/` tree does NOT exist:

1. **Do NOT silently file under `patterns/`.** UI patterns in the code tree become a content classification violation later.
2. **Warn the user, exactly once:**
   ```
   This looks like a UI pattern, but this repo has no `design/` tree.
   The design tree is opt-in to keep design and engineering review paths separate.

   Options:
   - Run `/blueprint:onboard-design` to set up the design tree, then re-run this command
   - File under `patterns/good/` anyway (you can move it later)
   - Cancel
   ```
3. Use `AskUserQuestion` to capture the choice.
4. If the user picks "File under patterns/good/ anyway": file there with a header note: `// Note: filed under code patterns because no design tree exists at capture time.`
5. If "Cancel" or no answer: stop and create nothing.

## Input Handling

| Input | Action |
|-------|--------|
| `/good-pattern src/repos/user.ts` | Code pattern — file in `patterns/good/` |
| `/good-pattern src/components/Button.tsx` | UI pattern — file in `design/patterns/good/` |
| `/good-pattern error handling in api` | Search code, file in `patterns/good/` |
| `/good-pattern modal focus trap` | Search UI, file in `design/patterns/good/` |
| `/good-pattern` | Ask for file path |

## Pattern Template

Same shape for both trees. Source of truth:
- Code patterns: `_templates/TEMPLATES.md` (`<!-- SECTION: good-patterns -->`)
- UI patterns: `_templates/TEMPLATES.md` (`<!-- SECTION: design-good-patterns -->`)

**Code pattern (links to ADRs):**

```[language]
/**
 * [Pattern Name]
 *
 * USE THIS PATTERN WHEN:
 * - [Situation where this applies]
 *
 * KEY ELEMENTS:
 * 1. [Important aspect]
 *
 * Related ADRs:
 * - [ADR-NNN](../../docs/adrs/NNN-name.md) - [Why this pattern]
 *
 * Source: [original file path]
 */

// --- Example Implementation ---

// ADR-NNN: [Brief reference to the decision]
[extracted code]
```

**UI pattern (links to UX decisions):**

```[language]
/**
 * [Pattern Name]
 *
 * USE THIS PATTERN WHEN:
 * - [UI situation where this applies]
 *
 * KEY ELEMENTS:
 * 1. [Important UI/UX aspect]
 *
 * Related UX decisions:
 * - [UX-NNN](../../ux-decisions/NNN-name.md) - [Why this pattern]
 *
 * Source: [original file path]
 */

// --- Example Implementation ---

// UX-NNN: [Brief reference to the decision]
[extracted UI code]
```

## Output

**Code pattern:**
```
Code pattern captured at patterns/good/[name].[ext]
```

**UI pattern:**
```
UI pattern captured at design/patterns/good/[name].[ext]
```

## Directory Structure

Create the destination directory if it doesn't exist (`patterns/good/` or `design/patterns/good/`). Never mix the two.
