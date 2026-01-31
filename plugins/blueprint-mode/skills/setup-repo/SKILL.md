---
name: blueprint:setup-repo
description: Set up a new repository with spec-driven development structure from scratch. Use when creating a new project and the user wants to establish specs, ADRs, and patterns from the beginning.
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
  - EnterPlanMode
  - ExitPlanMode
---

# Set Up New Repository

Create a new project with spec-driven development structure from scratch.

**Invoked by:** `/blueprint:setup-repo` or `/blueprint:setup-repo [tech stack description]`

## Principles

1. **Ask questions, allow skip**: The user has the knowledge - ask for it, but never block.
2. **Parse input first**: Extract what user already provided before asking.
3. **Early exit always available**: User can say "proceed" at any point.
4. **Unit tests from the start**: Every project gets a testing setup.
5. **Conservative dependencies**: Only add packages if explicitly requested or de facto standard.

**TOOL USAGE: You MUST invoke the `AskUserQuestion` tool for all structured questions.**
When you see JSON examples in this skill, they are parameters for the AskUserQuestion tool - invoke it, don't output the JSON as text or rephrase as plain text questions.

## CLAUDE.md / AGENTS.md Handling

When setting up a new project, check if the directory already has agent instruction files. **CRITICAL: Check for symlinks FIRST.**

**Step 1: Check for symlinks FIRST**
```bash
ls -la CLAUDE.md AGENTS.md 2>/dev/null
```

Look for `->` in the output which indicates a symlink (e.g., `CLAUDE.md -> AGENTS.md`).

**Step 2: Determine action (priority order)**

| Priority | Scenario | Action |
|----------|----------|--------|
| 1 | **Symlink exists** | **Update the TARGET file only. NEVER delete either file.** |
| 2 | Neither exists | Create CLAUDE.md (default) |
| 3 | Only CLAUDE.md exists | Update CLAUDE.md |
| 4 | Only AGENTS.md exists | Update AGENTS.md |
| 5 | Both exist independently | Update both with same content |

**⚠️ CRITICAL:** If a symlink exists, NEVER delete or recreate either file - use Edit on the target.

**Step 3: Include in preview**
Show which file will be created/updated in the preview:
```
- Agent instructions: CLAUDE.md ← [default | existing | symlink target]
```

## Process

**FIRST ACTION: Enter plan mode by calling the `EnterPlanMode` tool.** This enables proper interactive questioning.

### Step 1: Parse Input

**Before asking ANY questions, extract ALL information from input.**

Use the parsing rules from `_templates/TEMPLATES.md` (Flexible Information Gathering section).

| Input | Extracts | Questions Needed |
|-------|----------|------------------|
| `/blueprint:setup-repo` | Nothing | All questions |
| `/blueprint:setup-repo Node.js API` | Runtime, implied description | Name only |
| `/blueprint:setup-repo Node + Express + Postgres` | Runtime, framework, database | Name, description |
| `/blueprint:setup-repo MyApp: Node API with Express and PostgreSQL` | Name, description, full stack | None (show preview) |
| `/blueprint:setup-repo TaskAPI - team knows Node and Postgres` | Name, runtime, database, rationale | Show preview, create |

**Key signals to extract:**
- "[Name]: [description]" or "[Name] - [description]" → Name + description
- "team knows [X]" / "familiar with [X]" → Rationale for that technology
- "[tech] + [tech] + [tech]" → Stack components

### Step 2: Gather Missing Information (Single Batch)

**Present all remaining questions in a single prompt:**

```
"Setting up a new project. Tell me what you know (answer any, or 'create now'):

**Basics:**
1. Project name?
2. What does it do? (1-2 sentences)

**Tech Stack:**
3. Runtime, framework, database? (e.g., 'Node + Express + Postgres')

**Optional:**
4. Any reasons for these choices? (helps ADRs - or just say 'team preference')
5. Commands to run before commits? [default: lint, test, typecheck]

_(Say 'create now' anytime - I'll infer defaults for anything not specified)_"
```

**Inference Rules (apply automatically):**

| If provided | Infer |
|-------------|-------|
| Runtime only | Framework: common default for runtime |
| Framework only | Runtime: framework's native runtime |
| Database mentioned | Database driver for runtime |
| No testing mentioned | Standard test framework for runtime |

**Runtime defaults:**
- Node.js → Vitest, Express (if framework not specified)
- Bun → Bun test runner, Hono
- Python → pytest, FastAPI
- Go → built-in testing, standard library

**Rationale shortcuts:**
- "team knows" / "team preference" → "Team familiarity with [technology]"
- "industry standard" → "De facto industry standard"
- No rationale → Use "Team preference" as default

### Step 3: Preview Before Creating

**Show what will be created (text format):**

```
"Creating project with:
- Name: TaskAPI ← provided
- Description: REST API for task management ← provided
- Runtime: Node.js ← provided
- Framework: Express ← inferred (Node default)
- Database: PostgreSQL ← provided
- Testing: Vitest ← inferred (Node default)
- Rationale: Team familiarity ← provided"
```

**Then confirm with AskUserQuestion:**

```json
{
  "questions": [{
    "question": "Ready to create the project with these settings?",
    "header": "Create",
    "options": [
      {"label": "Create now", "description": "Generate project structure"},
      {"label": "Change", "description": "I need to modify something"}
    ],
    "multiSelect": false
  }]
}
```

**Response handling:**
- "Create now" → Proceed to Create Structure
- "Change" → Ask "What needs to change?" (plain text)
- "Other" → Treat as modification request

**Skip AskUserQuestion if** user already said "create now" or "proceed" during questions.

## Create Structure

**Tool Preferences:**
- **File writing**: Use Claude's Write tool
- **Directory operations**: Use Bash for `mkdir -p` and `git init`

```
[project-name]/
├── docs/
│   ├── specs/
│   │   ├── product.md                 # Vision, users, success metrics
│   │   ├── features/                  # Feature specifications (empty, discovered via globbing)
│   │   ├── non-functional/            # NFRs by category (empty, discovered via globbing)
│   │   ├── tech-stack.md              # Technology decisions
│   │   └── boundaries.md              # Agent guardrails
│   └── adrs/
│       ├── 001-runtime-choice.md      # Why this runtime
│       ├── 002-framework-choice.md    # Why this framework (if applicable)
│       └── 003-database-choice.md     # Why this database (if applicable)
├── patterns/
│   ├── good/
│   │   └── .gitkeep
│   └── bad/
│       └── anti-patterns.md
├── tests/
│   └── example.test.[ext]             # Initial test file
├── CLAUDE.md (or AGENTS.md)           # Agent instructions - see detection above
└── [standard project files]
```

**Note:** ADRs are discovered via globbing `docs/adrs/*.md`. No index file needed.

## File Templates

**Source of truth:** `_templates/TEMPLATES.md`

### ADR Template (inline for non-interactive execution)

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

### product.md Template

```markdown
---
last_updated: YYYY-MM-DD
---

# [PROJECT_NAME]

## Vision
[1-2 sentence description]

## Users
### [User Type 1]
- [What they need]

## Success Metrics
- [Metric 1]

## Features
See `docs/specs/features/` for detailed specifications.

## Quality Standards
- Run `[lint command]` before committing
- Run `[test command]` for verification
```

### boundaries.md Template

```markdown
# Agent Boundaries

## Always Do
- Run quality commands before commits
- Follow existing code patterns
- Read ADRs before implementing features

## Ask First
### Architecture
- Adding new services or packages
### Breaking Changes
- Removing/renaming API fields
- Changing database schemas
### Blueprint
- Adding or editing ADRs in docs/adrs/
- Adding or editing specs in docs/specs/
- Modifying boundaries.md

## Never Do
### Security
- Commit secrets or credentials
- Disable authentication
### Code
- Commit with type errors
### Documentation
- Create ad-hoc README/markdown files outside the docs/ structure without prior agreement
- Add excessive comments (code should be self-documenting)
- Write long or boilerplate-heavy file header comments instead of concise summaries
```

### Other Templates

| File | Section in TEMPLATES.md |
|------|-------------------------|
| `tech-stack.md` | `<!-- SECTION: tech-stack -->` |
| `CLAUDE.md` | `<!-- SECTION: claude-md -->` |
| `anti-patterns.md` | `<!-- SECTION: bad-patterns -->` |

### Applying Templates

1. **Product spec**: Fill what user provided, mark missing sections with `<!-- TODO -->`.
2. **Tech stack**: Fill from choices. Mark inferred values: `<!-- Auto-inferred -->`.
3. **Boundaries**: Use sensible defaults + any user-specified rules.
4. **ADRs**:
   - If user gave rationale → Use it
   - If user said "team preference" → Use "Team familiarity and industry standard"
   - If user skipped → Use "Team preference" as default
5. **CLAUDE.md / AGENTS.md**: Use full template from `_templates/TEMPLATES.md` (section: `<!-- SECTION: claude-md -->`). Include Pre-Edit Checklist. See "CLAUDE.md / AGENTS.md Handling" above for which file to create.

### Default Boundaries (if not specified)

```markdown
## Never Do
- Commit secrets, API keys, or credentials
- Delete data without explicit confirmation
- Push directly to main/master
- Disable security features

## Ask First
- Major dependency additions
- Database schema changes
- Authentication changes
- Adding or editing Blueprint docs (ADRs, specs, boundaries)
```

## After Creation

1. Initialize git repository if not already done
2. Set up testing with language-appropriate runner
3. Create initial commit with spec structure
4. Report:
   ```
   "Blueprint structure created:
   - [N] ADRs (M from your input, K inferred)
   - Testing: [framework]
   - Commands: [list]

   Run /blueprint:onboard to add more detail anytime."
   ```
5. Suggest next steps:
   - `/blueprint:require` - Add requirements
   - `/blueprint:decide` - Record additional tech decisions
   - `/blueprint:good-pattern` - Capture good patterns

## Examples

**Minimal input:**
```
User: /blueprint:setup-repo
Assistant: "Setting up a new project. Tell me what you know (answer any, or 'create now'):

**Basics:**
1. Project name?
2. What does it do?

**Tech Stack:**
3. Runtime, framework, database?

_(Say 'create now' anytime - I'll infer defaults for anything not specified)_"

User: TaskAPI - REST API for tasks, Node + Postgres, team knows these
Assistant: "Creating project with:
- Name: TaskAPI ← provided
- Description: REST API for tasks ← provided
- Runtime: Node.js ← provided
- Framework: Express ← inferred
- Database: PostgreSQL ← provided
- Testing: Vitest ← inferred
- Rationale: Team familiarity ← provided"

[Uses AskUserQuestion with "Create now" / "Change" options]

User: [Selects "Create now"]
Assistant: [Creates structure]
```

**Rich input:**
```
User: /blueprint:setup-repo TaskAPI: Node.js REST API with Express, PostgreSQL, and JWT auth. Team knows these well.
Assistant: "Creating project with:
- Name: TaskAPI ← provided
- Description: Node.js REST API ← provided
- Runtime: Node.js ← provided
- Framework: Express ← provided
- Database: PostgreSQL ← provided
- Auth: JWT ← provided
- Rationale: Team familiarity ← provided"

[Uses AskUserQuestion with "Create now" / "Change" options]

User: [Selects "Create now"]
Assistant: [Creates structure immediately]
```

## Error Recovery

If user indicates a mistake after creation:
1. Acknowledge: "I can update or remove the created files"
2. Clarify: "What needs to change?"
3. Execute: Update or delete as needed
4. Confirm: "Files have been [updated/removed]"
