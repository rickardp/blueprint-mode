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

### Step 3: Check for Existing ADRs

#### 3a: Check for Draft on Same Topic

Check for existing Draft ADR on the same topic.

If found:
```json
{
  "questions": [{
    "question": "Found Draft ADR-NNN on this topic. What would you like to do?",
    "header": "Existing",
    "options": [
      {"label": "Refine it", "description": "Complete the existing draft ADR"},
      {"label": "Create new", "description": "Start fresh with a new ADR"}
    ],
    "multiSelect": false
  }]
}
```

#### 3b: Check for Conflicting Decision (CRITICAL)

**Detect when new decision contradicts an existing Active ADR.**

| New Decision | Conflicts With |
|--------------|----------------|
| DynamoDB | Existing "PostgreSQL as database" ADR |
| React | Existing "Vue as frontend framework" ADR |
| Bun | Existing "Node.js as runtime" ADR |
| Auth0 | Existing "Cognito as auth" ADR |

**Detection logic:**
1. Read existing ADRs in `docs/adrs/`
2. Extract the decision category (database, runtime, framework, auth, etc.)
3. Check if new decision is in the same category as an existing Active ADR
4. If conflict found, ask user:

```json
{
  "questions": [{
    "question": "ADR-003 already documents PostgreSQL as database. Is DynamoDB replacing it?",
    "header": "Conflict",
    "options": [
      {"label": "Yes, supersede", "description": "Mark PostgreSQL ADR as superseded, create DynamoDB ADR"},
      {"label": "No, additional", "description": "This is a separate use case (e.g., caching vs primary DB)"},
      {"label": "No, mistake", "description": "I didn't mean to conflict, cancel this"}
    ],
    "multiSelect": false
  }]
}
```

**Response handling:**
- "Yes, supersede" → Use `/blueprint:supersede` flow: create new ADR, mark old as Superseded
- "No, additional" → Create new ADR with clarifying context (ask: "What's this database for?")
- "No, mistake" → Cancel, don't create anything

**Category detection patterns:**

| Category | Keywords in ADR Title/Decision |
|----------|-------------------------------|
| Database | PostgreSQL, MySQL, DynamoDB, MongoDB, Redis, SQLite |
| Runtime | Node.js, Bun, Deno, Python, Go, Rust |
| Framework | React, Vue, Angular, Next.js, Express, FastAPI, SST |
| Auth | Cognito, Auth0, Firebase Auth, Clerk, custom JWT |
| Hosting | Vercel, AWS, GCP, Azure, Cloudflare |
| ORM | Prisma, Drizzle, TypeORM, Sequelize |

### Step 4: Gather Missing Information

**Use AskUserQuestion with contextual educated guesses based on the decision.**

If decision not provided:
> "What technology or approach did you decide on?"

Once decision is known, use AskUserQuestion with **educated guesses based on the tech**:

#### 4a: Generate Contextual Options

| Decision Type | Suggest These Rationales |
|---------------|--------------------------|
| **Databases** | |
| PostgreSQL | "ACID compliance", "Team expertise", "Complex queries" |
| DynamoDB | "Serverless fit", "AWS native", "Scale requirements" |
| MongoDB | "Schema flexibility", "Document model fit", "Rapid iteration" |
| Redis | "Caching needs", "Session storage", "Real-time features" |
| **Frameworks** | |
| React | "Team expertise", "Ecosystem/libraries", "Component model" |
| Next.js | "SSR/SEO needs", "Full-stack simplicity", "Vercel deployment" |
| Express | "Simplicity", "Team expertise", "Flexibility" |
| SST/Serverless | "AWS native", "Pay-per-use", "Managed infra" |
| **Runtimes** | |
| Node.js | "Team expertise", "Ecosystem", "Hiring pool" |
| Bun | "Performance", "Modern DX", "Native TypeScript" |
| Deno | "Security model", "Modern standards", "TypeScript native" |
| **Auth** | |
| Cognito | "AWS native", "Managed service", "Mobile SDK" |
| Auth0 | "Feature-rich", "Easy integration", "Social logins" |
| Custom JWT | "Full control", "No vendor lock-in", "Simple needs" |

#### 4b: Ask with AskUserQuestion

```json
{
  "questions": [
    {
      "question": "Why was PostgreSQL chosen?",
      "header": "PostgreSQL",
      "options": [
        {"label": "Team expertise", "description": "Team has strong PostgreSQL experience"},
        {"label": "ACID compliance", "description": "Need transactional guarantees"},
        {"label": "Complex queries", "description": "Advanced SQL features needed"},
        {"label": "Skip for now", "description": "I'll document this later"}
      ],
      "multiSelect": false
    }
  ]
}
```

**Note:** Options are educated guesses based on common reasons for choosing that technology. User can always select "Other" to provide their own rationale.

#### 4c: Follow-up Questions (only if needed)

If rationale was provided but context/alternatives are missing, ask:

```json
{
  "questions": [
    {
      "question": "What alternatives were considered?",
      "header": "Alternatives",
      "options": [
        {"label": "MySQL", "description": "Another relational option"},
        {"label": "DynamoDB", "description": "NoSQL alternative"},
        {"label": "No others", "description": "This was the obvious choice"},
        {"label": "Skip for now", "description": "I'll document this later"}
      ],
      "multiSelect": true
    }
  ]
}
```

**Note:** Alternative suggestions are based on the decision category (database → other databases).

**Response handling:**
- Selected option → Use as rationale/alternatives for ADR
- "Skip for now" → Create ADR with `status: Draft` and `<!-- TODO: Add rationale -->`
- "Other" → Use their text verbatim
- "No others" → Note "No formal alternatives evaluation" in ADR

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

**Full input (no questions needed):**
```
User: /blueprint:decide Use PostgreSQL because the team has 5 years experience with it and we need ACID compliance
Assistant: [Creates Active ADR immediately - rationale was provided]
```

**Minimal input (uses AskUserQuestion):**
```
User: /blueprint:decide Use Redis for caching
Assistant: [Uses AskUserQuestion:
  Question: "Why was Redis chosen for caching?"
  Options: "Performance" | "Simplicity" | "Team expertise" | "Skip for now"]
User: [Selects "Performance"]
Assistant: [Creates Active ADR with rationale "High performance caching with sub-millisecond latency"]
```

**Interactive with educated guesses:**
```
User: /blueprint:decide GraphQL
Assistant: [Uses AskUserQuestion:
  Question: "Why was GraphQL chosen?"
  Options: "Client flexibility" | "Reduce over-fetching" | "Type safety" | "Skip for now"]
User: [Selects "Client flexibility"]
Assistant: [Uses AskUserQuestion:
  Question: "What alternatives were considered?"
  Options: "REST" | "gRPC" | "No others" | "Skip for now"]
User: [Selects "REST"]
Assistant: [Creates Active ADR with GraphQL chosen over REST for client flexibility]
```

**User provides custom rationale:**
```
User: /blueprint:decide DynamoDB
Assistant: [Uses AskUserQuestion with educated guesses]
User: [Selects "Other" and types: "We needed single-digit millisecond latency at any scale"]
Assistant: [Creates Active ADR with user's custom rationale]
```

**Conflict detection (supersede flow):**
```
User: /blueprint:decide DynamoDB
Assistant: [Detects existing ADR-003 "PostgreSQL as database"]
Assistant: [Uses AskUserQuestion:
  Question: "ADR-003 already documents PostgreSQL as database. Is DynamoDB replacing it?"
  Options: "Yes, supersede" | "No, additional" | "No, mistake"]
User: [Selects "Yes, supersede"]
Assistant: [Creates ADR-007 for DynamoDB, marks ADR-003 as Superseded with reference to ADR-007]
```

**Conflict detection (additional use case):**
```
User: /blueprint:decide Redis
Assistant: [Detects existing ADR-003 "PostgreSQL as database"]
Assistant: [Uses AskUserQuestion about conflict]
User: [Selects "No, additional"]
Assistant: "What's Redis for in this project?"
User: Caching API responses
Assistant: [Creates ADR for "Redis as caching layer" - no conflict with PostgreSQL as primary DB]
```

## Error Recovery

If user says "that was wrong" or needs changes:
- Offer to update or remove the ADR
- Updating preferred to preserve history
