---
name: 'step-04-implement'
description: 'Implement all tasks from TASKS.md'
nextStepFile: './step-05-review.md'

# References
ruleRef: '@skills/implementation/SKILL.md'
subagentRef: '@skills/subagent-driven-development/SKILL.md'
worktreeRef: '@skills/git-worktrees/SKILL.md'
constitutionRef: '@CONSTITUTION.md'
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

Implement all incomplete tasks from TASKS.md. Run a verification gate. Write the implementation summary for cross-spec learning.

## RULES

- READ this entire step file before taking any action.
- When this step says "Apply {ref}", read the referenced file completely and follow ALL its sections in order.
- Default execution strategy is **subagent-driven** ({subagentRef}) for multi-task specs. Use direct implementation ({ruleRef}) only for single-task specs or when the user explicitly requests it.
- Load {constitutionRef}, {designFile}, and {tasksFile}.
- HALT and WAIT for user input at every menu.
- Do NOT load or look ahead to future step files.

## GATE

Check gate per {ruleRef}. If gate fails: `[B] Back to Tasks (step 3)` | `[X] Exit`. On [B]: load `./step-03-tasks.md`. On [X]: STOP.

<HARD-GATE>
Do NOT write production code without a failing test first (TDD mandate).
Do NOT claim a task is complete without running verification commands and reading the output.
Do NOT skip per-task validation gates — every gate must pass before checkbox update.
Do NOT mark a task complete if spec compliance check fails (AC not traceable to code AND test).
Do NOT implement multiple tasks directly — use subagent-driven development ({subagentRef}) for multi-task specs. Direct implementation is ONLY permitted for single-task specs or explicit user request.
Do NOT write IMPLEMENTATION-SUMMARY.md as a single batch at the end — write per-task anchor entries incrementally after each task's review gates pass.
</HARD-GATE>

## SEQUENCE

### 1. Load inputs

- Read {tasksFile}, {designFile}, {constitutionRef}.
- Read `{stateFile}` frontmatter: extract `stepsCompleted` and `implementationAttempts`.
- Count incomplete tasks (`[ ]` in {tasksFile}).

### 2. Determine entry state

**(A) Fresh entry** — no {reviewFile} with CHANGES REQUESTED/BLOCKED, `implementationAttempts` = 0:
- Incomplete tasks > 0: `[S] Start implementation` | `[X] Exit`
- All tasks `[x]`: skip to section 4.

**(B) Retry** — `implementationAttempts` > 0 and < 3:
- Display previous verification failures.
- `[R] Retry implementation (attempt {implementationAttempts+1} of 3)` | `[X] Exit`

**(C) Re-entry from review** — {reviewFile} exists with CHANGES REQUESTED or BLOCKED:
- Reset `implementationAttempts` to 0 in {stateFile}.
- Display review findings (Critical and Major issues).
- `[S] Start implementation addressing review findings` | `[X] Exit`

**(D) Exhausted** — `implementationAttempts` >= 3:
- `[M] Manual intervention` | `[B] Back to Tasks (step 3)` | `[B2] Back to Design (step 2)` | `[X] Exit`

**Menu routing:**
- **[S] or [R]:** Proceed to section 3.
- **[M]:** User provides manual verification results. If all pass → section 5. If failures → STOP.
- **[B]:** Trim `stepsCompleted` to keep up to `'step-02-design'`. Load `./step-03-tasks.md`.
- **[B2]:** Trim `stepsCompleted` to keep up to `'step-01-spec'`. Load `./step-02-design.md`.
- **[X]:** STOP.

### 2.5 Execution strategy confirmation

Count incomplete tasks in {tasksFile}.

- If count > 1 and the user has NOT explicitly requested direct implementation:
  - Display: `"This spec has {N} incomplete tasks. Using subagent-driven development ({subagentRef})."`
  - **If you are about to implement directly: STOP. You are violating the default execution strategy (see HARD-GATE).**
- If count = 1:
  - Display: `"Single task remaining. Using direct implementation ({ruleRef})."`
- If the user explicitly requested direct implementation:
  - Display: `"User requested direct implementation for {N} tasks."`

Proceed to section 3.

### 3. Implementation session

**Workspace isolation:**
Apply {worktreeRef} to set up an isolated workspace. The skill will detect if already inside a worktree and skip creation if so.

**Summary file lifecycle:**
- **Fresh entry or retry:** Delete existing `{summaryFile}` — rebuild from scratch.
- **Re-entry from review:** Keep existing `{summaryFile}`. Append only fix task entries.

**Execution strategy:**

Count incomplete tasks in {tasksFile}.

- **Multiple incomplete tasks (default):** Apply {subagentRef}. The subagent skill dispatches a fresh subagent per task with two-stage review (spec compliance, then code quality) after each. All rules from {ruleRef} (TDD mandate, verification iron law, per-task validation gates) apply to each subagent.
- **Single incomplete task, or user requests direct:** Apply {ruleRef} directly with full context ({tasksFile}, {constitutionRef}, {designFile}, {specFile} for AC reference).

Implement all incomplete tasks. When all done, proceed to section 4.

### 4. Verification gate

Run {verificationChecklist}.

- **PASS:** Update `{stateFile}`: append `'step-04-implement'` to `stepsCompleted` (early save — prevents context-loss from discarding progress). Proceed to section 5.
- **FAIL:** Increment `implementationAttempts` in {stateFile}. Display failures. Return to section 2 (retry path).

### 5. Verify implementation summary

Check `{summaryFile}`: per-task anchor entries and aggregate sections should already exist from section 3 (both {subagentRef} and {ruleRef} finalize the summary before returning). If the aggregate section (`## Aggregate`) is missing (e.g., direct implementation fallback), append it now per {ruleRef}: consolidated file list, test totals with raw output, key decisions, patterns, design feedback.

### 6. Present MENU

```
All {total} tasks implemented. Verification: PASS.

[C] Continue — proceed to Code Review (Step 5 of 5)
[B] Back to Tasks — re-edit TASKS.md (step 3)
[B2] Back to Design — re-edit DESIGN.md (step 2)
[X] Exit — pause workflow; resume later with /flow
```

- **[C]:** Load and follow `{nextStepFile}` (state already saved in section 4).
- **[B]:** Trim `stepsCompleted` to keep up to `'step-02-design'`. Load `./step-03-tasks.md`.
- **[B2]:** Trim `stepsCompleted` to keep up to `'step-01-spec'`. Load `./step-02-design.md`.
- **[X]:** Display: "Workflow paused. Run `/flow {spec_id}` to resume." STOP (state already saved in section 4).
- **Anything else:** Answer, then redisplay menu.
