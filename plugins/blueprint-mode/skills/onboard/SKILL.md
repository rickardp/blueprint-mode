---
name: blueprint:onboard
description: Onboard an existing repository to the spec-driven development structure. Can be run multiple times to refine and add to the documentation. Use when setting up or continuing to build docs/specs/, docs/adrs/, and patterns/.
disable-model-invocation: true
argument-hint: ""
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

### Step 1: Analyze the Codebase (Automatic)

**Before asking any questions**, gather everything you can:

**Tool Preferences:**
- **File reading**: Use Claude's Read tool (not `cat`)
- **File finding**: Use Claude's Glob tool (not `find` or `ls`)
- **Content search**: Use Claude's Grep tool (not `grep` or `rg`)
- **Git operations**: Use Bash with bounded commands

**Auto-detect:**
| Source | Information |
|--------|-------------|
| `package.json` / `pyproject.toml` / `go.mod` | Project name, dependencies, scripts |
| `README.md` | Project description, purpose |
| Dependencies | Runtime, framework, database drivers, test framework |
| Config files | Linting, TypeScript, build tools |
| `src/` structure | Feature areas, module organization |
| Existing `docs/` | What's already documented |

**Git history (optional, bounded):**
- Quick scan: `git log --oneline -50 --since="30 days ago"`
- Look for: dependency additions, config changes, migrations

### Step 2: Present Findings

Present what you discovered as text, then confirm using AskUserQuestion:

**Text presentation:**
```
"Based on the codebase, I found:

**Project:** [name] - [description from README]
**Runtime:** [detected] (from [source])
**Framework:** [detected] (from dependencies)
**Database:** [detected or 'None detected']
**Testing:** [framework] (from devDependencies)
**Quality commands:** [detected from scripts]

**Potential feature areas:**
- [src/auth/] - Authentication
- [src/api/] - API handlers
- [etc.]"
```

**Then use AskUserQuestion for confirmation:**

```json
{
  "questions": [{
    "question": "Are these project details correct?",
    "header": "Confirm",
    "options": [
      {"label": "Looks good", "description": "Proceed with these values"},
      {"label": "Add context", "description": "I have more to share"},
      {"label": "Fix errors", "description": "Some details are wrong"}
    ],
    "multiSelect": false
  }]
}
```

**Response handling:**
- "Looks good" → Proceed to Step 5 (Create Structure)
- "Add context" → Proceed to Step 3 (Optional Interview)
- "Fix errors" → Ask "What needs to be corrected?" (plain text)
- "Other" → Treat response as correction/addition

### Step 3: Optional Interview

**User can proceed immediately or add more context.**

If user wants to add details, ask by category:

#### Quick Questions (ask only what's missing)
1. "Anything to add about the project purpose or users?"
2. "Any architectural decisions that aren't obvious from the code?"
3. "Any patterns that work well here that others should follow?"
4. "Anything AI agents should never do in this codebase?"

#### Git-Informed Questions (if patterns found)
- "I see [dependency] was added recently. Was this a deliberate architectural choice?"
- "The codebase uses [pattern]. Should I document this as an ADR?"

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
2. **Show what exists:**
   ```
   "Blueprint structure exists:
   - Specs: product.md, tech-stack.md, 3 features
   - ADRs: 4 active
   - Patterns: 2 good, 1 anti-pattern

   What would you like to add or refine?"
   ```

3. **Options:**
   - Add new ADRs
   - Refine existing specs
   - Add patterns
   - Update boundaries

## Error Recovery

If user indicates a mistake after creation:
1. Acknowledge: "I can update or remove the created files"
2. Clarify: "What needs to change?"
3. Execute: Update or delete as needed
4. Confirm: "Files have been [updated/removed]"
