---
name: 'step-04-implement'
description: 'Implement all tasks from TASKS.md'
nextStepFile: './step-05-review.md'

# References
ruleRef: '@.cursor/rules/implementation.mdc'
constitutionRef: '@.framework/CONSTITUTION.md'
verificationChecklist: '@.framework/checklists/verification-checklist.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
tasksFile: '{spec_folder}/TASKS.md'
reviewFile: '{spec_folder}/REVIEW.md'
summaryFile: '{spec_folder}/IMPLEMENTATION-SUMMARY.md'
---

# Step 4: Implementation

**Progress: Step 4 of 5** — Next: Code Review

## STEP GOAL

Implement all incomplete tasks from TASKS.md. Run a verification gate. Write the implementation summary to a persistent file for cross-spec learning.

## RULES

- READ this entire step file before taking any action.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Load {constitutionRef}, {designFile}, and {tasksFile}.
- HALT and WAIT for user input at every menu.
- Do NOT load or look ahead to future step files.

## GATE

- Prerequisite: per {ruleRef}, required inputs must be satisfied (TASKS approved). If not met: display a short message that implementation cannot start until TASKS is approved; offer `[B] Back to Tasks (step 3)` | `[X] Exit`. On [B]: load and follow `./step-03-tasks.md`. On [X]: STOP.

## SEQUENCE

### 1. Load inputs

- Read {tasksFile} completely. Extract the ordered list of tasks (T1, T2, T3, …).
- Read {designFile} (for architecture and component details).
- Read {constitutionRef} (for coding standards).
- Read `{stateFile}` frontmatter. Extract `stepsCompleted` and `implementationAttempts`.
- Count incomplete tasks (`[ ]` checkboxes in {tasksFile}).

### 2. Determine entry state

Check context to determine which entry state applies:

**(A) Fresh entry** — no REVIEW.md with CHANGES REQUESTED/BLOCKED findings, and `implementationAttempts` = 0:

Display implementation brief: {N} tasks, key components from {designFile}, AC count from {specFile}.

- If incomplete tasks > 0: `[S] Start implementation` | `[X] Exit`
- If all tasks already `[x]`: skip to section 4 (verification gate).

**(B) Retry** — `implementationAttempts` > 0 and < 3:

Display the previous verification failures.

```
Implementation attempt {implementationAttempts} of 3 failed verification.

[R] Retry implementation (attempt {implementationAttempts+1} of 3)
[X] Exit
```

**(C) Re-entry from review** — `{reviewFile}` exists with verdict CHANGES REQUESTED or BLOCKED:

- Reset `implementationAttempts` to `0` in `{stateFile}`.
- Display the review findings (Critical and Major issues).

```
Review findings from previous cycle. Address these during implementation.

[S] Start implementation addressing review findings
[X] Exit
```

**(D) Exhausted** — `implementationAttempts` >= 3:

```
Implementation has failed verification 3 times.

[M] Manual intervention — user runs verification and confirms results
[B] Back to Tasks — re-edit TASKS.md (step 3)
[B2] Back to Design — re-edit DESIGN.md (step 2)
[X] Exit
```

**Menu handling for entry states:**

- **IF [S] or [R]:** Proceed to section 3 (implementation session).
- **IF [M]:** User provides manual verification results. If all pass → proceed to section 5. If failures → STOP.
- **IF [B]:** Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-02-design'`. Load and follow `./step-03-tasks.md`.
- **IF [B2]:** Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-01-spec'`. Load and follow `./step-02-design.md`.
- **IF [X]:** STOP.

### 3. Implementation session

Apply {ruleRef} with full context ({tasksFile}, {constitutionRef}, {designFile}, {specFile} for AC reference).

The AI:

1. Reads {tasksFile} to identify all incomplete tasks (`[ ]` checkboxes).
2. Implements each task in dependency order (following the Produces/Consumes chain).
3. Updates each task's checkbox to `[x]` in {tasksFile} as it completes.
4. After completing a logical group of tasks, commits changes (encouraged per {ruleRef}, not mandatory).
5. When all tasks are done, proceeds to section 4.

### 4. Verification gate

Run the verification checklist from {verificationChecklist}.

- **If PASS:** Proceed to section 5.
- **If FAIL:** Increment `implementationAttempts` in `{stateFile}`. Display the specific failures. Return to section 2 (retry path).

### 5. Write implementation summary

Write (or overwrite) `{summaryFile}` with the implementation summary (format defined in {ruleRef}). On re-implementation cycles, the previous summary is replaced — REVIEW.md and Auto-Fix Tracking provide the audit trail for prior attempts.

### 6. All tasks complete — Present MENU

Display:

```
All {total} tasks implemented. Verification: PASS.

[C] Continue — proceed to Code Review (Step 5 of 5)
[B] Back to Tasks — re-edit TASKS.md (step 3)
[B2] Back to Design — re-edit DESIGN.md (step 2)
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

- **IF [C] Continue:**
  1. Update `{stateFile}`: append `'step-04-implement'` to `stepsCompleted`.
  2. Read fully and follow: `{nextStepFile}` (step-05-review.md).
- **IF [B] Back to Tasks:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-02-design'`.
  2. Read fully and follow: `./step-03-tasks.md`.
- **IF [B2] Back to Design:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-01-spec'`.
  2. Read fully and follow: `./step-02-design.md`.
- **IF [X] Exit:**
  - Update `{stateFile}`: append `'step-04-implement'` to `stepsCompleted` (since all tasks are done and verification passed).
  - Display: "Workflow paused. Run `/flow {spec_id}` to resume."
  - STOP.
- **IF anything else:** Answer, then redisplay menu.

## CRITICAL COMPLETION NOTE

ONLY when [C] is selected and state is updated will you load and execute `{nextStepFile}`.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied for each task.
- All tasks from TASKS.md implemented with checkboxes updated to `[x]`.
- Verification gate passed.
- IMPLEMENTATION-SUMMARY.md written to spec folder.
- State updated before loading next step.

## FAILURE CONDITIONS

- Proceeding without satisfying gate (TASKS approved).
- Not running verification gate before allowing [C] Continue.
- Not writing IMPLEMENTATION-SUMMARY.md.
- Not updating state before loading next step.
