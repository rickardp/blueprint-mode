# Anti-Patterns

Common mistakes to avoid in this codebase.

## How to Add Anti-Patterns

Add a new section below following this format:

```markdown
## [Category]: [Description]

**Severity:** Critical | High | Medium | Low

### Don't Do This
```[language]
[bad code example]
```

**Problems:**
- [Issue 1]

### Do This Instead
```[language]
[correct code example]
```

**Why:** [Explanation]
```

---

## Skills: Asking Scope Questions

**Severity:** High

### Don't Do This
```markdown
# My Skill

What would you like to create?
- [ ] Full setup
- [ ] Partial setup
- [ ] Just ADRs
```

**Problems:**
- Blocks execution on unnecessary decisions
- User already invoked the skill - they want the default behavior
- Violates "Create First, Refine Later" principle

### Do This Instead
```markdown
# My Skill

**COMMAND:** Create the standard setup.

## Execute
1. Create files with defaults
2. Mark unknowns as TBD
3. Report what was created
```

**Why:** Skills should execute with sensible defaults. TBD markers let users refine later without blocking initial creation.

---

## Documentation: Duplicating Rationale

**Severity:** Medium

### Don't Do This
```typescript
// Using PostgreSQL because the team is familiar with it,
// it provides ACID compliance which we need for financial
// transactions, and it has excellent JSON support for our
// semi-structured data requirements.
const db = new PostgresClient();
```

**Problems:**
- Rationale belongs in ADRs, not code comments
- Comments become stale when decisions evolve
- Duplicates information that lives in docs/adrs/

### Do This Instead
```typescript
// ADR-005: PostgreSQL for data layer
const db = new PostgresClient();
```

**Why:** The ADR has the full rationale. Comments should reference, not duplicate.

---

## Hooks: Adding Dependencies

**Severity:** Critical

### Don't Do This
```bash
#!/bin/bash
# Requires jq to be installed
cat docs/adrs/*.md | jq -r '.frontmatter.status'
```

**Problems:**
- Breaks zero-dependency principle
- Users without jq get cryptic errors
- Adds installation complexity

### Do This Instead
```bash
#!/bin/bash
# Use only built-in tools
grep -h "^status:" docs/adrs/*.md | cut -d: -f2
```

**Why:** Blueprint Mode is zero-dependency. Hooks must work with only bash built-ins and standard Unix tools (grep, sed, awk, cat).
