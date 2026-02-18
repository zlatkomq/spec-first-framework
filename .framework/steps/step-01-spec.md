---
name: 'step-01-spec'
description: 'Create or update SPEC.md for this feature'
nextStepFile: './step-02-design.md'

# References
ruleRef: '@.cursor/rules/spec-creation.mdc'
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

- None — this is the first step. No prerequisites.

## SEQUENCE

### 1. Gather requirements

- If the user has already provided a requirement description (from the `/flow` command message), use it as the starting input.
- If not, ask: "What feature are you building? Describe the requirements."
- Apply {ruleRef} using {templateRef}; build the SPEC.md and save to `{outputFile}` per {ruleRef}.

### 2. Write SPEC.md

- Save to `{outputFile}` per {ruleRef}.
- Present the completed SPEC.md to the user.
- Ask: "Review the SPEC. When you're satisfied, **approve it** (say 'approve' or 'yes'). Or tell me what to change."

### 3. Approval gate

- If user approves: update SPEC.md status per {ruleRef}.
- If user requests changes: apply changes, re-save, re-present, loop back to approval gate.
- Once approved per {ruleRef}, proceed to menu.

### 4. Present MENU

Display:

```
SPEC.md is APPROVED.

[C] Continue — proceed to Technical Design (Step 2 of 5)
[B] Back to Spec — re-edit SPEC.md
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

- **IF [C] Continue:**
  1. Update `{stateFile}` frontmatter: append `'step-01-spec'` to `stepsCompleted`.
  2. Read fully and follow: `{nextStepFile}` (step-02-design.md).
- **IF [B] Back to Spec:**
  - Return to section 1 (gather/edit requirements). Loop until user is satisfied and approves.
  - Redisplay this menu after approval.
- **IF [X] Exit:**
  - Update `{stateFile}` frontmatter: append `'step-01-spec'` to `stepsCompleted` (if SPEC is approved per {ruleRef}).
  - Display: "Workflow paused. Run `/flow {spec_id}` to resume."
  - STOP.
- **IF anything else:** Answer user's question, then redisplay menu.

## CRITICAL COMPLETION NOTE

ONLY when [C] is selected and `stepsCompleted` is updated will you load and execute `{nextStepFile}`.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied.
- Status approved per {ruleRef} before continuing.
- State file updated with this step before loading next.

## FAILURE CONDITIONS

- Proceeding to design before SPEC is approved per {ruleRef}.
- Not updating state file before loading next step.
- Loading next step before user selects [C].
