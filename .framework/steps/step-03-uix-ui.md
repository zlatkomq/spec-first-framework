---
name: 'step-03-uix-ui'
description: 'Create or update UIX-UI.md for this feature'
nextStepFile: './step-04-tasks.md'

# References
ruleRef: '@.cursor/rules/uix-ui-creation.mdc'
templateRef: '@.framework/templates/UIX-UI.template.md'
constitutionRef: '@.framework/CONSTITUTION.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
outputFile: '{spec_folder}/UIX-UI.md'
---

# Step 3: Create UIX/UI Specification

**Progress: Step 3 of 6** — Next: Task Breakdown

## STEP GOAL

Create (or update) UIX-UI.md by applying the uix-ui-creation rules and template. The UIX/UI spec translates the approved SPEC (what to build) and DESIGN (how to build it) into concrete UI component specifications, screen layouts, interaction patterns, and accessibility requirements — following CONSTITUTION.md standards.

## RULES

- READ this entire step file before taking any action.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Use the template from {templateRef}.
- Load project context from {constitutionRef}.
- Load the approved SPEC.md from {specFile}.
- Load the approved DESIGN.md from {designFile}.
- HALT and WAIT for user input at every menu.
- Do NOT load or look ahead to future step files.

## GATE

- Prerequisite: per {ruleRef}, required inputs must be satisfied (SPEC approved AND DESIGN approved). If DESIGN is not approved: display a short message that UIX-UI cannot be created until DESIGN is approved; offer `[B] Back to Design (step 2)` | `[X] Exit`. On [B]: load and follow `./step-02-design.md`. On [X]: STOP.

## SEQUENCE

### 1. Load inputs

- Read {specFile} completely (user stories, acceptance criteria).
- Read {designFile} completely (API specs, data models, architecture, component list).
- Read {constitutionRef} for project standards (tech stack, component library, styling conventions, accessibility standards).

### 2. Ask for Figma URLs (optional)

- Ask: "Do you have Figma design URLs for this feature? Paste them here, or say 'skip' to proceed without Figma."
- If user provides Figma URLs: use Figma MCP tools per {ruleRef} to extract design data before creating the artifact.
- If user says 'skip' or provides no URLs: proceed to create the artifact from SPEC + DESIGN alone.

### 3. Check if UIX-UI.md already exists

- If `{outputFile}` exists:
  - Read it and present its current state.
  - Ask: "UIX-UI.md already exists. Do you want to **update** it or **continue** to the next step?"
  - If update: proceed to section 4.
  - If continue and Status is APPROVED: skip to menu (section 6).
  - If continue but Status is DRAFT: inform user "UIX-UI must be APPROVED before continuing." Redisplay choice.
- If not exists: proceed to section 4.

### 4. Create UIX-UI.md

- Apply {ruleRef} using {templateRef}. Save to `{outputFile}` with Status: DRAFT.
- If Figma data was extracted in section 2, incorporate it per {ruleRef} translation rules.

### 5. Approval gate

- Present the completed UIX-UI.md to the user.
- Ask: "Review the UIX/UI spec. Approve it (say 'approve' or 'yes') or tell me what to change."
- If user approves: update UIX-UI.md Status → APPROVED.
- If user requests changes: apply, re-save, re-present, loop.

### 6. Present MENU

Display:

```
UIX-UI.md is APPROVED.

[C] Continue — proceed to Task Breakdown (Step 4 of 6)
[V] View DESIGN.md — display for reference (read-only)
[V2] View SPEC.md — display for reference (read-only)
[B] Back to Design — re-edit DESIGN.md (step 2)
[B2] Back to Spec — re-edit SPEC.md (step 1)
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

- **IF [C] Continue:**
  1. Update `{stateFile}`: append `'step-03-uix-ui'` to `stepsCompleted`.
  2. Read fully and follow: `{nextStepFile}` (step-04-tasks.md).
- **IF [V] View DESIGN.md:**
  1. Read and display the full content of {designFile}.
  2. Redisplay this menu (no state changes).
- **IF [V2] View SPEC.md:**
  1. Read and display the full content of {specFile}.
  2. Redisplay this menu (no state changes).
- **IF [B] Back to Design:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep only entries up to and including `'step-01-spec'` (remove `'step-02-design'` and `'step-03-uix-ui'` if present).
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-02-design.md`.
- **IF [B2] Back to Spec:**
  1. Set `stepsCompleted` in `{stateFile}` to `[]` (empty).
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-01-spec.md`.
- **IF [X] Exit:**
  - Update `{stateFile}`: append `'step-03-uix-ui'` to `stepsCompleted` (if UIX-UI is APPROVED).
  - Display: "Workflow paused. Run `/flow {spec_id}` to resume."
  - STOP.
- **IF anything else:** Answer, then redisplay menu.

## CRITICAL COMPLETION NOTE

ONLY when [C] is selected and state is updated will you load and execute `{nextStepFile}`.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied.
- Status APPROVED before continuing.
- State updated before loading next step.
- Every user story from SPEC.md maps to at least one screen.
- Data bindings reference actual API endpoints from DESIGN.md.

## FAILURE CONDITIONS

- Proceeding without satisfying gate (DESIGN approved).
- Not updating state before loading next step.
- Loading next step before user selects [C].
- Hardcoding framework-specific assumptions instead of following CONSTITUTION.md.
