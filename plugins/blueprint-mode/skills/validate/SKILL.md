---
name: blueprint:validate
description: Check code against documented specs, patterns, anti-patterns, and ADR decisions. Use when the user wants to verify consistency, audit the codebase, check spec compliance, or find violations.
argument-hint: "[scope: all|specs|patterns|adrs|features|directory]"
disable-model-invocation: true
---

# Validate Blueprint Compliance

Check codebase against documented specs, patterns, anti-patterns, and architectural decisions.

**Invoked by:** `/blueprint:validate`

## Principles

1. **Parallel scanning**: Batch Grep calls by validation category.
2. **Progressive disclosure**: For large result sets, summarize first, drill down on request.
3. **Severity-based**: Rank findings by impact (Critical > High > Medium > Low).
4. **Non-destructive**: Report only, never auto-fix without explicit request.

## Process

### Step 1: Check Prerequisites

Required files (at least one):
- `docs/specs/` - Spec compliance (tech-stack.md, product.md, boundaries.md)
- `docs/adrs/*.md` - ADR compliance (discovered via globbing)
- `patterns/bad/anti-patterns.md` - Anti-pattern checks
- `patterns/good/` - Pattern compliance (optional)

If none exist: "No Blueprint structure found. Run `/blueprint:onboard` first."

### Step 2: Scope Selection

If scope unclear, ask: "What should I validate? (all source files / specific directory / recent changes)"

Default: All source files, excluding node_modules, dist, build directories.

### Step 3: Load Validation Rules

#### From Specs

**Tech Stack (`docs/specs/tech-stack.md`):**
- Extract declared Runtime, Framework, Database, Auth technologies
- Extract expected commands (install, dev, test, lint)

**Product (`docs/specs/product.md`):**
- Extract Quality Standards commands
- Extract Success Metrics for tracking

**Features (`docs/specs/features/`):**
- Glob `docs/specs/features/*.md` to find all feature specs
- For each feature spec, extract from frontmatter: status, module path, related ADRs
- Track: Active, Planned, Deprecated features

**Non-Functional Requirements (`docs/specs/non-functional/`):**
- Glob `docs/specs/non-functional/*.md` to find all NFR files
- Extract metrics and targets for validation
- Categories: performance, security, scalability, reliability

**Boundaries (`docs/specs/boundaries.md`):**
- Extract "Always Do" rules as required compliance checks
- Extract "Never Do" rules as violation searches
- Extract "Ask First" items as warnings when detected

#### From Patterns

1. **Anti-patterns**: Parse `## ` sections from `patterns/bad/anti-patterns.md` for searchable patterns
2. **Good patterns**: Extract key elements from `patterns/good/*` files

#### From ADRs

3. **ADRs**: Extract enforceable rules (chosen dependencies, mandated patterns, banned alternatives)

### Step 4: Scan Codebase

**Tool Preferences:**
- **File reading**: Use Claude's Read tool (not `cat`)
- **File finding**: Use Claude's Glob tool (not `find` or `ls`)
- **Content search**: Use Claude's Grep tool (not `grep` or `rg`)

**Performance Constraints:**
- **Batch size**: Maximum 5-8 parallel Grep calls at once
- **Result limits**: Use `head_limit: 20` per search to avoid context overflow
- **Progressive disclosure**: If total issues > 50, present summary by category first, then offer to drill down
- **Large codebases**: For repos with >500 source files, validate one category at a time

Search using parallel Grep calls grouped by validation category. Stream findings as discovered.

#### Spec Compliance Scans

**Tech Stack Validation:**
1. Read `package.json` (or equivalent: `requirements.txt`, `go.mod`, `Cargo.toml`, etc.)
2. Compare against declared tech in `docs/specs/tech-stack.md`
3. Flag: undeclared dependencies, version mismatches, missing declared tech

**Feature Coverage:**
1. Glob `docs/specs/features/*.md` to find all feature specs
2. For each feature spec:
   - Verify declared module path exists (e.g., `src/auth/`)
   - Check for corresponding test files in the module
   - Verify status matches reality (Active features should have code)
   - Check module path contains implementation
   - Verify related ADRs are still Active (glob `docs/adrs/*.md` and check frontmatter)
3. Flag: features with no apparent implementation, orphaned modules not in features/

**Boundary Violations:**
1. For each "Never Do" rule, search for violations (secrets, disabled auth, etc.)
2. For "Always Do" rules, verify compliance (e.g., ADR comments exist, quality commands configured)
3. For "Ask First" items, warn if detected without documentation

#### Pattern and ADR Scans

Run pattern and ADR scans in parallel with spec scans.

### Step 5: Report Findings

Present findings ranked by severity:

| Severity | Description |
|----------|-------------|
| Critical | Security vulnerabilities, data loss, boundary "Never Do" violations |
| High | Tech stack mismatches, missing capabilities, performance issues |
| Medium | Code smells, pattern inconsistencies, undeclared dependencies |
| Low | Style preferences, minor drift |

**Report format:**
```markdown
## Blueprint Validation Report

### Spec Compliance

**Tech Stack:**
- [✓] Runtime: Node.js 20 matches declared
- [✗] Framework: Declared Express, found Fastify in package.json
- [!] Undeclared: lodash (not in tech-stack.md)

**Feature Coverage:**
| Feature | Spec Status | Module | Evidence |
|---------|-------------|--------|----------|
| User Auth | Active | src/auth/ | ✓ Module exists, 5 test files |
| Data Export | Planned | src/export/ | ? Module exists, no tests |
| Analytics | Active | src/analytics/ | ✗ Module missing |

**Orphaned Modules** (code without feature specs):
- src/legacy/ - Not documented in features/

**Boundary Compliance:**
- [✓] ADR references found in code (15 occurrences)
- [✗] "Never Do" violation: hardcoded secret in config.ts:42
- [!] "Ask First" detected: New dependency 'axios' added without ADR

### Pattern Violations

1. **[Anti-pattern name]** (Critical)
   - Location: file:line
   - Fix: [recommendation]

### ADR Compliance

- [✓] ADR-001: PostgreSQL - using pg driver as specified
- [✗] ADR-003: Repository pattern - direct DB calls found in handlers/

### Summary
- Critical: [N] | High: [N] | Medium: [N] | Low: [N]
- Spec compliance: [N]/[total] checks passed
- Pattern compliance: [N]/[total] patterns followed
```

### Step 6: Surface Undocumented Patterns

Note any consistent code patterns (repeated 3+ times) not yet captured in `patterns/good/`.

Also flag significant code/features not documented in any spec (potential spec drift).

## After Validation

- **Spec drift found**: Suggest updating specs or creating ADRs for undocumented changes
- **Tech stack mismatch**: Suggest `/blueprint:decide` to document the actual choice
- **Missing capabilities**: Flag for product review - is this intentional or missing?
- **Boundary violations**: Highlight critical issues requiring immediate attention
- **Undocumented patterns found**: Suggest `/blueprint:good-pattern`
- **No violations**: Confirm codebase consistency with specs

## Examples

- `/blueprint:validate` → Full validation (specs + patterns + ADRs)
- `/blueprint:validate specs` → Focus on spec compliance only
- `/blueprint:validate features` → Focus on feature coverage
- "Check if code matches our specs" → Spec compliance check
- "Validate the auth module" → Scoped to `src/auth/`
- "Check for anti-patterns" → Focus on anti-pattern violations
- "Are we following our tech stack?" → Tech stack compliance check
- "Check feature coverage" → Verify features have implementations
- "Find orphaned code" → Identify modules without feature specs
