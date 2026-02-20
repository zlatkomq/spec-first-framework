---
name: 'step-01-spec'
description: 'Create or update SPEC.md for this feature'
nextStepFile: './step-02-design.md'

# References
ruleRef: '@skills/spec-creation/SKILL.md'
templateRef: '@.framework/templates/SPEC.template.md'
constitutionRef: '@.framework/CONSTITUTION.md'
stateFile: '{spec_folder}/.workflow-state.md'
outputFile: '{spec_folder}/SPEC.md'
---

# Step 1: Create Specification

**Progress: Step 1 of 5** — Next: Technical Design

## STEP GOAL

Create (or update) SPEC.md for this feature by applying the spec-creation rules and template. Gather requirements from the user through conversation; do not invent requirements.

## RULES

- READ this entire step file before taking any action.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Use the template from {templateRef}.
- Load project context from {constitutionRef}.
- HALT and WAIT for user input at every menu.
- Do NOT load or look ahead to future step files.

## GATE

None — this is the first step.

## SEQUENCE

### 1. Gather requirements

- If the user provided a requirement description (from the `/flow` command message), use it as starting input.
- Otherwise, ask: "What feature are you building? Describe the requirements."

### 2. Write SPEC.md

- Apply {ruleRef} using {templateRef}; save to `{outputFile}`.
- Present the completed SPEC.md to the user.
- Ask: "Review the SPEC. Approve it (say 'approve' or 'yes'), or tell me what to change."

### 3. Approval gate

- If user approves: update SPEC.md status per {ruleRef}.
- If user requests changes: apply, re-save, re-present. Loop until approved.

### 4. Present MENU

```
SPEC.md is APPROVED.

[C] Continue — proceed to Technical Design (Step 2 of 5)
[B] Back to Spec — re-edit SPEC.md
[X] Exit — pause workflow; resume later with /flow
```

- **[C]:** Update `{stateFile}`: append `'step-01-spec'` to `stepsCompleted`. Load and follow `{nextStepFile}`.
- **[B]:** Return to section 1. Redisplay menu after approval.
- **[X]:** Update `{stateFile}`: append `'step-01-spec'` to `stepsCompleted` (if approved). Display: "Workflow paused. Run `/flow {spec_id}` to resume." STOP.
- **Anything else:** Answer, then redisplay menu.
