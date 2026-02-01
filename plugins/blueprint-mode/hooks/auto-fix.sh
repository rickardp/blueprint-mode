#!/bin/bash
# Blueprint Mode Auto-Fix Hook
# Runs on PostToolUse for Write operations - automatically fixes common format issues

# Read JSON input from stdin
INPUT=$(cat)

# Extract tool information
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Only process Write operations
if [ "$TOOL_NAME" != "Write" ]; then
  exit 0
fi

# Only process files that exist
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

FIXES_MADE=()

# =============================================================================
# ADR Auto-Fixes (docs/adrs/*.md)
# =============================================================================
if [[ "$FILE_PATH" == */docs/adrs/*.md ]]; then

  # Fix: **Benefits:** -> **Positive:**
  if grep -q '\*\*Benefits:\*\*' "$FILE_PATH"; then
    sed -i '' 's/\*\*Benefits:\*\*/\*\*Positive:\*\*/g' "$FILE_PATH"
    FIXES_MADE+=("Benefits: -> Positive:")
  fi

  # Fix: **Trade-offs:** -> **Negative:**
  if grep -q '\*\*Trade-offs:\*\*' "$FILE_PATH"; then
    sed -i '' 's/\*\*Trade-offs:\*\*/\*\*Negative:\*\*/g' "$FILE_PATH"
    FIXES_MADE+=("Trade-offs: -> Negative:")
  fi

  # Fix: **Tradeoffs:** -> **Negative:**
  if grep -q '\*\*Tradeoffs:\*\*' "$FILE_PATH"; then
    sed -i '' 's/\*\*Tradeoffs:\*\*/\*\*Negative:\*\*/g' "$FILE_PATH"
    FIXES_MADE+=("Tradeoffs: -> Negative:")
  fi

  # Fix: **Pros:** -> **Positive:**
  if grep -q '\*\*Pros:\*\*' "$FILE_PATH"; then
    sed -i '' 's/\*\*Pros:\*\*/\*\*Positive:\*\*/g' "$FILE_PATH"
    FIXES_MADE+=("Pros: -> Positive:")
  fi

  # Fix: **Cons:** -> **Negative:**
  if grep -q '\*\*Cons:\*\*' "$FILE_PATH"; then
    sed -i '' 's/\*\*Cons:\*\*/\*\*Negative:\*\*/g' "$FILE_PATH"
    FIXES_MADE+=("Cons: -> Negative:")
  fi

  # Fix: ## References -> ## Related
  if grep -q '^## References' "$FILE_PATH"; then
    sed -i '' 's/^## References/## Related/g' "$FILE_PATH"
    FIXES_MADE+=("## References -> ## Related")
  fi

  # Fix: status: Accepted -> status: Active
  if grep -q '^status: Accepted' "$FILE_PATH"; then
    sed -i '' 's/^status: Accepted/status: Active/g' "$FILE_PATH"
    FIXES_MADE+=("status: Accepted -> status: Active")
  fi

fi

# =============================================================================
# Feature Spec Auto-Fixes (docs/specs/features/*.md)
# =============================================================================
if [[ "$FILE_PATH" == */docs/specs/features/*.md ]]; then

  # Fix: ## Description -> ## Overview
  if grep -q '^## Description' "$FILE_PATH"; then
    sed -i '' 's/^## Description/## Overview/g' "$FILE_PATH"
    FIXES_MADE+=("## Description -> ## Overview")
  fi

  # Fix: ## Stories -> ## User Stories
  if grep -q '^## Stories' "$FILE_PATH"; then
    sed -i '' 's/^## Stories/## User Stories/g' "$FILE_PATH"
    FIXES_MADE+=("## Stories -> ## User Stories")
  fi

  # Fix: status: Done -> status: Active
  if grep -q '^status: Done' "$FILE_PATH"; then
    sed -i '' 's/^status: Done/status: Active/g' "$FILE_PATH"
    FIXES_MADE+=("status: Done -> status: Active")
  fi

  # Fix: status: Complete -> status: Active
  if grep -q '^status: Complete' "$FILE_PATH"; then
    sed -i '' 's/^status: Complete/status: Active/g' "$FILE_PATH"
    FIXES_MADE+=("status: Complete -> status: Active")
  fi

  # Fix: status: Todo -> status: Planned
  if grep -q '^status: Todo' "$FILE_PATH"; then
    sed -i '' 's/^status: Todo/status: Planned/g' "$FILE_PATH"
    FIXES_MADE+=("status: Todo -> status: Planned")
  fi

fi

# =============================================================================
# Boundaries Auto-Fixes (docs/specs/boundaries.md)
# =============================================================================
if [[ "$FILE_PATH" == */docs/specs/boundaries.md ]]; then

  # Fix: # Boundaries -> # Agent Boundaries
  if grep -q '^# Boundaries$' "$FILE_PATH"; then
    sed -i '' 's/^# Boundaries$/# Agent Boundaries/g' "$FILE_PATH"
    FIXES_MADE+=("# Boundaries -> # Agent Boundaries")
  fi

  # Fix: ## Do Always -> ## Always Do
  if grep -q '^## Do Always' "$FILE_PATH"; then
    sed -i '' 's/^## Do Always/## Always Do/g' "$FILE_PATH"
    FIXES_MADE+=("## Do Always -> ## Always Do")
  fi

  # Fix: ## Ask Before -> ## Ask First
  if grep -q '^## Ask Before' "$FILE_PATH"; then
    sed -i '' 's/^## Ask Before/## Ask First/g' "$FILE_PATH"
    FIXES_MADE+=("## Ask Before -> ## Ask First")
  fi

  # Fix: ## Don't Do -> ## Never Do
  if grep -q "^## Don't Do" "$FILE_PATH"; then
    sed -i '' "s/^## Don't Do/## Never Do/g" "$FILE_PATH"
    FIXES_MADE+=("## Don't Do -> ## Never Do")
  fi

  # Fix: ## Prohibited -> ## Never Do
  if grep -q '^## Prohibited' "$FILE_PATH"; then
    sed -i '' 's/^## Prohibited/## Never Do/g' "$FILE_PATH"
    FIXES_MADE+=("## Prohibited -> ## Never Do")
  fi

fi

# =============================================================================
# Anti-Pattern Auto-Fixes (patterns/bad/anti-patterns.md)
# =============================================================================
if [[ "$FILE_PATH" == */patterns/bad/anti-patterns.md ]]; then

  # Fix: ### Wrong Way -> ### Don't Do This
  if grep -q '^### Wrong Way' "$FILE_PATH"; then
    sed -i '' "s/^### Wrong Way/### Don't Do This/g" "$FILE_PATH"
    FIXES_MADE+=("### Wrong Way -> ### Don't Do This")
  fi

  # Fix: ### Right Way -> ### Do This Instead
  if grep -q '^### Right Way' "$FILE_PATH"; then
    sed -i '' 's/^### Right Way/### Do This Instead/g' "$FILE_PATH"
    FIXES_MADE+=("### Right Way -> ### Do This Instead")
  fi

  # Fix: ### Better -> ### Do This Instead
  if grep -q '^### Better' "$FILE_PATH"; then
    sed -i '' 's/^### Better/### Do This Instead/g' "$FILE_PATH"
    FIXES_MADE+=("### Better -> ### Do This Instead")
  fi

  # Fix: **Level:** -> **Severity:**
  if grep -q '\*\*Level:\*\*' "$FILE_PATH"; then
    sed -i '' 's/\*\*Level:\*\*/\*\*Severity:\*\*/g' "$FILE_PATH"
    FIXES_MADE+=("**Level:** -> **Severity:**")
  fi

fi

# =============================================================================
# Report Fixes
# =============================================================================
if [ ${#FIXES_MADE[@]} -gt 0 ]; then
  echo "Auto-fixed format issues in $FILE_PATH:"
  for fix in "${FIXES_MADE[@]}"; do
    echo "  - $fix"
  done
fi

exit 0
