# Definition of Done Checklist

Referenced by the verification gate in step-04-implement.md before allowing [C] Continue to code review.
All items must pass before implementation is considered complete.

---

## Implementation Completion

- [ ] **All tasks complete:** Every task and subtask in TASKS.md marked with [x]
- [ ] **Acceptance criteria satisfied:** Implementation satisfies EVERY acceptance criterion in SPEC.md
- [ ] **No ambiguous implementation:** Clear, unambiguous implementation that matches task descriptions exactly
- [ ] **Scope respected:** Only task-specified code changes made — no scope creep, no bonus features

## Testing

- [ ] **Tests exist:** Every implementation task has corresponding test coverage
- [ ] **Tests pass:** All new tests pass (or "not executed — manual run required" if no terminal access)
- [ ] **No regressions:** Full test suite passes — no existing tests broken
- [ ] **Test quality:** Tests assert real behavior, not trivial truths (no `expect(result).toBeDefined()` without meaningful checks)
## Documentation

- [ ] **IMPLEMENTATION-SUMMARY.md written:** Summary file exists in spec folder with files changed, key decisions, patterns established, and test summary

## Quality

- [ ] **No prohibited patterns:** No TODOs, FIXMEs, empty catch blocks, placeholder stubs, debug prints, or commented-out code
- [ ] **CONSTITUTION.md compliance:** Code follows project coding standards, naming, structure, and patterns
- [ ] **DESIGN.md alignment:** Architecture, data models, and APIs match the design exactly
- [ ] **Error handling:** Errors handled appropriately — no silent failures, meaningful error messages

## Final Status

- [ ] **No HALT conditions:** No blocking issues or incomplete work remaining
- [ ] **No open questions:** All ambiguities resolved during implementation (or documented in Design feedback)
- [ ] **Ready for adversarial review:** Implementation is complete and defensible — the code review will challenge every claim

---

## Validation Output

```
Definition of Done: PASS / FAIL

Completed: [count]/[total] items passed
Failed items: [list specific failures if any]
```

**If FAIL:** List specific failures and required actions. Do NOT allow [C] Continue.
**If PASS:** Implementation is ready for code review (Step 5).
