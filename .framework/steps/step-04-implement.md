---
name: 'step-04-implement'
description: 'Implement all tasks from TASKS.md'
nextStepFile: './step-05-review.md'

# References
ruleRef: '@.cursor/rules/implementation.mdc'
constitutionRef: '@.framework/CONSTITUTION.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
tasksFile: '{spec_folder}/TASKS.md'
reviewFile: '{spec_folder}/REVIEW.md'
---

# Step 4: Implementation

**Progress: Step 4 of 5** — Next: Code Review

## STEP GOAL

Implement tasks from TASKS.md one at a time. After each task, present a menu so the user can continue, pause, or exit. Track completed tasks in the state file so the workflow can resume mid-implementation.

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
- Read `{stateFile}` frontmatter. Extract `tasksCompleted` (array of completed task IDs, e.g. `['T1', 'T2']`).

### 2. Check for review findings (re-entry from step-05)

- If `{reviewFile}` exists:
  - Read it. Check the verdict.
  - If verdict is **CHANGES REQUESTED** or **BLOCKED**:
    - Display the review findings (Critical and Major issues) to the user.
    - Display: "These issues were found during code review. Address the relevant tasks below."
    - The user should focus on the tasks related to the findings.
- If `{reviewFile}` does not exist or verdict is not CHANGES REQUESTED/BLOCKED: skip this section.

### 3. Present task list with progress

Display the task list showing completed vs remaining tasks:

```
Implementation progress:

- [x] T1: {description}    ← done
- [x] T2: {description}    ← done
- [ ] T3: {description}    ← NEXT
- [ ] T4: {description}
- ...

{N} of {total} tasks completed.

[N] Start next task (T3)
[T] Implement a specific task (e.g. "T3")
[R] Re-implement a completed task (e.g. "T1" — fix or redo)
[X] Exit — pause and resume later
```

If ALL tasks are already complete, skip directly to section 5 (completion menu).

### 4. Implementation loop (per-task)

**IF [N] Start next task or [T] Specific task or [R] Re-implement:**

1. Identify the target task (next incomplete task for [N], user-specified for [T]/[R]).
2. Announce: "Implementing T{n}: {description}"
3. Apply {ruleRef} for this task; implement the code; provide the implementation summary (as specified in {ruleRef}).
6. Mark the task done:
   - Update `tasksCompleted` in `{stateFile}` frontmatter: add `'T{n}'` to the array (if not already present).
   - Update the task checkbox in {tasksFile} if practical.

After completing the task, **return to section 3** (present task list with updated progress). This gives the user a menu after EVERY task — they can continue to the next task, pick a different task, or exit.

**IF [X] Exit:**

- `tasksCompleted` is already up to date (saved after each task).
- Display: "Workflow paused. {N} of {total} tasks completed. Run `/flow {spec_id}` to resume."
- STOP.

### 5. All tasks complete — Present MENU

When all tasks in TASKS.md are checked off (all task IDs are in `tasksCompleted`):

Display:

```
All {total} tasks implemented.

[C] Continue — proceed to Code Review (Step 5 of 5)
[R] Re-implement a specific task (e.g. "T3" — fix or redo)
[B] Back to Tasks — re-edit TASKS.md (step 3)
[B2] Back to Design — re-edit DESIGN.md (step 2)
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

- **IF [C] Continue:**
  1. Update `{stateFile}`: append `'step-04-implement'` to `stepsCompleted`.
  2. Read fully and follow: `{nextStepFile}` (step-05-review.md).
- **IF [R] Re-implement task:**
  - User specifies task. Re-apply {ruleRef} for that task.
  - After done, redisplay this menu (section 5).
- **IF [B] Back to Tasks:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-02-design'`.
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-03-tasks.md`.
- **IF [B2] Back to Design:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-01-spec'`.
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-02-design.md`.
- **IF [X] Exit:**
  - Update `{stateFile}`: append `'step-04-implement'` to `stepsCompleted` (since all tasks are done).
  - Display: "Workflow paused. Run `/flow {spec_id}` to resume."
  - STOP.
- **IF anything else:** Answer, then redisplay menu.

## CRITICAL COMPLETION NOTE

ONLY when [C] is selected and state is updated will you load and execute `{nextStepFile}`.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied for each task.
- All tasks from TASKS.md implemented.
- `tasksCompleted` updated in state file after EACH task (not just at the end).
- State updated before loading next step.
- Menu presented after each task completion.

## FAILURE CONDITIONS

- Proceeding without satisfying gate (TASKS approved).
- Not updating `tasksCompleted` after each task.
- Not presenting menu after each task completion.
- Not updating state before loading next step.
