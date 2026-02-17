---
name: 'step-05-review'
description: 'Generate adversarial code review (REVIEW.md) for this feature'

# References
ruleRef: '@.cursor/rules/code-review.mdc'
templateRef: '@.framework/templates/REVIEW.template.md'
constitutionRef: '@.framework/CONSTITUTION.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
tasksFile: '{spec_folder}/TASKS.md'
outputFile: '{spec_folder}/REVIEW.md'
---

# Step 5: Code Review

**Progress: Step 5 of 5** — Final step

## STEP GOAL

Generate an adversarial REVIEW.md by applying the code-review rules. Inspect actual source code against SPEC, DESIGN, TASKS, and CONSTITUTION. Produce a verdict: APPROVED, CHANGES REQUESTED, or BLOCKED.

## RULES

- READ this entire step file before taking any action.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Use the template from {templateRef}.
- Load {constitutionRef}, {specFile}, {designFile}, and {tasksFile}.
- HALT and WAIT for user input at every menu.
- **ALWAYS run the full review from scratch.** If this step is re-entered (e.g. after fixing issues from a previous review), do NOT resume a partial review — re-run all phases per {ruleRef} completely. Delete or overwrite the previous REVIEW.md.

## GATE

- Implementation must be complete (all tasks in {tasksFile} done).
- Check `tasksCompleted` in `{stateFile}` — all task IDs from {tasksFile} must be present.
- If tasks are incomplete: display "Not all tasks are implemented. Complete implementation first." Offer: `[B] Back to Implement (step 4)` | `[X] Exit`. On [B]: load and follow `./step-04-implement.md`. On [X]: STOP.

## SEQUENCE

### 1. Load inputs

- Read {specFile} (acceptance criteria).
- Read {designFile} (architecture, data model, API).
- Read {tasksFile} (task list, expected files).
- Read {constitutionRef} (standards, coverage thresholds).

### 2. Execute review (from scratch)

**Counter management (auto-fix loop detection):**
- Read `fixLoopActive` from `{stateFile}`.
- If `fixLoopActive` is `false`: this is a **fresh entry**. Set `fixAttempts` to `0` and `previousIssueCount` to `0` in `{stateFile}`.
- If `fixLoopActive` is `true`: this is a **[F] re-review loop**. Preserve current `fixAttempts` and `previousIssueCount`. Set `fixLoopActive` back to `false` in `{stateFile}` (consumed).
- If `fixAttempts` > 0, display: "Note: This is auto-fix attempt {fixAttempts} of 3."

**IMPORTANT:** Even if a previous REVIEW.md exists, run the full review again from the beginning. Code may have changed since the last review.

Apply {ruleRef} in full (all phases and post-phase validation per rule).

### 3. Write REVIEW.md

- Save to `{outputFile}` using {templateRef}. Include verdict and findings per {ruleRef}.

### 4. Present results

Display the verdict and a summary of findings.

### 5. Present MENU

**IF verdict is APPROVED:**

```
REVIEW: APPROVED

[C] Complete — mark workflow as done
[B] Back to Implement — re-do a task
[X] Exit
```

**IF verdict is CHANGES REQUESTED:**

Read `fixAttempts` and `previousIssueCount` from `{stateFile}`.

**If `fixAttempts` < 3** — show [F] with attempt counter:

```
REVIEW: CHANGES REQUESTED — {issue_count} issues ({critical} Critical, {major} Major, {minor} Minor)

Findings:
{list of critical/major issues with affected tasks/files}

[F] Fix automatically — AI fixes issues in code, then re-reviews (attempt {fixAttempts+1} of 3)
[A] Create action items — add [AI-Review] tasks to TASKS.md, go back to Implementation (step 4)
[B] Back to Tasks — re-edit TASKS.md (step 3)
[B2] Back to Design — re-edit DESIGN.md (step 2)
[B3] Back to Spec — re-edit SPEC.md (step 1)
[X] Exit — pause workflow; resume later with /flow
```

**If `fixAttempts` >= 3** — do NOT show [F]. Compare `{issue_count}` against `previousIssueCount` and display a prescriptive recommendation:

If `{issue_count}` > `previousIssueCount` (diverging — fixes are making things worse):

```
REVIEW: CHANGES REQUESTED — {issue_count} issues ({critical} Critical, {major} Major, {minor} Minor)

⚠ Auto-fix limit reached (3 attempts). Issue count INCREASED ({previousIssueCount} → {issue_count}).
The implementation approach is likely wrong.
Recommended: [B] Back to Tasks to rework the implementation plan.

Findings:
{list of critical/major issues with affected tasks/files}

[A] Create action items — add [AI-Review] tasks to TASKS.md, go back to Implementation (step 4)
[B] Back to Tasks — re-edit TASKS.md (step 3) [RECOMMENDED]
[B2] Back to Design — re-edit DESIGN.md (step 2)
[B3] Back to Spec — re-edit SPEC.md (step 1)
[X] Exit — pause workflow; resume later with /flow
```

If `{issue_count}` <= `previousIssueCount` (converging — progress was made, but not enough):

```
REVIEW: CHANGES REQUESTED — {issue_count} issues ({critical} Critical, {major} Major, {minor} Minor)

⚠ Auto-fix limit reached (3 attempts). Issue count decreased ({previousIssueCount} → {issue_count}) but issues remain.
Recommended: [A] Create action items for targeted manual resolution.

Findings:
{list of critical/major issues with affected tasks/files}

[A] Create action items — add [AI-Review] tasks to TASKS.md, go back to Implementation (step 4) [RECOMMENDED]
[B] Back to Tasks — re-edit TASKS.md (step 3)
[B2] Back to Design — re-edit DESIGN.md (step 2)
[B3] Back to Spec — re-edit SPEC.md (step 1)
[X] Exit — pause workflow; resume later with /flow
```

**IF verdict is BLOCKED:**

```
REVIEW: BLOCKED — {reason}

{If >10 issues: "More than 10 issues found. The implementation needs fundamental rework."}
{If missing work: list what is missing}

[B] Back to Tasks — re-create TASKS.md (step 3) [RECOMMENDED for >10 issues]
[B2] Back to Design — re-think design (step 2)
[B3] Back to Spec — revisit requirements (step 1)
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

**APPROVED path:**

- **IF [C] Complete:**
  1. Update `{stateFile}`: append `'step-05-review'` to `stepsCompleted`.
  2. Display: "Feature workflow complete for spec {spec_id}. All artifacts: SPEC.md, DESIGN.md, TASKS.md, REVIEW.md are in `{spec_folder}/`."
  3. Display: "Human reviewer should make the final decision at Gate 4."
  4. STOP. Workflow is done.
- **IF [B] Back to Implement:**
  1. Reset `fixAttempts` to `0`, `previousIssueCount` to `0`, and `fixLoopActive` to `false` in `{stateFile}`.
  2. Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-03-tasks'`.
  3. Read fully and follow: `./step-04-implement.md`.
  - (Step-04 will detect REVIEW.md with findings and display them.)
- **IF [X] Exit:**
  - Update `{stateFile}`: append `'step-05-review'` to `stepsCompleted`.
  - STOP.

**CHANGES REQUESTED path:**

- **IF [F] Fix automatically:** (only available when `fixAttempts` < 3)
  1. Increment `fixAttempts` in `{stateFile}` (`fixAttempts` = `fixAttempts` + 1).
  2. Record the current review's total issue count as `previousIssueCount` in `{stateFile}` (to compare with the next review cycle's count).
  3. Fix Critical and Major issues in the code, one finding at a time, following these constraints:
     a. **Scope each fix** to the specific file(s) and function(s) cited in the finding. Do not refactor surrounding code or make unrelated improvements.
     b. **No architectural changes.** If a finding requires structural/architectural rework to fix, skip it and note: "Finding {N} requires architectural change — escalate to [A]." Continue with remaining findings.
     c. **Validate after each fix:** run tests to confirm they still pass. If a fix breaks tests, revert it and note: "Finding {N} fix caused regression — escalate to [A]."
     d. **Halt condition:** if 3 individual fixes fail validation (break tests or cannot be scoped), STOP fixing. Add all remaining unfixed findings to the Auto-Fix Tracking section as "Deferred — escalate to [A]" and present the menu with [A] recommended.
     e. **Allowed supporting changes** (same as implementation.mdc): wiring into index/exports, import statements, fixing compile errors caused by the fix. List these explicitly in Auto-Fix Tracking.
  4. Add/update tests as needed for the fixes.
  5. Update the Dev Agent Record in {tasksFile}: add fix entries to Implementation Log, update File List.
  6. Add an "Auto-Fix Tracking" section to REVIEW.md documenting what was fixed. Include: "Fix attempt {fixAttempts} of 3."
  7. Set `fixLoopActive` to `true` in `{stateFile}`. Re-run the FULL review from scratch (go back to section 2 of this step). A fresh review — not a partial re-check.
- **IF [A] Create action items:**
  1. Reset `fixAttempts` to `0`, `previousIssueCount` to `0`, and `fixLoopActive` to `false` in `{stateFile}`.
  2. For each Critical and Major issue, inject a task into the Tasks section of {tasksFile}. Assign T-numbers continuing from the last existing task (e.g., if T7 is the last task, AI-Review tasks become T8, T9, etc.):
     `- [ ] T{N}: [AI-Review][{Severity}] {Description} [{file:function}]`
  3. Add an "Action Items Created" section to REVIEW.md listing the injected tasks.
  4. Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-03-tasks'`.
  5. Do NOT clear `tasksCompleted` — keep task progress.
  6. Read fully and follow: `./step-04-implement.md`.
  - (Step-04 will detect the [AI-Review] tasks and prioritize them.)
- **IF [F] or [A] not chosen — IF [B] Back to Tasks:**
  1. Reset `fixAttempts` to `0`, `previousIssueCount` to `0`, and `fixLoopActive` to `false` in `{stateFile}`.
  2. Trim `stepsCompleted` to keep entries up to `'step-02-design'`.
  3. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  4. Read fully and follow: `./step-03-tasks.md`.
- **IF [B2] Back to Design:**
  1. Reset `fixAttempts` to `0`, `previousIssueCount` to `0`, and `fixLoopActive` to `false` in `{stateFile}`.
  2. Trim `stepsCompleted` to keep entries up to `'step-01-spec'`.
  3. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  4. Read fully and follow: `./step-02-design.md`.
- **IF [B3] Back to Spec:**
  1. Reset `fixAttempts` to `0`, `previousIssueCount` to `0`, and `fixLoopActive` to `false` in `{stateFile}`.
  2. Set `stepsCompleted` to `[]`.
  3. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  4. Read fully and follow: `./step-01-spec.md`.
- **IF [X] Exit:**
  - Display: "Workflow paused with review findings. Run `/flow {spec_id}` to resume and address issues."
  - Do NOT append `'step-05-review'` to `stepsCompleted` (review is not passed).
  - STOP.

**BLOCKED path:**

- [F] Fix and [A] Action Items are NOT offered for BLOCKED reviews — the implementation needs fundamental rework.
- **IF [B] Back to Tasks:** (same as above)
- **IF [B2] Back to Design:** (same as above)
- **IF [B3] Back to Spec:** (same as above)
- **IF [X] Exit:** (same as above)

- **IF anything else:** Answer, then redisplay menu.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied.
- REVIEW.md saved with verdict and findings.
- State updated on completion.
- Review run from scratch (never resumed partial review).
- Fix/back options presented when verdict is CHANGES REQUESTED or BLOCKED.

## FAILURE CONDITIONS

- Not running the full review from scratch when re-entering this step.
- Not updating state on completion.
- Not offering fix/back options on CHANGES REQUESTED or BLOCKED.
- Loading next step or completing workflow before user selects [C] or [X].
