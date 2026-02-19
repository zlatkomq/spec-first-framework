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

## 3. Lint & Type Check

Run the project's lint and type-check commands from CONSTITUTION.md.

- [ ] Lint passes (zero errors)
- [ ] Type check passes (zero errors, if applicable)

Record:
```
Lint command: [per CONSTITUTION.md]
Lint: PASS / FAIL ([N] errors)
Type check command: [per CONSTITUTION.md, or "N/A"]
Type check: PASS / FAIL ([N] errors) / N/A
```

If CONSTITUTION.md does not define lint or type-check commands, mark N/A.

## 4. Implementation Summary

- [ ] `IMPLEMENTATION-SUMMARY.md` exists in the spec folder
- [ ] Contains at least one per-task anchor entry (`### T{N}`)
- [ ] Contains Aggregate section with Files created/modified and Tests

## 5. HALT Conditions

- [ ] No unresolved HALT conditions remaining (check task log for any flagged halts)

## 6. Scope Integrity

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
