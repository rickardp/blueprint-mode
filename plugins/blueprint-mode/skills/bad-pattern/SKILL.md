---
name: blueprint:bad-pattern
description: Document a code anti-pattern to avoid. Use when the user identifies problematic code, technical debt, or says "don't do it this way" or "this is wrong".
argument-hint: "[description]"
---

# Mark Anti-Pattern

Document a code pattern to avoid, with the correct alternative.

**Invoked by:** `/blueprint:bad-pattern [description]` or when user criticizes a code approach.

## Principles

1. **Ask questions, allow skip**: Gather details, but never block.
2. **Auto-scaffold**: Create patterns/ structure if it doesn't exist.
3. **Capture now, refine later**: TODO markers for missing sections.
4. **Paired patterns**: Always try to document both "don't" and "do instead".

## Process

### Step 1: Parse User Input

**Before asking ANY questions, extract ALL information from input.**

Use the parsing rules from `_templates/TEMPLATES.md` (Flexible Information Gathering section).

| Input | Extracts | Questions Needed |
|-------|----------|------------------|
| `/blueprint:bad-pattern` | Nothing | All questions |
| `/blueprint:bad-pattern Using any type` | Description | Example, problems, correct approach |
| `/blueprint:bad-pattern Inline SQL in src/db.ts` | Description + location | Example, problems, correct approach |
| `/blueprint:bad-pattern any type - use unknown instead` | Description + correct approach | Example, problems |
| `/blueprint:bad-pattern SQL injection in legacy code, use parameterized queries` | Description + location hint + correct approach | Just example |

**Key signals to extract:**
- "in [path]" / "at [path]" → Location
- "use [X] instead" / "should be [X]" → Correct approach
- "causes [X]" / "leads to [X]" → Problems

### Step 2: Auto-Scaffold (If Needed)

**Tool Preferences:**
- Use Claude's Glob tool to check for patterns/ directory
- Use Claude's Read tool to view existing anti-patterns
- Use Claude's Write/Edit tool to update anti-patterns.md

Check if `patterns/bad/` exists.

**If it doesn't exist:**
1. Create `patterns/bad/` directory and `anti-patterns.md`
2. Inform: "Created patterns structure. Run `/blueprint:onboard` to add full project context."
3. Continue with documenting the anti-pattern

### Step 3: Gather Missing Information (Single Batch)

**Present all remaining questions in a single prompt:**

If description not provided:
> "What's the anti-pattern?"

Once description is known, present remaining questions together:

```
"Documenting anti-pattern: [description]. Quick details (answer any, or 'add now'):

**The Bad:**
1. Example code? (paste a snippet)
2. What problems does it cause?

**The Fix:**
3. What's the correct approach?

**Context:** [optional]
4. Where have you seen this? (file paths)
5. Severity? (Critical/High/Medium/Low) [default: Medium]

_(Say 'add now' to document with what you've shared)_"
```

**If user exits early or skips:**
- Mark missing sections with `<!-- TODO: ... -->`
- Document with what was provided
- Inform: "Anti-pattern documented. Edit the file to add missing details."

### Step 4: Document

Add to `patterns/bad/anti-patterns.md`

## Anti-Pattern Entry Template

See `_templates/TEMPLATES.md` (section: `<!-- SECTION: bad-patterns -->`) for the base template.

```markdown
## [Category]: [Short Description]

**Severity:** Critical | High | Medium | Low

### Don't Do This

```[language]
[bad code example]
<!-- TODO: Add bad code example if skipped -->
```

**Problems:**
- [Issue 1]
- [Issue 2]
<!-- TODO: Add problems if skipped -->

### Do This Instead

```[language]
[good code example]
<!-- TODO: Add correct approach if skipped -->
```

**Why:**
[Explanation of why the good pattern is better]

**Related:**
- Good pattern: [link to patterns/good/ if exists]
- ADR: [link if relevant]
- Found in: [file paths where this was seen]
```

## Severity Levels

- **Critical**: Security vulnerability, data loss risk, crashes
- **High**: Performance issues, hard-to-debug problems, maintenance burden
- **Medium**: Code smell, harder to read/maintain, inconsistent
- **Low**: Style preference, minor inefficiency

## Examples

**Full input:**
```
User: /blueprint:bad-pattern Using any type in TypeScript - use unknown instead, causes type safety loss
Assistant: [Documents immediately - description, correct approach, and problems all provided]
```

**Batched questions:**
```
User: /blueprint:bad-pattern Inline SQL
Assistant: "Documenting anti-pattern: Inline SQL. Quick details (answer any, or 'add now'):

**The Bad:**
1. Example code?
2. What problems does it cause?

**The Fix:**
3. What's the correct approach?

_(Say 'add now' to document with what you've shared)_"

User: Causes SQL injection, use parameterized queries instead
Assistant: [Documents anti-pattern with provided info, marks example as TODO]
```

**Quick exit:**
```
User: /blueprint:bad-pattern console.log for errors
Assistant: "Documenting anti-pattern: console.log for errors. Quick details..."
User: add now
Assistant: [Documents with TODOs for missing details]
```

## After Creation

1. Confirm: "Anti-pattern documented in `patterns/bad/anti-patterns.md`"
2. If TODOs: "Missing: [list]. Edit the file to add details."
3. Offer: "Should I search the codebase for other instances?"
   - Use Claude's Grep tool with extracted patterns
   - Report: "Found [N] occurrences"
4. Suggest: "Use `/blueprint:good-pattern` to capture the correct approach in detail"

## Error Recovery

If user needs changes, offer to update or remove the anti-pattern entry.
