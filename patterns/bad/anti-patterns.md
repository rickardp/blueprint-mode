# Anti-Patterns

Common mistakes to avoid in this codebase.

## Skills: Asking Scope Questions

**Severity:** High

### Don't Do This
```markdown
What would you like to create?
- [ ] Full setup
- [ ] Partial setup
- [ ] Just ADRs
```

**Problems:**
- The user already invoked the skill; the invocation is the scope
- Every checkpoint pulls the model toward stopping early

### Do This Instead
```markdown
Create the full structure. Ask only for rationale you cannot find; write TBD when skipped.
```

**Why:** Modern models complete a stated scope on their own. Questions are for missing content, never for permission to do the job.

---

## Agent Instructions: Mandatory Pre-Reads

**Severity:** High

### Don't Do This
```markdown
BEFORE writing or editing ANY code, you MUST:
1. Read docs/specs/boundaries.md
2. Read the feature spec
3. Check patterns/good/ and patterns/bad/
```

**Problems:**
- Burns context on every edit, including one-line fixes
- Slows work without changing outcomes
- Written against older models that needed to be pushed to look things up

### Do This Instead
```markdown
- `docs/adrs/` records architecture decisions. Read the relevant one when a change touches a documented choice.
- `docs/specs/boundaries.md` says what is safe, what to ask about, and what is never done. Read it when a change touches security, data, dependencies, or public APIs.
```

**Why:** Route to the right file at the right moment. Current models decide well when to look; tell them where, not that they must always look.

---

## Skills: Copying Formats Out of the Templates

**Severity:** Medium

### Don't Do This
```markdown
## ADR Template (inline for non-interactive execution)
[40 lines duplicating _templates/TEMPLATES.md]

### Format Enforcement (CRITICAL)
MANDATORY: Use the exact format above. DO NOT deviate.
```

**Problems:**
- Three copies drift apart
- Shouting does not improve compliance; a single clear source does

### Do This Instead
```markdown
Format: `_templates/TEMPLATES.md`, section `adr-template`.
```

**Why:** One copy of every format keeps skills short and lets `/blueprint-mode:validate` check against a single source of truth.

---

## Documentation: Duplicating Rationale

**Severity:** Medium

### Don't Do This
```typescript
// Using PostgreSQL because the team is familiar with it,
// it provides ACID compliance which we need for financial
// transactions, and it has excellent JSON support.
const db = new PostgresClient();
```

**Problems:**
- Rationale belongs in ADRs, not code comments
- Comments go stale when decisions evolve

### Do This Instead
```typescript
// ADR-NNN: PostgreSQL for data layer
const db = new PostgresClient();
```

**Why:** The ADR has the full rationale. Comments reference, not duplicate.
