# Verification Checklist

Referenced by the verification gate in step-04-implement.md after all tasks are implemented.
All items must pass before implementation proceeds to code review.

**Prerequisite:** Terminal access is required. If commands cannot be executed, the gate fails — route to manual intervention.

---

## 1. Task Completion

- [ ] All tasks in TASKS.md marked `[x]`
- [ ] Total `[x]` count equals total task count (no skipped tasks)
- [ ] All acceptance criteria from SPEC.md satisfied

## 2. Test Verification

Run the project test suite using the command from CONSTITUTION.md.

- [ ] Tests exist for every implementation task
- [ ] Full test suite passes (record pass/fail/skip counts)
- [ ] No regressions (no previously passing tests now failing)
- [ ] Coverage meets CONSTITUTION.md threshold
- [ ] Tests assert real behavior, not trivial truths

Record:
```
Test command: [per CONSTITUTION.md]
Total: [N] | Passed: [N] | Failed: [N] | Skipped: [N]
Coverage: [N]%
```

## 3. Code Quality

Scan using tools specified in CONSTITUTION.md. Adapt patterns to the project language.

- [ ] Linter passes (per CONSTITUTION.md linter config)
- [ ] No prohibited patterns (TODO, FIXME, empty catch blocks, debug prints, commented-out code, unused imports)
- [ ] CONSTITUTION.md coding standards followed
- [ ] DESIGN.md architecture and APIs matched

## 4. Scope and Completeness

- [ ] No spec files modified (`git diff --name-only -- specs/` should show only TASKS.md checkbox updates and IMPLEMENTATION-SUMMARY.md)
- [ ] No scope creep (only task-specified changes)
- [ ] No HALT conditions remaining
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
