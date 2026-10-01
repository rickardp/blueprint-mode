---
name: decide
description: Record architectural or UX decisions and their rationale. Use when the user states a choice and why, asks to document a decision, or asks to save agreed decisions, requirements, patterns, or progress from the conversation.
allowed-tools: Read, Glob, Grep, Write, Edit
---

# Record Decision

Write the decision the user stated to the right place, with its rationale. Formats are in `../_templates/TEMPLATES.md` (relative to this skill's directory): `adr-reading`, `adr-template`, `ux-decision-template`, `decision-lifecycle`, `design-separation`, `working-style`.

## Choose the input

For a specific decision, use the steps below. When the user asks to capture or save earlier conversation, read [Conversation capture](references/capture.md) to select and route items, then use these same steps for each decision. A session ending alone does not trigger capture. The user’s request defines scope in either case.

## Steps

1. Extract the choice, the rationale, and any rejected alternatives from the request and the conversation.
2. Classify each concern in the input:
   - Tech, library, infra, runtime, code-level pattern: ADR in `docs/adrs/`
   - One UX choice with alternatives (modal vs page, navigation model, copy for a flow): UX decision in `design/ux-decisions/`, only if that directory exists
   - Cross-cutting design rule or prohibition: one bullet in `DESIGN.md`, if present or the user agrees to scaffold it
   - A requirement with no decision in it: create the spec as `require` skill would and say so
   Mixed input produces one file per concern.
3. Select relevant ADRs per `adr-reading`; check the target tree for an existing decision on the topic. Read the full existing decision before assessing a clarification, extension, or changed choice. When the user has authorized changing that decision, rewrite it in place, keeping its number and updating its rationale; git preserves prior choices. A changed choice does not require a new ADR. Create a new record only for an independent decision or an explicitly requested separate replacement.
4. Gather what is still missing in one message: the rationale if none was given, whether a conflicting decision is being replaced if the user has not already resolved that, which reviewers own an ambiguous case when a design tree exists, and, when the input is clearly UX but `design/ux-decisions/` does not exist, whether to enable design intent capture first or file it as an ADR whose Context notes it holds UX rationale. Accept "skip": write a Draft with `<!-- TODO: -->` markers. When the input is plainly architectural and the repo has neither `design/` nor `DESIGN.md`, do not mention design at all.
5. Write to the selected destination using its complete template. Decisions are Active when the user has settled the choice and its rationale is known; use Draft for unsettled decisions or missing rationale, regardless of whether the input came directly or from earlier conversation. For ADRs, keep Decision self-contained with established scope and constraints; keep motivation and alternatives in the rationale sections. Do not invent scope or constraints. Preserve the number when rewriting; allocate new numbers per `decision-lifecycle`. The slug describes the title. Explicit separate replacements and retirements follow `supersede` skill.
6. Report each file created or updated.

## Output

```
Created ADR-NNN at docs/adrs/NNN-slug.md
Created UX-NNN at design/ux-decisions/NNN-slug.md
Updated DESIGN.md: [rule]
```
