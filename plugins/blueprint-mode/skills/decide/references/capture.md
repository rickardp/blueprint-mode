# Capture Earlier Conversation

Use when the user asks to save agreed intent or progress from earlier conversation. This reference selects input; the parent [decide workflow](../SKILL.md#steps) owns decision classification, status, conflicts, and writing.

1. Scan the requested topic or conversation for human-stated decisions and reasons, requirements, approved or rejected patterns, resolved questions, and reported implementation progress. Distinguish settled intent from suggestions, discarded alternatives, and assistant speculation. For UI, capture intent only where a person confirmed a deliberate choice.
2. Compare candidates with the existing documents. Skip already-recorded items and code-derived facts that add no intent or progress update. Use the latest explicit resolution when the conversation changes a choice; keep unresolved contradictions visible.
3. Route the selected items:
   - Decisions and design rules: use the parent decide steps. Conversation capture does not make a decision Draft by default.
   - Requirements: use [require](../../require/SKILL.md), including ADR conflict assessment.
   - Approved examples or anti-patterns: use [good-pattern](../../good-pattern/SKILL.md) or [bad-pattern](../../bad-pattern/SKILL.md).
   - Progress or resolved questions: update the existing spec’s Implementation State and maturity from the reported evidence, without treating progress as a new architectural decision. If the update changes requirements, use require; if it changes a decision, use the parent decide steps.
4. Batch missing-information questions across the selected items. Apply the destination workflow’s treatment of unknowns; do not ask again for answers already in the conversation. A capture request does not authorize inventing rationale, enabling a design tree, or silently replacing an Active decision.
5. Report files created or updated once for the whole capture. Show old and new text when replacing existing rationale. Identify any unresolved or skipped requested items and why; mention missing design destinations only when they prevented a requested capture.
