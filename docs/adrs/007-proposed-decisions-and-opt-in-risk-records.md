---
status: Active
date: 2026-11-09
---

# ADR-007: Proposed Status for Agent Choices and Opt-In Risk Records

## Decision

Record architectural choices an agent introduces on its own authority as **Proposed** ADRs, and support optional `Enforced by`, `Revisit when`, and opt-in Risk sections, with `validate` reporting on them but never gating.

**Applies to:** `plugins/blueprint-mode/skills/_templates/TEMPLATES.md` (sections `adr-template`, `ux-decision-template`, `adr-reading`, `decision-lifecycle`, `adr-tbd-comment`, `risk-owners`, `agent-instructions`), the skills that write, change, list, or validate decisions (`decide`, `supersede`, `validate`, `status`, `list-adrs`, `help`, `onboard`, `setup-repo`), and the ADR, UX decision, and `docs/specs/risk-owners.md` formats written into user repositories.

**Constraints:**
- Proposed covers only agent-originated choices later code depends on (datastore, queue, protocol, data format, cross-module convention, or a dependency `boundaries.md` does not put under Ask First). Ask First items are asked, not proposed. onboard and setup-repo never write Proposed.
- Only a human accepts: the reviewer sets `status: Active`, typically within the PR, and the merge approves it. A validate finding is not acceptance. Proposed and Draft are not authority. A rejected Proposed ADR is deleted and its number is not reused.
- `ADR-TBD:` code comments mark placeholder choices an agent could not make without human input; otherwise the agent asks.
- `**Enforced by:**` is the last line of Decision; `## Risk` sits after Consequences and before Related; `**Revisit when:**` is the last line of the file. All are optional; existing ADRs stay valid.
- Risk tracking is off unless `docs/specs/risk-owners.md` exists. Agents never create the roster or a Risk section without an explicit user request, and Risk owners come only from the roster.
- The ADR template states where Blueprint terminology differs from Nygard and MADR. `Accepted` is read as `Active` and not reported as drift; agents write `Active`. There is no `Rejected` status and no superseding ADR.
- `validate` reports Proposed ADRs, risk fields, dates, missing `Enforced by` paths, and duplicate numbers by severity; repositories own any merge gates.

**Exceptions:** UX decisions take optional Risk and Revisit when but not Proposed or Enforced by; agent-made UI choices use `UX-TBD`.

## Context

Agents make implicit architectural choices while implementing ("vibe architecting"): a dependency or convention appears in code and later work treats it as settled, though no human decided it. ADR-004 keeps humans in control of architecture; without a status for unaccepted agent choices, those choices were either invisible or recorded as if decided.

Repositories assessing ISO/IEC 27001 and 42001 need accepted risks with an accountable owner (clause 6.1.3) and periodic review (clause 8.2), per `docs/proposals/compliance-records.md` Proposal 1. Most Blueprint users do not need this, so it is opt-in through a roster file rather than a default section.

Context budget shapes placement. Agents read ADRs only up to `## Context` (ADR-006 routing, `adr-reading`), so Decision holds only operational content: `Enforced by` belongs there because it changes what the agent runs. Risk and Revisit when are review material, so they sit after Consequences; Exceptions may carry a short pointer such as "(accepted risk, see Risk)", and `validate` sweeps their dates repo-wide since prefix reads never reach them.

## Options Considered

### Option 1: Frontmatter `applies_to` globs
- Pro: Machine-matchable scope
- Con: A second source of scope that drifts from the `**Applies to:**` prose
- Con: Agents anchor on glob matches and skip the title scan, missing concept-only and repository-wide decisions
- Rejected; `**Applies to:**` names concrete paths where scope is tied to code, and discovery starts with a title scan

### Option 2: A `decided_by` field
- Con: Duplicates git; whoever merges the PR is the decider
- Rejected

### Option 3: PR gates shipped by Blueprint
- Con: Requires a runtime or CI integration, which ADR-006 excludes; repositories own their gates
- Rejected; `validate` reports with severities a repository can gate on

### Option 4: Lore-style commit trailers for decisions
- Pro: Decision metadata travels with commits
- Con: Not visible to agents reading the docs tree; splits intent across commits and files
- Not adopted

## Consequences

**Positive:**
- Agent-originated architecture becomes visible in review instead of silently becoming precedent
- Accepted risks get owner, review date, and validation without a separate register
- All additions are optional; existing ADRs and repositories need no migration

**Negative:**
- More status and field vocabulary in templates, skills, and validation
- Two branches can allocate the same number; validate reports duplicates and the unmerged one is renumbered
- Risk tracking depends on a roster that each repository maintains

## Related

- [ADR-004](004-decision-capture-approach.md), [ADR-006](006-skills-and-repo-files-only.md)
- [Compliance records proposal](../proposals/compliance-records.md)
- [AI-agent readability spec](../specs/features/ai-agent-readability.md)
