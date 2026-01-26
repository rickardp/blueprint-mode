#!/bin/bash
# Blueprint Mode Context Injection Hook
# Runs on UserPromptSubmit - injects context when Blueprint skills are invoked

# Read JSON input from stdin
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

# Read-only skills - no special context needed
if echo "$PROMPT" | grep -qE '/blueprint:(status|list-adrs|help|validate)'; then
  exit 0
fi

# Write-oriented skills - inject execution rules
if echo "$PROMPT" | grep -qE '/blueprint:(onboard|decide|require|good-pattern|bad-pattern|setup-repo|supersede)'; then
  cat << 'EOF'
BLUEPRINT SKILL EXECUTION RULES (MANDATORY):

1. PLAN BEFORE ACTION - Analyze in plan mode and gather information
2. DO NOT ASK FOR SCOPE - User invoked a Blueprint skill, assume user want it fully implemented
3. NO NUMBERED OPTIONS - Never offer "1. Full setup 2. Partial 3. Other"
4. ASK FOR CLARIFICATION - Especially on rationale gaps or requirement gaps. Use AskUserQuestion and suggest alternatives. Accept TBD answers.
4. CREATE FILES NOW - Analyze the repo and create Blueprint structure
5. USE TBD MARKERS - For missing information, write "TBD" instead of asking

FORBIDDEN (will break the workflow):
- "Would you like me to..."
- "Which approach would you prefer?"
- "Should I create..."
- Any numbered list offering choices about WHAT to create
- Asking whether to do full vs partial setup

ALLOWED (content questions only):
- "Why was [technology] chosen?" (filling rationale gaps)
- "Who are the primary users?" (if not found in existing docs)

The user invoked a Blueprint skill. This means they want you to CREATE the structure, not ask about it. Proceed with full execution.
EOF
elif echo "$PROMPT" | grep -qE '/blueprint:'; then
  # Unknown blueprint skill - warn that no rules were applied
  cat << 'EOF'
Warning: Unrecognized Blueprint skill. No context rules were applied.

Known skills:
- Read-only: status, list-adrs, help, validate
- Write-oriented: onboard, decide, require, good-pattern, bad-pattern, setup-repo, supersede

If this is a new skill, update hooks/blueprint-context.sh to include it.
EOF
fi

exit 0
