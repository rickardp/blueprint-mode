---
name: blueprint:onboard
description: Create Blueprint structure from existing repo. Run multiple times to refine.
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

# ASSUME USER WANT FULL INTEGRATION - DO NOT ASK FOR SCOPE OF ONBOARDING

**DO NOT** ask "Would you like me to...", offer numbered options, or ask what to create.
**DO** analyze the repo and create the full Blueprint structure now.

If existing documentation exists, CREATE BLUEPRINT STRUCTURE ANYWAY. Do not ask permission.

**TOOL USAGE:** Use `AskUserQuestion` for rationale questions with structured options. **DO NOT** ask for scope, we always do full Blueprint setup.

---

# Onboard Repository

**COMMAND:** Analyze repo, show plan, then create full Blueprint structure.

## Execute

1. **Enter plan mode** - Call EnterPlanMode tool first
2. **Detect agent instructions file** - See "CLAUDE.md / AGENTS.md Detection" below
3. **Read** package.json, README.md, [agent instructions file], docs/
4. **Extract** tech decisions and rationale from existing docs
5. **Show plan** - List exactly what will be created (see format below)
6. **Exit plan mode** - Call ExitPlanMode when ready
7. **Gather rationale** - For each tech without rationale, ask user (see format below)
8. **Create** all Blueprint files (including agent instructions)
9. **Clean up existing documentation** - Blueprint files are source of truth. Other docs (including CLAUDE.md and other agent instructions) *reference* these files rather than duplicating (keep brief summary + reference to ADR or spec)
10. **Clean up long code comments** referencing ADRs or specs instead of explaining rationale inlined in code
11. **Report** what was created

## CLAUDE.md / AGENTS.md Detection

Repositories may have `CLAUDE.md`, `AGENTS.md`, both, or neither. **CRITICAL: Check for symlinks FIRST to avoid breaking the link relationship.**

**Step 1: Check for symlinks FIRST**
```bash
ls -la CLAUDE.md AGENTS.md 2>/dev/null
```

Look for `->` in the output which indicates a symlink:
- `CLAUDE.md -> AGENTS.md` means CLAUDE.md is a symlink to AGENTS.md
- `AGENTS.md -> CLAUDE.md` means AGENTS.md is a symlink to CLAUDE.md

**Step 2: Determine action based on priority order**

| Priority | Scenario | Detection | Action |
|----------|----------|-----------|--------|
| 1 | **Symlink exists** | `ls -la` shows `->` | **Update the TARGET file only. NEVER delete or recreate either file.** |
| 2 | One references other | File contains "See CLAUDE.md" or "See AGENTS.md" | Update the referenced file only |
| 3 | Only CLAUDE.md exists | File exists, no AGENTS.md | Update CLAUDE.md |
| 4 | Only AGENTS.md exists | File exists, no CLAUDE.md | Update AGENTS.md |
| 5 | Both exist independently | Both files, no symlink, no reference | Update both with same content |
| 6 | Neither exists | Neither file found | Create CLAUDE.md (default) |

**⚠️ CRITICAL:** If a symlink exists, you MUST:
- Identify which file is the symlink and which is the target
- Only edit/update the TARGET file (the one being pointed to)
- NEVER delete either file - this would break the symlink relationship
- NEVER use Write tool on the symlink - use Edit on the target instead

**Step 3: Record decision**
In the plan output, include:
```
Agent instructions: [CLAUDE.md | AGENTS.md] (target of symlink) | both
```

## Plan Format (show before creating)

```
I will create:

ADRs:
- ADR-001: [tech] as [category] - [rationale or "TBD"]
- ADR-002: [tech] as [category] - [rationale or "TBD"]

Specs:
- docs/specs/product.md
- docs/specs/tech-stack.md
- docs/specs/boundaries.md

[Call ExitPlanMode to proceed]
```

## Files to Create

```
docs/
├── adrs/
│   └── 001-[tech].md    # One per major technology
├── specs/
│   ├── product.md       # Vision, users, goals (from README)
│   ├── tech-stack.md    # All technologies (from dependencies)
│   └── boundaries.md    # Always/Ask/Never rules
CLAUDE.md (or AGENTS.md) # Agent instructions - see detection above
```

## Templates

**Source of truth:** `_templates/TEMPLATES.md`

### ADR Template (inline for non-interactive execution)

```markdown
---
status: Active
date: YYYY-MM-DD
---

# ADR-NNN: [Choice] as [CATEGORY]

## Context
[What problem are we solving? What constraints exist?]

## Options Considered
### Option 1: [Alternative A]
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

**Status values:** Draft, Active, Superseded, Deprecated

### ADR Format Enforcement (CRITICAL)

**MANDATORY:** Use the exact format above. DO NOT deviate.

| DO NOT use | USE instead |
|------------|-------------|
| `## Status` with "Accepted" in body | YAML frontmatter `status: Active` |
| `**Benefits:**` | `**Positive:**` |
| `**Trade-offs:**` | `**Negative:**` |
| `## References` | `## Related` |
| Omitting Options Considered | Include `## Options Considered` |

**Validation checklist before writing ADR:**
- [ ] Has YAML frontmatter with `status:` and `date:`
- [ ] Title format: `# ADR-NNN: [Choice] as [CATEGORY]`
- [ ] Has `## Options Considered` section
- [ ] Uses `**Positive:**` and `**Negative:**` (not Benefits/Trade-offs)
- [ ] Ends with `## Related` (not References)

### Other Templates

| Artifact | Section in TEMPLATES.md |
|----------|-------------------------|
| product.md | `<!-- SECTION: product-spec -->` |
| tech-stack.md | `<!-- SECTION: tech-stack -->` |
| boundaries.md | `<!-- SECTION: boundaries -->` |
| CLAUDE.md | `<!-- SECTION: claude-md -->` |

## Rationale Suggestions

When rationale is missing, use AskUserQuestion with context-aware options:

| Technology | Suggested Rationales |
|------------|---------------------|
| React/Vue/Angular | Team familiarity; Large ecosystem; Component library compatibility; Industry standard |
| Next.js/Nuxt | SSR requirements; Full-stack capabilities; Team familiarity |
| Express/Fastify | Team familiarity; Mature ecosystem; Performance requirements |
| PostgreSQL | ACID compliance; Team familiarity; JSON support; Relational model |
| MongoDB | Document model fits data; Schema flexibility; Team familiarity |
| TypeScript | Type safety; Better IDE support; Reduced runtime errors |

### AskUserQuestion Format

Batch up to 4 technologies per question:

```json
{
  "questions": [
    {
      "question": "Why was React chosen for the frontend?",
      "header": "React",
      "options": [
        {"label": "Team familiarity", "description": ""},
        {"label": "Large ecosystem", "description": ""},
        {"label": "Component library compatibility", "description": ""},
        {"label": "Skip for now", "description": "Mark as TBD"}
      ],
      "multiSelect": true
    }
  ]
}
```

- Selected options → Combine into rationale
- "Skip for now" → Mark as TBD
- Custom text → Use verbatim

## Output Format

```
Created Blueprint structure:
- X ADRs (Y with rationale, Z marked TBD)
- docs/specs/product.md
- docs/specs/tech-stack.md
- docs/specs/boundaries.md
- [CLAUDE.md | AGENTS.md | both] (agent instructions)

TBD sections can be refined by running this skill again.
```

## If Structure Already Exists

1. List what exists
2. Create any missing files
3. Ensure that the structure matches and these instructions
4. Report additions

Do not ask what to focus on. Create what's missing.

## Questions

Use AskUserQuestion for rationale gaps (see format above).

Simple text questions allowed for:
- "Who are the users?" - if not in README
- "Any specific boundary rules?" - for boundaries.md

Never ask: "What would you like to create?" or "Full/partial setup?"
