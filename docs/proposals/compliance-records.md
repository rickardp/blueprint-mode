# Proposal: compliance-ready records in Blueprint

Date: 2026-11-09
Status: Proposal 1 (Risk section) is implemented in 2.2.0 via [ADR-007](../adrs/007-proposed-decisions-and-opt-in-risk-records.md), opt-in through a `docs/specs/risk-owners.md` roster that lists who may own a risk. Proposals 2 and 3 remain open research.

## Background

Combination is assessing ISO/IEC 27001, ISO/IEC 42001, and the EU AI Act. Product repositories already use Blueprint (for example Apporium's `cas-backend` and `cas-storefront`: `docs/adrs/`, `design/ux-decisions/`, `docs/specs/`, `docs/runbooks/`, and a `bun check:decisions` script). The goal is to let these records serve as compliance evidence with as little extra process as possible, so agents and humans keep working as they do today.

Blueprint's current format already covers most needs:

- `status` and `date` frontmatter, IDs (`ADR-NNN`, `UX-NNN`), Decision first with Applies to, Constraints, and Exceptions, then Context, Options Considered, Consequences, Related
- Changed choices are rewritten in place; retired records are deleted from the head and kept in git history. This was chosen because coding agents treated superseded records as active. It is compatible with ISO/IEC 27001 7.5.3 (retention of documented information) as long as git history is preserved
- Approval and authorship come from git and the merged pull request

Two gaps remain: accepted risks have no structured place, and AI systems have no single record.

## Proposal 1: optional Risk section on decisions

For ADRs and UX decisions that accept a risk instead of fixing it, or meet a requirement another way (compensating control, exception). Other decisions have no Risk section. "No risk identified" needs no section and no statement; downsides found go in Consequences as today.

```markdown
## Risk

**Accepted risk:** Source code readable from build agent disks if a machine is stolen.
**Why acceptable:** Agents sit in the locked server room with restricted access; disks are wiped before disposal.
**Risk owner:** <role, such as CTO or IT manager>
**Review by:** 2027-11-09
```

Placement: after Consequences, before Related (decided in ADR-007); Exceptions under Decision carries a short pointer.

Changes:

- **Template** (`_templates/TEMPLATES.md`, ADR and UX sections): document the optional section. No new frontmatter fields.
- **`decide` skill, step 4:** when the input accepts a risk, rejects a finding, or meets a requirement another way, the single question message also asks for risk owner (a role) and review date. If missing, write a Draft with `<!-- TODO: -->`. Never invent an owner.
- **`validate` skill:** a Risk section must have both **Risk owner** and **Review by**; report a Review by date in the past as "risk acceptance due for review". This gives the periodic review of accepted risks without a separate register.

In a product repository an unqualified role ("product owner") means that role for the product named in `docs/specs/product.md`; records in shared or company-level repositories qualify it ("Apporium product owner").

Risk owner is a role, not a person: ownership survives people leaving, and the record holds no names beyond what git already has (GDPR data minimisation, and git history cannot easily be edited). ISO/IEC 27000 defines a risk owner as a "person or entity with the accountability and authority to manage a risk", so a role, or a body such as the management team, is valid. The approving person is identified by the merged pull request.

Standards basis: ISO/IEC 27001 and ISO/IEC 42001 clause 6.1.3 (risk owners approve treatment and accept residual risk) and 8.2 (risk assessment repeated at planned intervals).

## Proposal 2: AI system record

One file per AI system, in the repository that runs it: `docs/specs/ai-systems/<system>.md` (path to research). It links to ADRs, UX decisions, and feature specs instead of repeating them. Scaled to impact: a few lines per section for low-impact systems.

```markdown
---
status: Active
date: <date>
---

# AI-<NNN>: <System name>

## Purpose
<What it does, intended use, who sees the output. Links to feature specs.>

## Role and classification
<Provider or deployer. AI Act: prohibited practices (none, why), transparency obligations and how they are met, high-risk (no, why).>

## Models and data
<Models and providers, regions, terms. Data in and out; personal data; data used to build or evaluate, with source.>

## Impact
<Who can be affected and how; mitigations.>

## Oversight and transparency
<Human review before output reaches people; labelling of AI output.>

## Verification and monitoring
<Acceptance tests or evaluation criteria; event logging; what is monitored and who acts.>

## Related
<ADRs, UX decisions, feature specs, runbooks, external requirement or finding IDs.>
```

Updated in the same pull request as any change to the system's model, provider, data, output, or oversight; that also repeats the impact check.

Standards basis: ISO/IEC 42001 6.1.4 and A.5.2–A.5.5 (impact assessment), A.4.2–A.4.6 (resources), A.6.2.2–A.6.2.8 (life cycle: requirements, design, verification, deployment, monitoring, event logs), A.7 (data), A.8.2 (information for users); EU AI Act Art. 5, 6, and 50 (classification and transparency).

Changes:

- **Template:** new `ai-system-template` section.
- **Skill:** either a new small skill (for example `ai-system`) or routing from `decide`/`require` when the input describes an AI system. To research.
- **`validate`:** flag an AI system record whose Related ADRs or UX decisions changed after its `date`; flag runtime AI use in code with no AI system record (optional, may be too heuristic).
- **`status` / `onboard`:** list AI system records; offer to create one when onboarding finds runtime AI use.

## Proposal 3 (small): external IDs in Related

Allow requirement and finding IDs from outside the repository (for example `DEV-006-A`, `ITS-007`) in `## Related`, so a decision can show which compliance requirement it settles. Probably documentation only; `validate` should not treat them as broken links.

## Not part of Blueprint

- Approval through merged pull requests and protecting the default branch against history rewrites and deletion: repository settings
- Company-level records (policies, scope, risk assessment, Statement of Applicability, supplier list, audits): kept in a separate management system repository, which may itself use the Blueprint decision format

## Constraints from this repository

From `CLAUDE.md` and `docs/specs/boundaries.md`:

- Markdown only: no runtime, scripts, hooks, or build steps
- Formats live only in `_templates/TEMPLATES.md`; skills point at sections
- Changing a file format that users' repositories already contain needs approval first. Proposals 1 and 3 are additive and optional; check that existing records stay valid
- Skills stay under 80 lines

## Research questions

1. Does the Risk section belong before Context (read by agents through `adr-reading`) or after Consequences? Agents need to know an exception exists when applying a decision. *Answered (2.2.0): after Consequences, keeping prefix reads short; validate sweeps Review by dates repo-wide.*
2. Is a Risk section enough for exceptions, or should Exceptions under Decision link to it? *Answered (2.2.0): Exceptions carries a short pointer such as "(accepted risk, see Risk)"; applying the decision does not require reading Risk.*
3. Should AI system records live under `docs/specs/` or as their own tree, and use their own ID prefix (`AI-NNN`)?
4. New skill or routing in `decide`/`require` for AI system records, within the 80-line limit?
5. Can `validate` detect stale AI system records reliably from dates and Related links alone?
6. How do these additions interact with `decision-lifecycle` (retiring an AI system, retiring a risk acceptance when the risk is fixed)?
7. Does `onboard` need changes to detect runtime AI use, or is that out of scope?
