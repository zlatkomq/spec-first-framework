---
name: 'step-00-continue'
description: 'Resume an interrupted workflow from the last completed step'
stateFile: '{spec_folder}/.workflow-state.md'
tasksFile: '{spec_folder}/TASKS.md'
---

# Step 0: Workflow Continuation

## STEP GOAL

Resume the feature workflow from where it was left off. Determine the next step from the state file and offer the user a choice to continue, go back, or exit.

## RULES

- READ this entire step file before taking any action.
- Do NOT modify content from already completed steps.
- HALT and WAIT for user input at the menu.

## SEQUENCE

### 1. Load state

Read `{stateFile}` frontmatter. Extract:
- `stepsCompleted` — array of completed step names.
- `tasksCompleted` — array of completed task IDs (e.g. `['T1', 'T2']`).
- `specId`, `specSlug`, `specFolder`.

### 2. Handle workflow completion

If `stepsCompleted` contains `'step-05-review'`:

Display:

```
Workflow is already complete for spec {specId}.

All artifacts are in {specFolder}/:
- SPEC.md, DESIGN.md, TASKS.md, REVIEW.md

[B] Back to a step — re-do a specific step
[X] Exit
```

On [B]: ask "Which step? [1] Spec [2] Design [3] Tasks [4] Implement [5] Review" and load the corresponding step file. Trim `stepsCompleted` appropriately before loading. If going back to step 3 or earlier, also clear `tasksCompleted` (set to `[]`).

On [X]: STOP.

### 3. Determine next step

1. Get the last element from `stepsCompleted` (e.g. `'step-02-design'`).
2. Load that step file from `.framework/steps/` and read its frontmatter.
3. Extract `nextStepFile` from the frontmatter.
4. That is the next step to run.

**Step name to file mapping:**

| stepsCompleted entry | Step file | nextStepFile |
|----------------------|-----------|--------------|
| `step-01-spec` | `step-01-spec.md` | `step-02-design.md` |
| `step-02-design` | `step-02-design.md` | `step-03-tasks.md` |
| `step-03-tasks` | `step-03-tasks.md` | `step-04-implement.md` |
| `step-04-implement` | `step-04-implement.md` | `step-05-review.md` |

### 4. Check for partial implementation progress

If the next step is `step-04-implement.md` (i.e. last completed is `step-03-tasks`) AND `tasksCompleted` is non-empty:

- This means the user exited mid-implementation. Some tasks are already done.
- Read {tasksFile} to get the total task count.
- Include task progress in the status display (section 5).

If `stepsCompleted` contains `step-03-tasks` but NOT `step-04-implement`, and `tasksCompleted` is non-empty:

- Same situation: user was in step-04, completed some tasks, then exited before finishing all of them.
- Step-04 was never fully completed, so it's the next step.

### 5. Present status and menu

Display:

```
Welcome back! Resuming workflow for spec {specId}.

Last completed: {last element of stepsCompleted}
Next step: {nextStepFile name} ({step N of 5})
```

**If there is partial implementation progress (tasksCompleted is non-empty and next step is step-04):**

```
Implementation progress: {count of tasksCompleted} of {total tasks} tasks completed.
Completed: {list of tasksCompleted, e.g. T1, T2, T3}
```

```
[C] Continue — proceed to {next step description}
[B] Back to a step — [1] Spec [2] Design [3] Tasks [4] Implement
[X] Exit
```

### 6. Menu handling

- **IF [C] Continue:**
  - Read fully and follow the `nextStepFile` determined in section 3.
  - Do NOT append anything to `stepsCompleted` here — the next step will do that when the user completes it.

- **IF [B] Back to step N:**
  - User chooses which step (1–4).
  - Trim `stepsCompleted` to keep only entries before the chosen step:
    - Back to Spec (1): set `stepsCompleted` to `[]`.
    - Back to Design (2): keep only `['step-01-spec']`.
    - Back to Tasks (3): keep up to `['step-01-spec', 'step-02-design']`.
    - Back to Implement (4): keep up to `['step-01-spec', 'step-02-design', 'step-03-tasks']`.
  - If going back to step 3 or earlier: also clear `tasksCompleted` (set to `[]`).
  - Reset `fixAttempts` to `0`, `previousIssueCount` to `0`, and `fixLoopActive` to `false` in `{stateFile}`.
  - Update `{stateFile}` with trimmed `stepsCompleted` (and `tasksCompleted` if cleared).
  - Read fully and follow the corresponding step file (e.g. `step-02-design.md`).

- **IF [X] Exit:**
  - Display: "Workflow paused. Run `/flow {specId}` to resume."
  - STOP.

- **IF anything else:** Answer, then redisplay menu.

---

## SUCCESS CRITERIA

- State correctly read and analyzed.
- Next step correctly determined from last completed step's frontmatter.
- Partial implementation progress displayed when applicable.
- User clearly informed of progress.
- Correct step file loaded on [C] or [B].
- `tasksCompleted` cleared when going back to step 3 or earlier.

## FAILURE CONDITIONS

- Modifying content from completed steps.
- Loading wrong next step.
- Not trimming state when going back.
- Not clearing `tasksCompleted` when going back to Tasks or earlier.
- Not showing implementation progress when resuming mid-step-04.
