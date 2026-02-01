#!/bin/bash
# Blueprint Mode Context Injection Hook
# Runs on UserPromptSubmit - injects context and agent personas when Blueprint skills are invoked

# Read JSON input from stdin
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

# Determine the plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
AGENTS_DIR="$PLUGIN_ROOT/agents"

# Read-only skills - no special context needed
if echo "$PROMPT" | grep -qE '/blueprint:(status|list-adrs|help|validate)'; then
  exit 0
fi

# =============================================================================
# Skill-to-Agent Mapping
# =============================================================================

AGENT_FILE=""

# ADR-related skills
if echo "$PROMPT" | grep -qE '/blueprint:(decide|supersede)'; then
  AGENT_FILE="$AGENTS_DIR/adr.md"
fi

# Requirement skills - determine type from context
if echo "$PROMPT" | grep -qE '/blueprint:require'; then
  # Check if the prompt suggests NFR (performance, security, scalability, reliability)
  if echo "$PROMPT" | grep -qiE 'performance|security|scalability|reliability|uptime|latency|throughput'; then
    AGENT_FILE="$AGENTS_DIR/nfr.md"
  else
    AGENT_FILE="$AGENTS_DIR/feature-spec.md"
  fi
fi

# Pattern skills
if echo "$PROMPT" | grep -qE '/blueprint:(good-pattern|bad-pattern)'; then
  AGENT_FILE="$AGENTS_DIR/pattern.md"
fi

# Comprehensive setup skills - use all agents combined
if echo "$PROMPT" | grep -qE '/blueprint:(onboard|setup-repo)'; then
  AGENT_FILE="$AGENTS_DIR/all.md"
fi

# =============================================================================
# Output Execution Rules + Agent Persona
# =============================================================================

# Write-oriented skills - inject execution rules
if echo "$PROMPT" | grep -qE '/blueprint:(onboard|decide|require|good-pattern|bad-pattern|setup-repo|supersede)'; then
  cat << 'EOF'
BLUEPRINT SKILL EXECUTION RULES (MANDATORY):

1. PLAN BEFORE ACTION - Analyze in plan mode and gather information
2. DO NOT ASK FOR SCOPE - User invoked a Blueprint skill, assume user want it fully implemented
3. NO NUMBERED OPTIONS - Never offer "1. Full setup 2. Partial 3. Other"
4. ASK FOR CLARIFICATION - Especially on rationale gaps or requirement gaps. Use AskUserQuestion and suggest alternatives. Accept TBD answers.
5. CREATE FILES NOW - Analyze the repo and create Blueprint structure
6. USE TBD MARKERS - For missing information, write "TBD" instead of asking

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

  # Inject agent persona if one was selected
  if [ -n "$AGENT_FILE" ] && [ -f "$AGENT_FILE" ]; then
    echo ""
    echo "============================================================================="
    echo "AGENT PERSONA - Follow this format EXACTLY"
    echo "============================================================================="
    echo ""
    cat "$AGENT_FILE"
  fi

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
