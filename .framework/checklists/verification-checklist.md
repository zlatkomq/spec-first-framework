# Verification Checklist

Referenced by the verification gate in step-04-implement.md after all tasks are implemented.
All items must pass before implementation proceeds to code review.

**Prerequisite:** Terminal access is required. If commands cannot be executed, the gate fails — route to manual intervention.

---

## 1. Task Completion

- [ ] All tasks in TASKS.md marked `[x]`
- [ ] Total `[x]` count equals total task count (no skipped tasks)

## 2. Test Suite Green

Run the project test suite using the command from CONSTITUTION.md.

- [ ] Full test suite passes (record pass/fail/skip counts)
- [ ] No regressions (no previously passing tests now failing)

Record:
```
Test command: [per CONSTITUTION.md]
Total: [N] | Passed: [N] | Failed: [N] | Skipped: [N]
```

## 3. HALT Conditions

- [ ] No unresolved HALT conditions remaining (check task log for any flagged halts)

## 4. Scope Integrity

- [ ] No spec files modified beyond TASKS.md checkbox updates and IMPLEMENTATION-SUMMARY.md (`git diff --name-only -- specs/`)
- [ ] No scope creep (only task-specified changes implemented)
- [ ] No open questions unresolved

---

## Verdict

```
Verification: PASS / FAIL
Completed: [N]/[total] items
Failed: [list failures]
```

If FAIL: list failures, return to implementation.
If PASS: ready for code review.
