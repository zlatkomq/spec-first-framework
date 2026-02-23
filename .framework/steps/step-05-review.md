---
name: 'step-05-review'
description: 'Generate adversarial code review (REVIEW.md) for this feature'

# References
ruleRef: '@skills/code-review/SKILL.md'
templateRef: '@.framework/templates/REVIEW.template.md'
constitutionRef: '@CONSTITUTION.md'
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
- **ALWAYS run the full review from scratch.** Never resume a partial review — re-run all phases per {ruleRef}. Overwrite any previous REVIEW.md.

## GATE

All tasks in {tasksFile} must be marked `[x]`. If any are not: display "Not all tasks are implemented." Offer: `[B] Back to Implement (step 4)` | `[X] Exit`. On [B]: load `./step-04-implement.md`. On [X]: STOP.

<HARD-GATE>
Do NOT produce a review based solely on reading spec documents — you MUST inspect actual source code.
Do NOT skip test execution — you MUST run tests and record the output.
Do NOT approve with fewer than 3 issues without explicit one-sentence justification.
</HARD-GATE>

## SEQUENCE

### 1. Load inputs

- Read {specFile}, {designFile}, {tasksFile}, {constitutionRef}.

### 2. Counter management and execute review

**Counter management (auto-fix loop detection):**
- Read `fixLoopActive` from {stateFile}.
- If `fixLoopActive` = false (fresh entry): set `fixAttempts` = 0, `previousIssueCount` = 0.
- If `fixLoopActive` = true ([F] re-review loop): preserve counters, set `fixLoopActive` = false.
- If `fixAttempts` > 0: display "Note: This is auto-fix attempt {fixAttempts} of 3."

Apply {ruleRef} in full (all phases). Save to {outputFile} using {templateRef}.

### 3. Present results

Display verdict and summary of findings.

### 4. Present MENU

**IF APPROVED:**

```
REVIEW: APPROVED

[C] Complete — mark workflow as done
[B] Back to Implement — re-do a task
[X] Exit
```

**IF CHANGES REQUESTED and `fixAttempts` < 3:**

```
REVIEW: CHANGES REQUESTED — {issue_count} issues ({critical} Critical, {major} Major, {minor} Minor)

Findings:
{list of critical/major issues with affected tasks/files}

[F] Fix automatically — AI fixes issues, then re-reviews (attempt {fixAttempts+1} of 3)
[B] Back to Implement — return to step 4 with review findings
[B2] Back to Tasks — re-edit TASKS.md (step 3)
[B3] Back to Design — re-edit DESIGN.md (step 2)
[X] Exit — pause workflow
```

**IF CHANGES REQUESTED and `fixAttempts` >= 3:**

Do NOT show [F]. Compare `{issue_count}` against `previousIssueCount` and classify:

| Trend | Condition | Diagnosis | Recommended |
|---|---|---|---|
| Diverging | count increased | Implementation approach is likely wrong | [B2] Back to Tasks |
| Converging | count decreased | Progress made but issues remain | [B] Back to Implement |
| Churning | count unchanged | Fixes not making progress | [B2] Back to Tasks |

Display the diagnosis and recommendation, then show:

```
REVIEW: CHANGES REQUESTED — {issue_count} issues
Auto-fix limit reached (3 attempts). {Diagnosis per table above}.

Findings:
{list of critical/major issues}

[B] Back to Implement — return to step 4
[B2] Back to Tasks — re-edit TASKS.md (step 3)
[B3] Back to Design — re-edit DESIGN.md (step 2)
[X] Exit
```

Mark the recommended option per the classification table.

**IF BLOCKED:**

```
REVIEW: BLOCKED — {reason}
{If >10 issues: "More than 10 issues found. Fundamental rework needed."}

[B] Back to Implement — return to step 4
[B2] Back to Tasks — re-create TASKS.md (step 3) [RECOMMENDED for >10 issues]
[B3] Back to Design — re-think design (step 2)
[X] Exit
```

### 5. Menu handling

**APPROVED path:**

- **[C]:** Update {stateFile}: append `'step-05-review'` to `stepsCompleted`. Display: "Feature workflow complete for spec {spec_id}. All artifacts in `{spec_folder}/`. Human reviewer should make the final decision at Gate 4." STOP.
- **[B]:** Reset `fixAttempts` = 0, `previousIssueCount` = 0, `fixLoopActive` = false. Trim `stepsCompleted` to keep up to `'step-03-tasks'`. Load `./step-04-implement.md`.
- **[X]:** Update {stateFile}: append `'step-05-review'`. STOP.

**CHANGES REQUESTED path:**

- **[F]** (only when `fixAttempts` < 3):
  1. Increment `fixAttempts` in {stateFile}.
  2. Record current issue count as `previousIssueCount`.
  3. Fix Critical and Major issues one at a time:
     - Scope each fix to specific files/functions cited in the finding.
     - No architectural changes. If a finding requires structural rework: skip, note "requires architectural change — cannot auto-fix."
     - Validate after each fix (run tests). If fix breaks tests: revert, note "fix caused regression — cannot auto-fix."
     - Halt if 3 individual fixes fail validation. Note remaining as "Deferred."
  4. Add/update tests as needed.
  5. Add "Auto-Fix Tracking" section to REVIEW.md. Include "Fix attempt {fixAttempts} of 3."
  6. Set `fixLoopActive` = true. Re-run FULL review from scratch (go back to section 2).

- **[B]:** Reset `fixAttempts` = 0, `previousIssueCount` = 0, `fixLoopActive` = false. Trim `stepsCompleted` to keep up to `'step-03-tasks'`. Load `./step-04-implement.md`.
- **[B2]:** Reset counters. Trim `stepsCompleted` to keep up to `'step-02-design'`. Load `./step-03-tasks.md`.
- **[B3]:** Reset counters. Trim `stepsCompleted` to keep up to `'step-01-spec'`. Load `./step-02-design.md`.
- **[X]:** Do NOT append `'step-05-review'` to `stepsCompleted` (review not passed). Display: "Workflow paused with review findings. Run `/flow {spec_id}` to resume." STOP.

**BLOCKED path:**

- [F] is NOT offered for BLOCKED.
- [B], [B2], [B3], [X] — same as CHANGES REQUESTED path above.

- **Anything else:** Answer, then redisplay menu.
