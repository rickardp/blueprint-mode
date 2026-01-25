---
name: blueprint:good-pattern
description: Capture a good code pattern as a reusable example. Use when the user identifies code worth emulating, wants to standardize an approach, or says "this is how we should do it".
argument-hint: "[file-path or description]"
---

# Capture Good Pattern

Mark code as a good example others should follow.

**Invoked by:** `/blueprint:good-pattern [file or description]` or when user praises a code approach.

## Principles

1. **Ask questions, allow skip**: Gather context, but never block.
2. **Auto-scaffold**: Create patterns/ structure if it doesn't exist.
3. **Flexible naming**: Use descriptive names, not rigid conventions.
4. **Capture now, refine later**: Add explanation comments later if needed.

## Process

### Step 1: Parse User Input

**Before asking ANY questions, extract ALL information from input.**

Use the parsing rules from `_templates/TEMPLATES.md` (Flexible Information Gathering section).

| Input | Extracts | Next Step |
|-------|----------|-----------|
| `/blueprint:good-pattern src/repos/user.ts` | File path | Read file, ask what makes it good |
| `/blueprint:good-pattern error handling in src/api/` | Description + location hint | Search for files, offer matches |
| `/blueprint:good-pattern our repository pattern` | Description only | Search codebase, offer matches |
| `/blueprint:good-pattern` | Nothing | Ask for file path or description |

**Key signals to extract:**
- "in [path]" / "at [path]" / "from [path]" → Location hint for search
- "the way we [X]" / "how we [X]" → Pattern description for search
- Direct file paths → Read immediately

### Step 2: Auto-Scaffold (If Needed)

**Tool Preferences:**
- Use Claude's Glob tool to locate files
- Use Claude's Read tool to view file contents
- Use Claude's Write tool to create pattern files
- Avoid bash `find` or `cat`

Check if `patterns/` directory exists.

**If it doesn't exist:**
1. Create `patterns/good/` directory
2. Inform: "Created patterns structure. Run `/blueprint:onboard` to add full project context."
3. Continue with capturing the pattern

### Step 3: Locate and Gather Information

**If file path was provided:** Read the file and ask:

```
"Capturing pattern from [file]. Quick details (answer any, or 'capture now'):

1. Which part to capture? [default: entire file if small]
2. What makes this a good pattern? When should others use it?

_(Say 'capture now' to proceed with defaults)_"
```

**If only description provided:** Try to find the file first:

1. **Search codebase** using Glob based on description keywords:
   - "error handling" → `src/**/*error*`, `src/**/*handler*`
   - "repository pattern" → `src/**/*repository*`, `src/**/*repo*`
   - "authentication" → `src/**/*auth*`

2. **Offer matches using AskUserQuestion** (if 2-4 files found):

   ```json
   {
     "questions": [{
       "question": "Which file contains the pattern?",
       "header": "File",
       "options": [
         {"label": "errorHandler", "description": "src/utils/errorHandler.ts"},
         {"label": "errors", "description": "src/api/errors.ts"},
         {"label": "middleware", "description": "src/middleware/errorMiddleware.ts"}
       ],
       "multiSelect": false
     }]
   }
   ```

   **Note:** Use abbreviated names for labels (max ~15 chars). Full path goes in description.

   **If more than 4 files match:**
   Show top 3 most relevant + users can select "Other" to provide custom path.

3. **Ask for path** (if 0-1 matches):
   ```
   "Couldn't find files matching [description]. What's the file path?"
   ```
   Or if exactly 1 match, confirm it directly.

**Response handling:**
- Selected option → Use that file path
- "Other" → User provides custom path in text

**Never block on file path if description is rich enough to search.**

### Step 4: Extract and Document

Copy relevant code to `patterns/good/[name].[ext]`

### Naming

Use descriptive names based on what the pattern does:

**Good names:**
- `user-repository.ts` - from the original filename
- `error-handling.ts` - describes the pattern
- `api-validation.ts` - describes the purpose
- `auth-middleware.ts` - component name

**Avoid rigid conventions** - the name should be clear, not formulaic.

### Step 5: Create Pattern File

See `_templates/TEMPLATES.md` (section: `<!-- SECTION: good-patterns -->`) for the base template.

```[language]
/**
 * [Pattern Name]
 *
 * USE THIS PATTERN WHEN:
 * - [Situation 1]
 * - [Situation 2]
 * <!-- TODO: Add usage guidance if skipped -->
 *
 * KEY ELEMENTS:
 * 1. [Important aspect 1]
 * 2. [Important aspect 2]
 *
 * Related ADRs:
 * - [ADR-NNN](../../docs/adrs/NNN-name.md) - [Why this pattern]
 *
 * Source: [original file path]
 */

// --- Example Implementation ---

[extracted code]
```

## Examples

**With file path:**
```
User: /blueprint:good-pattern src/repositories/user.repository.ts
Assistant: "Capturing pattern from src/repositories/user.repository.ts. Quick details:

1. Which part to capture? [default: entire file]
2. What makes this a good pattern?

_(Say 'capture now' to proceed)_"

User: capture now
Assistant: [Creates pattern with TODO for guidance]
```

**With description (search helps find file):**
```
User: /blueprint:good-pattern The error handling in our API layer
Assistant: [Uses AskUserQuestion with file options:
- "errorHandler" (src/api/errorHandler.ts)
- "errors" (src/api/middleware/errors.ts)
- "apiErrors" (src/utils/apiErrors.ts)]

User: [Selects "errorHandler"]
Assistant: "Capturing pattern from src/api/errorHandler.ts..."
```

**Quick capture with context:**
```
User: /blueprint:good-pattern src/utils/logger.ts - clean wrapper around winston
Assistant: [Creates pattern immediately, uses description as usage guidance]
```

## After Creation

1. Confirm: "Pattern captured at `patterns/good/[name].[ext]`"
2. If TODOs: "Add usage guidance by editing the file."
3. Suggest: "Use `/blueprint:bad-pattern` to document what NOT to do"

## Error Recovery

If user needs changes after creation, offer to update or replace the pattern file.
