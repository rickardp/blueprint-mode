---
name: decide
description: Record a decision and its rationale as an ADR, a UX decision, or a DESIGN.md rule. Use when the user states a technology, architecture, or UX choice together with why, or asks to document a decision.
argument-hint: "[topic] because [reason]"
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Record Decision

Write the decision the user stated to the right place, with its rationale. Formats are in `../_templates/TEMPLATES.md` (relative to this skill's directory): `adr-reading`, `adr-template`, `ux-decision-template`, `design-separation`, `working-style`.

## Steps

1. Extract the choice, the rationale, and any rejected alternatives from the argument and the conversation.
2. Classify each concern in the input:
   - Tech, library, infra, runtime, code-level pattern: ADR in `docs/adrs/`
   - One UX choice with alternatives (modal vs page, navigation model, copy for a flow): UX decision in `design/ux-decisions/`, only if that directory exists
   - Cross-cutting design rule or prohibition: one bullet in `DESIGN.md`, if present or the user agrees to scaffold it
   - A requirement with no decision in it: create the spec as `/blueprint-mode:require` would and say so
   Mixed input produces one file per concern.
3. Select relevant ADRs per `adr-reading`; check the target tree for an existing decision on the topic. Read the full existing decision before classifying an update as clarification, compatible extension, or conflict. Clarify in place only when the choice and its established scope and constraints remain unchanged; assess supersession when they change.
4. Gather what is still missing in one message: the rationale if none was given, whether a conflicting decision is being replaced if the user has not already resolved that, which reviewers own an ambiguous case when a design tree exists, and, when the input is clearly UX but `design/ux-decisions/` does not exist, whether to run `/blueprint-mode:onboard-design` first or file it as an ADR whose Context notes it holds UX rationale. Accept "skip": write a Draft with `<!-- TODO: -->` markers. When the input is plainly architectural and the repo has neither `design/` nor `DESIGN.md`, do not mention design at all.
5. Write to the selected destination using its template. For ADRs, keep Decision self-contained with established scope and constraints; keep motivation and alternatives in the rationale sections. Do not invent scope or constraints. New decisions use one past the highest number in their directory; the slug describes the title. A replacement follows `/blueprint-mode:supersede`.
6. Report each file created or updated.

## Output

```
Created ADR-NNN at docs/adrs/NNN-slug.md
Created UX-NNN at design/ux-decisions/NNN-slug.md
Updated DESIGN.md: [rule]
```
