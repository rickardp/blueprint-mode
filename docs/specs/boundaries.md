# Agent Boundaries

## Always Do

- Run `/blueprint:validate` before committing changes that affect documented decisions
- Follow existing code patterns in the codebase
- Read ADRs before implementing features that touch documented decisions
- Use patterns from `patterns/good/`
- Link code to ADRs in comments when implementing documented decisions: `// ADR-NNN: brief note`
- Keep comments brief - document design intent in specs, not inline

## Ask First

### Architecture
- Changing the plugin's hook injection strategy
- Adding new file formats beyond Markdown
- Modifying the skill/template structure

### Breaking Changes
- Changing ADR or spec file formats
- Modifying hook output format
- Renaming or removing skills

### Dependencies
- Adding ANY runtime dependency (Node.js, Python, etc.)
- Adding external service integrations

### Blueprint
- Adding or editing ADRs in docs/adrs/
- Adding or editing specs in docs/specs/
- Modifying boundaries.md

## Never Do

### Security
- Commit secrets or credentials
- Execute arbitrary code from user input in hooks

### Code
- Add runtime dependencies - this is a zero-dependency plugin
- Create build steps or compilation requirements
- Add features that don't work without external services

### Documentation
- Create ad-hoc README/markdown files outside the docs/ structure without prior agreement
- Add excessive comments (code should be self-documenting)
- Duplicate rationale that belongs in ADRs

## Scoped Rules

### plugins/blueprint-mode/hooks/
**Always Do:**
- Keep hooks fast (< 1 second execution)
- Output clean, parseable text
- Handle missing files gracefully (don't error on empty dirs)

**Never Do:**
- Make network requests
- Modify files (hooks are read-only)
- Use non-portable bash features

### plugins/blueprint-mode/skills/
**Always Do:**
- Follow TEMPLATES.md for file formats
- Keep skills under 100 lines
- Use imperative commands, not questions about scope

**Never Do:**
- Generate code (skills document decisions, not produce code)
- Ask scope questions ("what would you like to create?")
