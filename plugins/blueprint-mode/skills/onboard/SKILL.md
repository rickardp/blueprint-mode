---
name: blueprint:onboard
description: Onboard an existing repository to the spec-driven development structure. Can be run multiple times to refine and add to the documentation. Use when setting up or continuing to build docs/specs/, docs/adrs/, and patterns/.
disable-model-invocation: true
argument-hint: ""
allowed-tools:
  - Glob
  - Grep
  - Read
  - Write
  - Edit
  - Bash
  - AskUserQuestion
---

# Onboard Existing Repository

Set up or continue refining spec-driven development structure for a codebase.

**Invoked by:** `/blueprint:onboard`

## Principles

1. **Analyze first, ask second**: Discover what you can from the codebase before asking questions.
2. **Capture now, refine later**: Accept whatever information the user provides. Infer the rest.
3. **Never block**: User can exit at any point. Create artifacts with what you have.
4. **Incremental by design**: Onboarding can be run multiple times by different team members.
5. **Conservative dependencies**: Only add packages if explicitly requested or de facto standard.

## Process

**CRITICAL: Running `/blueprint:onboard` signals intent to create/improve Blueprint documentation.**
- Do NOT ask "Would you like to proceed?" or "Should I create the structure?"
- Do NOT offer options like "Full setup / ADRs only / Skip"
- Do NOT output questions as plain text - ALWAYS use the AskUserQuestion tool
- Do NOT end your response with an open-ended question - end with AskUserQuestion tool call
- DO present findings and IMMEDIATELY invoke AskUserQuestion for interview (same response)
- DO create the structure after gathering rationale

**TOOL USAGE: You MUST invoke the `AskUserQuestion` tool for all structured questions.**
When you see JSON examples in this skill, they are parameters for the AskUserQuestion tool - invoke it, don't output the JSON as text.

**FLOW: Present findings → Immediately invoke AskUserQuestion for gaps → Never stop with an open question**

### Step 1: Analyze the Codebase (Automatic)

**Before asking any questions**, gather everything you can from code AND existing documentation.

**Tool Preferences:**
- **File reading**: Use Claude's Read tool (not `cat`)
- **File finding**: Use Claude's Glob tool (not `find` or `ls`)
- **Content search**: Use Claude's Grep tool (not `grep` or `rg`)
- **Git operations**: Use Bash with bounded commands

#### 1a: Technical Detection

| Source | Information |
|--------|-------------|
| `package.json` / `pyproject.toml` / `go.mod` | Project name, dependencies, scripts |
| Dependencies | Runtime, framework, database drivers, test framework |
| Config files | Linting, TypeScript, build tools |
| `src/` structure | Feature areas, module organization |

#### 1b: Mine Existing Documentation (CRITICAL)

**Read ALL existing documentation to extract rationale before asking the user:**

| Document | Extract |
|----------|---------|
| `README.md` | Project vision, purpose, users, getting started |
| `CLAUDE.md` | Tech stack rationale, boundaries, patterns, commands |
| `docs/*.md` | Architecture decisions, design docs, API specs |
| `docs/adrs/` | Existing ADRs (don't duplicate) |
| `CONTRIBUTING.md` | Development workflow, coding standards |
| `ARCHITECTURE.md` | System design, component relationships |
| Code comments | Inline rationale for tech choices |

**Extraction patterns - look for:**
- "We use X because..." → Rationale for ADR
- "This project is for..." → Vision for product.md
- "Users include..." / "Audience:" → Users for product.md
- "Do not..." / "Never..." / "Always..." → Boundaries
- "The pattern for X is..." → Good patterns
- "Avoid..." / "Don't..." → Anti-patterns

**Track what you found:**
```
Extracted from existing docs:
- Runtime rationale: "Bun for speed" (from README)
- Framework rationale: "SST for AWS-native deployment" (from CLAUDE.md)
- Users: "Game operators, players" (from README)
- Boundaries: "Never commit .env" (from CONTRIBUTING.md)
```

#### 1c: Git History (optional, bounded)

- Quick scan: `git log --oneline -50 --since="30 days ago"`
- Look for: dependency additions, config changes, migrations
- Check commit messages for rationale: "Migrated to X because..."

### Step 2: Present Findings

Present what you discovered from both code AND existing documentation. Show what's already documented vs what's missing.

```
"Based on the codebase and existing documentation, I found:

**Project:** [name] - [description from README]

**Tech Stack:**
| Component | Detected | Rationale |
|-----------|----------|-----------|
| Runtime | Bun | "Speed and modern DX" ← from README |
| Framework | SST v3 | "AWS-native deployment" ← from CLAUDE.md |
| Database | DynamoDB | ❓ No rationale found |
| Auth | Cognito | ❓ No rationale found |
| Testing | Bun test | (inferred from scripts) |

**Already documented:**
- Vision: ✓ (from README)
- Users: ✓ Game operators, players (from README)
- Boundaries: ✓ Partial (from CLAUDE.md)
- ADRs: None exist yet

**Feature areas detected:**
- [common/api/backoffice/] - Backoffice API
- [common/api/player/] - Player API
- [etc.]

**Gaps to fill:**
- Why DynamoDB? (no rationale found)
- Why Cognito? (no rationale found)
- Success metrics (not documented)"
```

**CRITICAL: After presenting findings, IMMEDIATELY invoke AskUserQuestion for gaps. Do NOT ask "Would you like to proceed?" or any open-ended question.**

**If all rationale was found in existing docs:** Skip to Step 5 (Create Structure) - no interview needed.

**If gaps exist:** Immediately invoke AskUserQuestion (Step 3) with educated guesses for all gaps. Do NOT wait for user permission.

### Step 3: Gap-Driven Interview

**Only ask about information NOT found in existing documentation.**

#### 3a: Skip What's Already Documented

Before asking any question, check if the answer was already extracted in Step 1b:

| If Extracted | Action |
|--------------|--------|
| Rationale found in docs | Use it directly, don't ask |
| Users documented | Use them, don't ask |
| Boundaries documented | Merge with defaults, don't ask |
| Patterns documented | Extract them, don't ask |

**Only ask about genuine gaps** - tech choices without rationale, missing user info, etc.

#### 3b: ADR Questions (ONLY for tech without documented rationale)

For each technology **without documented rationale**, **INVOKE the AskUserQuestion tool** with contextual educated guesses.

**You MUST call the tool, not output text questions.**

**Generate options based on detected context:**

| Detected Context | Suggest These Rationales |
|------------------|--------------------------|
| DynamoDB + SST/Lambda | "Serverless fit" - scales with Lambda |
| DynamoDB + AWS stack | "AWS native" - best AWS integration |
| Cognito + AWS stack | "AWS native" - unified AWS auth |
| Cognito + serverless | "Managed auth" - no auth infra to manage |
| Bun + new project | "Performance" - fast runtime |
| Bun + TypeScript | "DX" - native TypeScript support |
| PostgreSQL + complex queries | "Relational needs" - complex data relationships |
| Redis + API | "Caching" - API response caching |

**Always include "Skip" as last option** - user can document later.

**Example with contextual options:**

```json
{
  "questions": [
    {
      "question": "Why was DynamoDB chosen as database?",
      "header": "DynamoDB",
      "options": [
        {"label": "Serverless fit", "description": "Scales naturally with Lambda/SST"},
        {"label": "Cost model", "description": "Pay-per-request fits usage pattern"},
        {"label": "AWS native", "description": "Best integration with Cognito/SST"},
        {"label": "Skip for now", "description": "I'll document this later"}
      ],
      "multiSelect": false
    },
    {
      "question": "Why was Cognito chosen for auth?",
      "header": "Cognito",
      "options": [
        {"label": "AWS native", "description": "Unified with DynamoDB/SST stack"},
        {"label": "Managed auth", "description": "No auth infrastructure to maintain"},
        {"label": "Mobile support", "description": "Good iOS/mobile SDK support"},
        {"label": "Skip for now", "description": "I'll document this later"}
      ],
      "multiSelect": false
    }
  ]
}
```

**Note:** Options are educated guesses based on detected stack (SST + DynamoDB + Cognito = AWS serverless pattern). User can always select "Other" to provide their own rationale.

**Batch up to 4 tech questions per AskUserQuestion call.**

**Response handling:**
- Selected option → Use as rationale for ADR (expand the short label into full sentence)
- "Skip for now" → Create ADR with `status: Draft` and `<!-- TODO: Add rationale -->`
- "Other" → Use their text verbatim as rationale

#### 3c: Product Context Questions (only if not found in docs)

**Skip this section if** vision, users, and metrics were extracted from README/CLAUDE.md.

If gaps remain, ask with **contextual options based on detected patterns:**

| Detected Pattern | Suggest These Users |
|------------------|---------------------|
| backoffice/ + player/ APIs | "Operators + Players" - B2B2C pattern |
| admin/ routes | "Internal admins" - back-office users |
| public API + auth | "Developers + End users" - platform pattern |
| single app, no admin | "End users" - consumer product |

**Example with contextual options:**

```json
{
  "questions": [
    {
      "question": "Who are the primary users of this system?",
      "header": "Users",
      "options": [
        {"label": "Operators + Players", "description": "B2B2C: operators manage, players consume"},
        {"label": "Internal team", "description": "Back-office tool for employees"},
        {"label": "Developers", "description": "API/platform for external devs"},
        {"label": "Skip for now", "description": "I'll document this later"}
      ],
      "multiSelect": false
    },
    {
      "question": "Any project-specific boundaries for AI agents?",
      "header": "Boundaries",
      "options": [
        {"label": "Use defaults", "description": "Standard safety rules are sufficient"},
        {"label": "Add rules", "description": "I have specific rules to add"},
        {"label": "Skip for now", "description": "I'll document this later"}
      ],
      "multiSelect": false
    }
  ]
}
```

**Note:** User options are educated guesses based on detected API structure (backoffice/ + player/ suggests B2B2C pattern).

**Response handling:**
- Selected user option → Add to product.md users section
- "Use defaults" → Create boundaries.md with standard defaults only
- "Add rules" → Follow up: "What rules should agents follow?" (plain text)
- "Skip for now" → Create with `<!-- TODO -->` markers

#### 3d: Feature Context (optional, only if not documented)

**Skip if** feature documentation already exists in docs/.

If feature areas were detected but not documented, offer to add context:

```json
{
  "questions": [{
    "question": "Would you like to add context to detected features?",
    "header": "Features",
    "options": [
      {"label": "Add context", "description": "Describe user stories for each"},
      {"label": "Auto-generate", "description": "Infer from code structure"},
      {"label": "Skip features", "description": "Don't create feature specs"}
    ],
    "multiSelect": false
  }]
}
```

**Response handling:**
- "Add context" → For each detected feature, ask: "What does [feature] do for users?"
- "Auto-generate" → Create feature specs with inferred overview, `<!-- TODO: Add user stories -->`
- "Skip features" → Don't create feature specs

#### Interview Summary

**If existing documentation is comprehensive:**
- All tech rationale found → Skip 3b entirely
- Vision/users/metrics found → Skip 3c entirely
- Features documented → Skip 3d entirely
- **If no gaps exist → Skip entire interview, proceed to Step 5**

**Always show what was extracted:**
```
"I extracted the following from existing documentation:
- Runtime rationale: 'Speed and modern DX' (from README)
- Framework rationale: 'AWS-native deployment' (from CLAUDE.md)
- Users: Game operators, players (from README)
- Boundaries: 5 rules (from CLAUDE.md)

Only asking about: DynamoDB rationale, Cognito rationale"
```

### Step 4: Early Exit (Always Available)

**At any point**, if user says "proceed", "that's enough", "let's go", or similar:

1. **Create structure immediately** with:
   - Detected values for known information
   - `<!-- Auto-inferred -->` markers for inferred sections
   - `<!-- TODO: Add details -->` for unknown sections

2. **Inform user:**
   ```
   "Created Blueprint structure with [N] auto-detected values.
   Run `/blueprint:onboard` again anytime to add more detail."
   ```

### Step 5: Create Structure

```
docs/
├── specs/
│   ├── product.md          # Vision, users, success metrics
│   ├── features/           # Feature specifications (discovered via globbing)
│   │   └── [feature].md    # Individual features (if discovered)
│   ├── non-functional/     # NFRs by category (discovered via globbing)
│   │   └── [category].md   # Performance, security, etc.
│   ├── tech-stack.md       # Technology decisions
│   └── boundaries.md       # Always / Ask / Never rules
├── adrs/
│   └── NNN-[decision].md   # One per tech decision
patterns/
├── good/
│   └── [extracted].ts      # Extracted code examples
└── bad/
    └── anti-patterns.md
```

**Note:** ADRs are discovered via globbing `docs/adrs/*.md`. No index file needed.

### Step 5a: Feature Discovery (Automatic)

When analyzing source structure:
1. Identify directories that represent features (e.g., `src/auth/`, `src/users/`)
2. Create `docs/specs/features/[feature].md` for each with:
   - Status: Active (if code exists)
   - Module: detected source directory
   - Overview: inferred from code

### Step 6: Create CLAUDE.md

Create or update `CLAUDE.md` using the template from `_templates/TEMPLATES.md` (section: `<!-- SECTION: claude-md -->`).

**Key sections to include:**
- Project Context (detected + interview)
- Tech Stack (from tech-stack.md)
- **CRITICAL: Pre-Edit Checklist** (mandatory instructions for agents)
- Documentation (directory reference table)
- Code Comments (traceability guidelines)
- Pattern Discovery (organic pattern capture)
- Commands (from detected scripts)

## File Templates

Use templates from [`_templates/TEMPLATES.md`](./../_templates/TEMPLATES.md).

| File | Source |
|------|--------|
| `docs/specs/product.md` | README + interview |
| `docs/specs/features/[feature].md` | Auto-detected from src/ structure |
| `docs/specs/tech-stack.md` | Auto-detected from dependencies |
| `docs/specs/boundaries.md` | Defaults + interview additions |
| `docs/adrs/NNN-*.md` | User-confirmed decisions |
| `patterns/good/*` | Extracted from existing code |
| `CLAUDE.md` | Template + detected values |

### Applying Templates

1. **Product spec**: Combine README content + any interview answers. Mark unknown sections with `<!-- TODO -->`.
2. **Tech stack**: Auto-populate from detected dependencies. Mark as `<!-- Auto-inferred from [source] -->`.
3. **Boundaries**: Use sensible defaults. Add project-specific rules only if user provides them.
4. **ADRs**: Create only for decisions user explicitly confirms. Use "Team preference / industry standard" as default rationale if none given.
5. **CLAUDE.md**: Fill from detected values. Include Pre-Edit Checklist.

## Step 7: Traceability Comments (Optional)

After creating ADRs, offer:
> "Should I add brief ADR reference comments to the relevant code files?"

If yes, add comments like:
```typescript
// ADR-003: Repository pattern for data access
```

Keep comments brief - just the reference, not the explanation.

## After Creation

1. **Report what was created:**
   ```
   "Blueprint structure created:
   - [N] specs (M auto-detected, K from interview)
   - [N] ADRs
   - [N] patterns

   Auto-inferred sections marked with <!-- Auto-inferred -->.
   Run /blueprint:onboard again to refine."
   ```

2. **Suggest next steps:**
   - `/blueprint:decide` - Record additional tech decisions
   - `/blueprint:require` - Add requirements
   - `/blueprint:good-pattern` - Capture approved patterns
   - `/blueprint:bad-pattern` - Document anti-patterns

3. Remind: "PR merge = approved"

## Continuing Sessions

When run again on an existing Blueprint structure:

1. **Detect existing state** from files (not frontmatter tracking)
2. **Show what exists and what's missing:**
   ```
   "Blueprint structure exists:
   - Specs: product.md, tech-stack.md, 3 features
   - ADRs: 4 active (Runtime, Framework, Database, Auth)
   - Patterns: 2 good, 1 anti-pattern

   **Missing or incomplete:**
   - [List any detected tech without ADRs]
   - [List specs with TODO markers]"
   ```

3. **Use AskUserQuestion to ask what to focus on:**

   ```json
   {
     "questions": [{
       "question": "What would you like to add or refine?",
       "header": "Focus",
       "options": [
         {"label": "Missing ADRs", "description": "Document rationale for [tech without ADR]"},
         {"label": "Refine specs", "description": "Fill in TODO markers in existing specs"},
         {"label": "Add patterns", "description": "Capture good/bad code patterns"},
         {"label": "Update bounds", "description": "Add agent boundary rules"}
       ],
       "multiSelect": true
     }]
   }
   ```

4. **Response handling:**
   - "Missing ADRs" → Run Step 3 interview for undocumented tech
   - "Refine specs" → Show specs with TODOs, ask for details
   - "Add patterns" → Ask which patterns to capture
   - "Update bounds" → Ask what rules to add

**Never ask whether to proceed** - running `/blueprint:onboard` signals intent to improve the documentation.

## Error Recovery

If user indicates a mistake after creation:
1. Acknowledge: "I can update or remove the created files"
2. Clarify: "What needs to change?"
3. Execute: Update or delete as needed
4. Confirm: "Files have been [updated/removed]"

## Examples

**CORRECT flow (findings + immediate AskUserQuestion in same response):**
```
User: /blueprint:onboard
