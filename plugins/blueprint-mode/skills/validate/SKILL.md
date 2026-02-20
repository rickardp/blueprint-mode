---
name: blueprint:validate
description: Check code against documented specs, patterns, anti-patterns, and ADR decisions. Use when the user wants to verify consistency, audit the codebase, check spec compliance, or find violations.
argument-hint: "[scope: all|specs|patterns|adrs|features|docs|directory]"
disable-model-invocation: true
allowed-tools:
  - Bash
  - Glob
  - Grep
  - Read
  - Task
  - AskUserQuestion
  - EnterPlanMode
  - ExitPlanMode
---

# Validate Blueprint Compliance

Check codebase against documented specs, patterns, anti-patterns, and architectural decisions using parallel sub-agents.

**Invoked by:** `/blueprint:validate`

## Principles

1. **Discover first, scan second**: Build a structural map before diving into details.
2. **Parallel sub-agents**: Launch one Task agent per validation domain — they run concurrently in the background.
3. **Severity-based**: Rank findings by impact (Critical > High > Medium > Low).
4. **Non-destructive**: Report only, never auto-fix without explicit request.

**TOOL USAGE: You MUST invoke the `AskUserQuestion` tool for scope selection if not specified.**
When you see JSON examples in this skill, they are parameters for the AskUserQuestion tool — invoke it, don't output the JSON as text.

## Process

**FIRST ACTION: Enter plan mode by calling the `EnterPlanMode` tool.**

### Step 1: Discovery

Gather repo structure and blueprint inventory in parallel. Use Glob and Read directly (not sub-agents) — this should be fast.

**1a. Blueprint inventory** (parallel Glob calls):
- `docs/specs/*.md` and `docs/specs/**/*.md` — specs (tech-stack, product, boundaries, features, NFRs)
- `docs/adrs/*.md` — architecture decision records
- `patterns/bad/**/*.md` and `patterns/good/**/*.md` — documented patterns

If no blueprint files exist: "No Blueprint structure found. Run `/blueprint:onboard` first." and stop.

**1b. Repo structure** (parallel Glob calls):
- `**/*.md` — all markdown files (for documentation drift detection)
- `.github/workflows/*.yml` or `.gitlab-ci.yml` or `Jenkinsfile` or `bitbucket-pipelines.yml` — CI/CD
- `infra/**/*` or `terraform/**/*` or `cdk/**/*` or `pulumi/**/*` or `sst.config.*` or `Dockerfile*` or `docker-compose*` — infrastructure
- `package.json` or `requirements.txt` or `go.mod` or `Cargo.toml` or `pyproject.toml` — dependency manifests
- Top-level source directories (e.g., `src/`, `lib/`, `app/`, `functions/`, `common/`)

**1c. Read blueprint files**: Read all discovered spec, ADR, boundary, and pattern files. Extract key validation rules into a structured context block:

```
=== BLUEPRINT CONTEXT ===

TECH STACK (from docs/specs/tech-stack.md):
- Runtime: [X]
- Framework: [X]
- Database: [X]
- Commands: install=[X], dev=[X], test=[X], lint=[X]

BOUNDARIES (from docs/specs/boundaries.md):
- Always: [rule1], [rule2], ...
- Never: [rule1], [rule2], ...
- Ask First: [rule1], [rule2], ...

ADR DECISIONS:
- ADR-001 [title]: Chose [X], rejected [Y, Z]
- ADR-002 [title]: Chose [X], rejected [Y, Z]
- ...

PATTERNS:
- Anti-patterns: [name1: description], [name2: description], ...
- Good patterns: [name1: key elements], ...

FEATURES (from docs/specs/features/):
- [name] (status: Active|Planned|Deprecated, module: path, ADRs: [...])
- ...

=== END CONTEXT ===
```

### Step 2: Scope Selection

**Branch Detection:**
1. Run `git branch --show-current`
2. If NOT `main`/`master`, run `git diff --name-only main...HEAD 2>/dev/null || git diff --name-only master...HEAD 2>/dev/null`

**If on a feature branch with changes, use AskUserQuestion:**
```json
{
  "questions": [{
    "question": "You're on branch '[branch-name]' with [N] changed files vs main. What should I validate?",
    "header": "Scope",
    "options": [
      {"label": "Branch changes (Recommended)", "description": "Only validate files changed on this branch vs main/master"},
      {"label": "All source", "description": "Validate entire codebase excluding node_modules, dist, build"},
      {"label": "Specific directory", "description": "I'll specify a path to validate"}
    ],
    "multiSelect": false
  }]
}
```

**If on main/master or no branch changes:**
```json
{
  "questions": [{
    "question": "What should I validate?",
    "header": "Scope",
    "options": [
      {"label": "All source (Recommended)", "description": "Validate entire codebase excluding node_modules, dist, build"},
      {"label": "Recent changes", "description": "Only files modified in last commit or uncommitted"},
      {"label": "Specific directory", "description": "I'll specify a path to validate"}
    ],
    "multiSelect": false
  }]
}
```

### Step 3: Launch Parallel Sub-Agents

Based on discovery results, launch **one Task agent per validation domain** — all in a **single message** so they run concurrently. Use `subagent_type: "Explore"` and `run_in_background: true` for each.

Every agent prompt MUST include:
1. The full **Blueprint Context** block from Step 1c
2. The **scope** (file list or directory) from Step 2
3. Domain-specific scan instructions (below)
4. Instruction to return findings as a structured list with severity, location, description, and blueprint source

#### Agent: Source Code

**Launch when:** Source directories exist.

Prompt must instruct the agent to:
1. **Tech stack compliance**: Read dependency manifests, compare against declared tech stack. Flag undeclared dependencies, missing declared tech, version mismatches.
2. **Boundary violations**: For each "Never Do" rule, Grep source files for violations. For "Always Do" rules, verify compliance. For "Ask First" items, warn if detected.
3. **Anti-pattern scan**: For each documented anti-pattern, Grep source files for matching code.
4. **ADR compliance**: For each ADR's chosen approach, verify source follows it. For rejected alternatives, Grep for their usage.
5. **Undocumented patterns**: Note consistent code patterns (repeated 3+ times) not captured in `patterns/good/`.

#### Agent: Features

**Launch when:** `docs/specs/features/*.md` exist.

Prompt must instruct the agent to:
1. For each feature spec, verify declared module path exists.
2. Check for test files in each feature's module.
3. Verify status matches reality (Active features should have code, Deprecated should not be actively developed).
4. Flag orphaned modules — source directories with no corresponding feature spec.
5. Verify related ADRs referenced by features are still Active.

#### Agent: Documentation Drift & Content Classification

**Launch when:** Markdown files exist outside `docs/specs/`, `docs/adrs/`, `patterns/` **OR** any blueprint files exist.

Prompt must instruct the agent to:
1. Find all `.md` files outside the Blueprint structure (CLAUDE.md, README.md, guides, `.claude/*.md`, etc.).
2. Cross-reference against tech stack: Grep for superseded/banned alternatives (e.g., `npm install` when ADR chose Bun).
3. Cross-reference against ADR decisions: Grep for rejected alternatives being recommended.
4. Cross-reference against deprecated features: Grep for references to Deprecated features as if active.
5. Flag stale instructions in CLAUDE.md/AGENTS.md — these are **High severity** because agents follow them directly.
6. **Content classification audit** — check if information is in the wrong document type:
   - ADRs containing functional requirements (user stories, feature behaviors, UI specs) → should be in `docs/specs/features/`
   - ADRs containing NFR targets (latency metrics, uptime SLAs, scalability numbers) → should be in `docs/specs/non-functional/`
   - Feature specs containing architectural rationale (tech choice trade-offs, "we chose X over Y") → should be ADRs in `docs/adrs/`
   - NFR files containing architectural decisions (tool/service choices) → should be ADRs
   - Product spec containing detailed feature requirements → should be feature specs
   Flag misplaced content as **Medium** severity with a suggestion to move it to the correct location.

#### Agent: CI/CD

**Launch when:** CI/CD config files detected (`.github/workflows/`, `.gitlab-ci.yml`, etc.).

Prompt must instruct the agent to:
1. Read CI/CD config files.
2. Verify pipeline uses declared commands from tech stack (correct install, test, lint commands).
3. Check that quality gates match "Always Do" boundary rules.
4. Flag pipelines using tools/commands that contradict ADR decisions.
5. Check for secrets or credentials committed in pipeline configs (**Critical** severity).

#### Agent: Infrastructure

**Launch when:** Infrastructure files detected (`infra/`, `terraform/`, `Dockerfile`, `sst.config.*`, etc.).

Prompt must instruct the agent to:
1. Read infrastructure config files.
2. Verify infrastructure choices match ADR decisions (e.g., if ADR chose DynamoDB, check IaC isn't provisioning PostgreSQL).
3. Check that declared cloud services match tech stack.
4. Flag infrastructure patterns that contradict documented anti-patterns.
5. Verify environment/stage patterns match any documented deployment specs.

### Step 4: Collect Results

Read the output from each background agent using the Read tool on their output files. Collect all findings into a unified list.

### Step 5: Report

Present findings in a unified report ranked by severity:

| Severity | Description |
|----------|-------------|
| Critical | Security vulnerabilities, boundary "Never Do" violations, secrets in config |
| High | Tech stack mismatches, stale agent instructions (CLAUDE.md), ADR violations |
| Medium | Pattern inconsistencies, undeclared dependencies, doc drift in guides, misclassified content (e.g., requirements in ADRs, architectural decisions in feature specs) |
| Low | Style preferences, minor terminology drift, missing test coverage |

**Report format:**
```markdown
## Blueprint Validation Report

### Source Code
**Tech Stack:** [findings]
**Boundary Compliance:** [findings]
**Pattern Violations:** [findings]
**ADR Compliance:** [findings]

### Features
**Feature Coverage:**
| Feature | Spec Status | Module | Evidence |
|---------|-------------|--------|----------|
| ... | ... | ... | ... |

**Orphaned Modules:** [findings]

### Documentation Drift
| File | Issue | Severity | Blueprint Source |
|------|-------|----------|-----------------|
| ... | ... | ... | ... |

### Content Classification
| File | Misplaced Content | Should Be In | Severity |
|------|-------------------|--------------|----------|
| ... | ... | ... | ... |

### CI/CD
[findings if agent was launched, otherwise "No CI/CD config detected"]

### Infrastructure
[findings if agent was launched, otherwise "No infrastructure config detected"]

### Summary
- Critical: [N] | High: [N] | Medium: [N] | Low: [N]
- Agents run: [list of domains scanned]
- Domains skipped: [list not applicable to this repo]
```

## After Validation

- **Spec drift found**: Suggest updating specs or creating ADRs for undocumented changes
- **Tech stack mismatch**: Suggest `/blueprint:decide` to document the actual choice
- **Boundary violations**: Highlight critical issues requiring immediate attention
- **Documentation drift found**: Suggest updating stale docs (especially CLAUDE.md — agents follow it directly)
- **Misclassified content found**: Suggest moving content to correct document type (e.g., extract requirements from ADR into feature spec, extract tech rationale from feature spec into ADR)
- **Undocumented patterns found**: Suggest `/blueprint:good-pattern`
- **No violations**: Confirm codebase consistency with specs

## Examples

- `/blueprint:validate` → Full validation (all domains in parallel)
- `/blueprint:validate specs` → Source code + features agents only
- `/blueprint:validate docs` → Documentation drift agent only
- `/blueprint:validate features` → Features agent only
- `/blueprint:validate adrs` → ADR compliance checks across all domains
- "Check if code matches our specs" → Full validation
- "Is CLAUDE.md up to date?" → Documentation drift agent
- "Validate the auth module" → All agents scoped to `src/auth/`
