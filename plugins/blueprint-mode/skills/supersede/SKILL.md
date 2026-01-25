---
name: blueprint:supersede
description: Replace or deprecate a previous architectural decision. Use when the user wants to change a tech choice, retire a decision, or remove functionality without replacement.
argument-hint: "[ADR-number]"
disable-model-invocation: true
---

# Supersede or Deprecate Decision

Replace a previous architectural decision with a new one, or deprecate it entirely.

**Invoked by:** `/blueprint:supersede [ADR]` or when user discusses changing/removing a previous decision.

## Principles

1. **Three options**: Replace, Mark Outdated (decide replacement later), or Deprecate
2. **Never block**: Allow skip on optional questions
3. **History preserved**: Old ADRs are updated, never deleted
4. **Use globbing**: Find ADRs via file system, no index needed

## Process

### Step 1: Find the ADR

Use Claude's built-in tools:
- **Glob tool**: Find ADR files with `docs/adrs/*.md`
- **Read tool**: View ADR contents

If no ADRs exist: "No ADRs found. Use `/blueprint:decide` to create your first decision."

### Step 2: Understand Intent

**First, try to detect intent from user input:**

| User says | Intent detected |
|-----------|-----------------|
| "replace with [X]" / "switching to [X]" | Replace → extract new choice |
| "outdated" / "wrong" / "not sure yet" | Mark outdated |
| "removing" / "deprecated" / "gone" / "no longer needed" | Deprecate |

**If intent unclear, use AskUserQuestion:**

```json
{
  "questions": [{
    "question": "What's happening with ADR-[NNN] ([title])?",
    "header": "Action",
    "options": [
      {"label": "Replace", "description": "Switching to a new technology"},
      {"label": "Outdated", "description": "This is wrong, replacement TBD"},
      {"label": "Deprecate", "description": "Removing entirely, no replacement"}
    ],
    "multiSelect": false
  }]
}
```

**Response handling:**
- "Replace" → Replacement Flow
- "Outdated" → Outdated Flow
- "Deprecate" → Deprecation Flow
- "Other" → Parse text for intent signals (e.g., "switching to [X]" = Replace), ask clarifying question if still unclear

---

## Replacement Flow (Supersede)

### 1. Read existing ADR

Understand the context and current decision.

### 2. Gather information (allow skip)

1. "What's replacing this?" (required)
2. "Why the change?" (ask - can skip)
3. "Any migration notes?" (optional)

### 3. Create new ADR

Get next number by counting `docs/adrs/*.md` files.

Include:
- Reference to superseded ADR in Context
- "Supersedes: ADR-NNN" in Related section
- Migration notes if provided

### 4. Update OLD ADR frontmatter

```yaml
---
status: Superseded
date: [original date]
superseded_by: NNN-new-decision
---
```

## New ADR Template (for replacement)

See `_templates/TEMPLATES.md` (section: `<!-- SECTION: adr-template -->`) for the base ADR template.

```markdown
---
status: Active
date: [TODAY]
---

# ADR-[NNN]: [New Decision Title]

## Context

Previously, we used [old approach] (see ADR-[OLD]).

[Why we're changing - or TODO marker if skipped]

## Decision

We will use **[new choice]** because [reason].

## Migration

[How to migrate - or TODO marker if skipped]

## Consequences

**Positive:**
- [benefit]

**Negative:**
- [tradeoff]

## Related

- Supersedes: [ADR-OLD](./OLD-title.md)
```

---

## Outdated Flow (New)

Use when the decision is outdated but replacement isn't decided yet.

### 1. Ask for context (optional)

> "Why is this outdated? (skip if you want to add this later)"

### 2. Update ADR frontmatter

```yaml
---
status: Outdated
date: [original date]
outdated_date: [TODAY]
outdated_reason: [reason or "To be documented"]
replacement: TBD
---
```

### 3. Add notice to ADR body

```markdown
> **Marked outdated on [TODAY]:** [Reason or "Replacement pending"]
>
> This decision needs to be replaced. See replacement ADR when created.
```

### After marking outdated

1. Confirm: "ADR-NNN marked as Outdated"
2. Inform: "Run `/blueprint:supersede [NNN]` again when you're ready to create the replacement"
3. Suggest: "Or use `/blueprint:decide` to create a new decision that supersedes this one"

---

## Deprecation Flow

Use when retiring a decision without replacement (removing the capability entirely).

### 1. Ask for reason (allow skip)

> "Why is this being deprecated?"

If skipped → Use "No longer needed"

### 2. Update ADR frontmatter

```yaml
---
status: Deprecated
date: [original date]
deprecated_date: [TODAY]
deprecated_reason: [reason]
---
```

### 3. Add deprecation notice

```markdown
> **Deprecated on [TODAY]:** [Reason]
>
> This decision is no longer active. [Cleanup notes if any]
```

---

## Examples

**Replace:**
```
User: /blueprint:supersede ADR-002
Assistant: "Replace, mark outdated, or deprecate?"
User: Replace with GraphQL
Assistant: "Why the change from REST?"
User: Better client flexibility
Assistant: [Creates new ADR, updates old one]
```

**Mark outdated:**
```
User: /blueprint:supersede ADR-003
Assistant: "Replace, mark outdated, or deprecate?"
User: Mark outdated - we know Redis isn't right but haven't picked the replacement
Assistant: [Marks as Outdated with replacement: TBD]
```

**Deprecate:**
```
User: /blueprint:supersede ADR-005
Assistant: "Replace, mark outdated, or deprecate?"
User: Deprecate - we removed caching entirely
Assistant: [Marks as Deprecated]
```

## After Completion

**For Replacement:**
1. Confirm: "ADR-[NEW] created, ADR-[OLD] marked as Superseded"
2. Inform: "Old ADR preserved for history"

**For Outdated:**
1. Confirm: "ADR-[NNN] marked as Outdated"
2. Inform: "Create replacement with `/blueprint:decide` when ready"

**For Deprecation:**
1. Confirm: "ADR-[NNN] marked as Deprecated"
2. Suggest: "Should I help identify related code to remove?"

Remind: "PR merge = approved"

## Error Recovery

If user indicates a mistake after completion:
1. Acknowledge: "I can revert the status changes"
2. Clarify: "What needs to change?"
3. Execute: Revert frontmatter status or update as needed
4. Confirm: "ADR status has been [reverted/updated]"
