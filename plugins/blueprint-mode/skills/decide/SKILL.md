---
name: blueprint:decide
description: Record a technology, framework, or architectural decision as an ADR. Use when the user is making a tech choice, comparing options, or needs to document why a decision was made.
argument-hint: "[decision-topic]"
---

# Record Tech Decision

Record a technology or framework decision as an Architecture Decision Record (ADR).

**Invoked by:** `/blueprint:decide [decision]` or automatically when discussing tech choices.

## Principles

1. **Ask for rationale**: The "why" is valuable - always ask, but allow skip.
2. **Never block**: User can skip any question or say "proceed" at any point.
3. **Auto-scaffold**: Create Blueprint structure if it doesn't exist.
4. **Capture now, refine later**: Missing sections get "To be documented" markers.

## Process

### Step 1: Parse User Input

**Before asking ANY questions, extract ALL information from input.**

Use the parsing rules from `_templates/TEMPLATES.md` (Flexible Information Gathering section).

| Input | Extracts | Questions Needed |
|-------|----------|------------------|
| `/blueprint:decide` | Nothing | All questions |
| `/blueprint:decide Use React` | Decision only | Context, rationale |
| `/blueprint:decide PostgreSQL because team knows it` | Decision + rationale | None (create immediately) |
| `/blueprint:decide PostgreSQL over MySQL for ACID compliance` | Decision + alternative + context | None (create immediately) |
| `/blueprint:decide Redis for caching instead of Memcached` | Decision + purpose + alternative | Just rationale |

**Key signals to extract:**
- "because [X]" → Rationale
- "for [X]" / "we need [X]" → Context/Problem
- "over [X]" / "instead of [X]" → Alternative considered
- "team knows" / "familiar with" → Rationale: team experience

### Step 2: Auto-Scaffold (If Needed)

**Tool Preferences:**
- **File reading**: Use Claude's Read tool (not `cat`)
- **File finding**: Use Claude's Glob tool to find existing ADRs
- **File writing**: Use Claude's Write tool to create ADR files

Check if `docs/adrs/` exists using Glob.

**If it doesn't exist:**
1. Create `docs/adrs/` directory
2. Inform: "Created Blueprint ADR structure. Run `/blueprint:onboard` to add full project context."
3. Continue with recording the decision

**Get next ADR number:** Count existing `docs/adrs/*.md` files (excluding any index files).

### Step 3: Check for Existing Draft

Check for existing Draft ADR on the same topic.

If found:
> "I found a Draft ADR on this topic (ADR-NNN). Would you like to refine it or create a new one?"

### Step 4: Gather Missing Information

**Present all remaining questions in a single batch.**

If decision not provided:
> "What technology or approach did you decide on?"

Once decision is known, present remaining questions together:

```
"Recording ADR for [decision]. Quick questions (answer any, or 'create now'):

**Context:**
1. What problem does this solve?
2. What alternatives did you consider?

**Rationale:**
3. Why this choice over alternatives?
4. Any tradeoffs or downsides? [optional]

_(Say 'create now' to proceed with what you've shared)_"
```

**Shortcuts to accept:**
- "team knows it" / "team preference" → Use "Team familiarity with [technology]"
- "industry standard" / "best practice" → Use "De facto industry standard"
- "we need X" → Use as context directly

**If user exits early or skips:**
- Mark missing sections with `<!-- TODO: ... -->`
- Set `status: Draft`
- Inform: "Draft ADR created. Run `/blueprint:decide [topic]` again to add details."

### Step 5: Create ADR

Create at `docs/adrs/NNN-[slugified-title].md`

**Status rules:**
- All core sections filled → `status: Active`
- Any section has TODO marker → `status: Draft`

### Step 6: Report

**If Active:**
```
"ADR-NNN created at docs/adrs/NNN-title.md"
```

**If Draft:**
```
"Draft ADR-NNN created at docs/adrs/NNN-title.md
Missing: [list sections with TODOs]
Edit the file directly or run /blueprint:decide [topic] to complete."
```

## ADR Template

Use templates from `_templates/TEMPLATES.md`:

**Complete ADR (Active):**
```markdown
---
status: Active
date: [TODAY]
---

# ADR-[NNN]: [Choice] as [CATEGORY]

## Context
[What problem are we solving? Constraints?]

## Options Considered
### Option 1: [Alternative A]
- Pro: [advantage]
- Con: [disadvantage]

### Option 2: [Alternative B]
- Pro: [advantage]
- Con: [disadvantage]

## Decision
We chose **[CHOICE]** because [primary motivation].

## Consequences
**Positive:**
- [benefit 1]

**Negative:**
- [tradeoff 1]

## Related
- Tech stack overview: [docs/specs/tech-stack.md]
```

**Draft ADR (incomplete):**
```markdown
---
status: Draft
date: [TODAY]
---

# ADR-[NNN]: [Choice] as [CATEGORY]

## Context
<!-- TODO: Add context - what problem does this solve? -->

## Options Considered
<!-- TODO: Add alternatives that were considered -->

## Decision
We chose **[CHOICE]**.

<!-- TODO: Add rationale - why this choice? -->

## Consequences
<!-- TODO: Add positive and negative consequences -->
```

## Refining Draft ADRs

When user runs `/blueprint:decide` on a topic with an existing Draft ADR:
1. Read the existing ADR
2. Identify TODO sections
3. Ask about those specific sections
4. Update the ADR with new information
5. If all TODOs resolved, change `status: Draft` to `status: Active`

## If Superseding Another ADR

Use `/blueprint:supersede [ADR]` instead, which will:
1. Create new ADR with reference to old one
2. Update old ADR status to Superseded
3. Handle the cross-references

## Examples

**Full input:**
```
/blueprint:decide Use PostgreSQL because the team has 5 years experience with it and we need ACID compliance
```
→ Creates Active ADR immediately

**Minimal input:**
```
/blueprint:decide Use Redis for caching
```
→ Asks for rationale, creates Draft if skipped

**Interactive:**
```
User: /blueprint:decide
Assistant: "What technology or approach did you decide on?"
User: We're going with GraphQL
Assistant: "What problem does this solve?"
User: skip
Assistant: "What alternatives did you consider?"
User: REST, but we wanted better client flexibility
Assistant: "Why GraphQL specifically over REST?"
User: Clients can request exactly what they need, reduces over-fetching
Assistant: [Creates Active ADR with context marked TODO]
```

## Error Recovery

If user says "that was wrong" or needs changes:
- Offer to update or remove the ADR
- Updating preferred to preserve history
