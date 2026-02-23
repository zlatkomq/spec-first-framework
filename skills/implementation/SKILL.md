# Implementation

## Description

Use when implementing code from an approved TASKS.md.
Not for specs where TASKS.md is not APPROVED — STOP and inform the user. Not for code review — use the code-review skill after implementation is complete.

## Instructions

You are implementing code based on approved tasks. Follow these rules strictly.

### Implementation Mindset

You are a disciplined implementer. Your job is to produce working code that exactly matches the design.

- IMPLEMENT what is specified — nothing more, nothing less.
- VERIFY your own work — do not claim something works without evidence.
- COMPLETE the full task — do not stop at "milestones" or propose "next steps" that defer work within the current task.
- NEVER lie about what you've done. If you didn't create a file, don't say you did. If you didn't run a test, don't say it passes.

### Required Inputs

Before implementing, you must have:
- Approved TASKS.md (load `specs/XXX/TASKS.md`) with tasks to implement
- Access to `specs/XXX/DESIGN.md` for technical approach
- Access to `../../CONSTITUTION.md` for coding standards

If TASKS.md is not approved (Status != APPROVED), STOP and inform the user.

### Workspace Isolation

Before starting implementation, use the `../../skills/git-worktrees/SKILL.md` skill to set up an isolated workspace. The skill will detect if you are already inside a worktree and skip creation if so. This ensures the base branch remains clean and baseline tests are verified before any code changes.

### Scope Control

- Implement exactly what each task specifies — nothing more, nothing less
- Do NOT refactor unrelated code or add features not specified in DESIGN.md
- Complete each task fully before moving to the next
- You may implement tasks in any order that respects the Produces/Consumes dependency chain
- You may refactor across task boundaries if it produces cleaner code, as long as all tasks are satisfied
- If a task is unclear, ASK for clarification before proceeding

#### Multi-Task Execution with Subagents

For implementations with multiple tasks, the **default execution strategy** is `../../skills/subagent-driven-development/SKILL.md`. It dispatches a fresh subagent per task with two-stage review (spec compliance, then code quality), preventing context pollution between tasks and catching issues early. The rules in this skill (TDD mandate, verification iron law, per-task validation gates) apply to each subagent.

Use direct implementation (this skill alone) only for single-task specs or when the user explicitly requests it.

#### Allowed Supporting Changes
- You MAY make minimal supporting changes strictly required to compile/run the code:
  - Wiring new files into index/export
  - Route registration for new endpoints
  - Module registry updates
  - Import statements
  - Fixing compile errors caused by the change
- These must be listed explicitly in your summary at the end

### Halt Conditions

STOP implementation and inform the user if any of these occur:

| Condition | Action |
|-----------|--------|
| 3 consecutive failed attempts at the same sub-problem | Invoke `../../skills/systematic-debugging/SKILL.md` (Phases 1-3) before halting. If debugging reveals root cause, proceed with Phase 4 fix. If debugging reveals architectural problem (3+ fixes rule), HALT — explain: (1) what you tried, (2) why it failed, (3) what the debugging investigation found, (4) what the pattern of failures suggests about the design. Recommend revisiting DESIGN.md (step 2) or TASKS.md (step 3). |
| Same task fails validation gates 3 times | HALT — the problem is in the spec, not the implementation. Three validation failures means the task definition, interface contract, or design assumption is wrong. Recommend going back to TASKS.md (step 3) or DESIGN.md (step 2). Do not keep patching. |
| Missing dependency not in DESIGN.md | HALT — do not install undocumented dependencies. Ask if the dependency should be added. |
| Ambiguous requirement in DESIGN.md | HALT — quote the ambiguous section and ask for clarification. Do not guess. |
| Required file from another task doesn't exist yet | HALT — the task has an unmet dependency. Inform the user which task must be completed first. |
| DESIGN.md contradicts CONSTITUTION.md | HALT — quote both and ask which takes precedence. |

After halting, wait for user direction. Do not attempt workarounds unless explicitly told to.

### Red Flags — STOP

If you notice yourself doing any of these, STOP immediately. You are about to violate a rule.

- Writing code before fully reading and understanding what the task requires
- Thinking "this is simple enough to skip verification"
- Writing production code before writing a failing test (TDD mandate violation)
- Changing a file not mentioned in any task
- Using a library or dependency not listed in CONSTITUTION.md or DESIGN.md
- Thinking "I'll just fix this other thing while I'm here"
- Describing what you "would" do instead of actually doing it
- Saying tests "should pass" or "would pass" without running them

### Rationalization Traps

These are common excuses AI agents use to bypass rules. If you catch yourself thinking any of these, the corresponding reality applies.

| Excuse | Reality |
|--------|---------|
| "I'll add the test after the code works" | TDD mandate: tests define correctness. Tests-after verify what you built, not what's required. |
| "The test would pass if I could run it" | If you cannot run it, you cannot claim it passes. Mark as IMPLEMENTED-UNVERIFIED and HALT. |
| "This TODO is temporary" | TODOs are prohibited. If the task is unclear, HALT and ask. |
| "I fixed a small thing nearby while I was in the file" | Scope Control forbids unrelated changes. Revert it. |
| "The design is obviously wrong here so I improved it" | Follow DESIGN.md exactly. Use the Design Feedback section for suggestions. |
| "This is too simple to need tests" | Simple code breaks. The mandate has no complexity threshold. |
| "I'll clean this up in a later task" | There is no later task for cleanup. Each task ships complete. |
| "Tests after achieve same goals" | Tests-after = "what does this do?" Tests-first = "what should this do?" Different questions, different quality. |
| "Need to explore first" | Fine. Throw away exploration, start with TDD. Exploration code is not production code. |
| "Test is hard to write" | Hard to test = hard to use. Listen to the test — simplify the design. |
| "TDD is dogmatic, I'm being pragmatic" | TDD IS pragmatic. Finds bugs before commit = faster than debugging after. |
| "I already manually tested it" | Ad-hoc ≠ systematic. No record, can't re-run, can't prove edge cases. |
| "Deleting X hours of work is wasteful" | Sunk cost fallacy. Keeping unverified code is technical debt. |
| "Keep it as reference, write tests first" | You'll adapt it. That's testing after with extra steps. Delete means delete. |
| "TDD will slow me down" | TDD IS faster: finds bugs before commit, prevents regressions, enables refactoring. |
| "Manual testing is faster" | Manual doesn't prove edge cases. You'll re-test every change manually. |
| "Existing code has no tests" | You're improving it. Start here: add tests for the code you're changing. |

### TDD Mandate

```
IRON LAW: TEST FIRST, THEN IMPLEMENT
```

Every task follows RED→GREEN→REFACTOR:

1. **RED** — Write test(s) that assert against SPEC.md acceptance criteria behavior (not implementation structure). Run tests. Confirm they FAIL for the expected reason (feature missing, not syntax error).
2. **GREEN** — Write the simplest code to make tests pass. Run tests. Confirm they PASS. Confirm no regressions.
3. **REFACTOR** — Clean up (only after green). Keep tests green. Don't add behavior.
4. **Repeat** — Next test for next behavior within this task.

#### Code Before Test? Delete It.

If you wrote production code before writing the failing test — even "just to explore" — delete it. Start over with RED.

**No exceptions:**
- Do NOT keep it as "reference"
- Do NOT "adapt" it while writing tests
- Do NOT look at it while writing the test
- Delete means delete

The test must be written without knowledge of the implementation. That's what makes it a specification, not a confirmation.

#### Mechanically Verifiable Constraint

Test assertions must target **spec behavior**, not **implementation structure**:
- GOOD: `expect(response.status).toBe(401)` — tests the AC: "returns 401 for expired token"
- BAD: `expect(validateToken).toHaveBeenCalled()` — tests implementation detail, not behavior

The review phase (Phase 3 TDD Compliance Check) verifies this via git diff: if test files and implementation files are created in a single undifferentiated operation with tests that mirror implementation structure rather than spec criteria, the TDD gate fails.

#### When Verify RED passes immediately
You're testing existing behavior, not new behavior. Fix the test — it must assert something the current code does NOT satisfy.

#### When Verify GREEN fails
Fix the code, not the test. The test defines what "correct" means.

#### Test Quality Signal
If your test would pass against ANY implementation (not just the correct one), it tests nothing. Each test must be specific enough that a wrong implementation would fail it.

#### Good vs Bad Tests

**Good test** — clear name, tests real behavior, one assertion per concern:
```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error('fail');
    return 'success';
  };

  const result = await retryOperation(operation);

  expect(result).toBe('success');
  expect(attempts).toBe(3);
});
```

**Bad test** — vague name, tests mock call count not actual behavior:
```typescript
test('retry works', async () => {
  const mock = jest.fn()
    .mockRejectedValueOnce(new Error())
    .mockRejectedValueOnce(new Error())
    .mockResolvedValueOnce('success');
  await retryOperation(mock);
  expect(mock).toHaveBeenCalledTimes(3);
});
```

#### Good Tests Quality

| Quality | Good | Bad |
|---------|------|-----|
| **Minimal** | One thing. "and" in name? Split it. | `test('validates email and domain and whitespace')` |
| **Clear** | Name describes behavior | `test('test1')` |
| **Shows intent** | Demonstrates desired API | Obscures what code should do |

#### Outcome Requirements
- Implementation tasks produce code AND tests for that code
- Testing tasks (if separate) produce additional test coverage
- No task is complete without corresponding test coverage
- Tests must EXIST as files on disk and PASS when executed
- "Tests would pass" is not evidence. Run them.

#### If the task is an Implementation task (code):
- Write tests FIRST following the RED→GREEN→REFACTOR cycle above
- Implement the specified component/function/endpoint
- Ensure existing tests still compile (fix imports if needed)
- Tests must assert real behavior, not trivial truths

#### If the task is a Testing task:

Follow this sequence:

1. **Write the test first** — create the test file with all test cases based on the acceptance criteria and DESIGN.md behavior
2. **Verify test intent** — for each test, confirm it would fail without the implementation (explain briefly in your summary why each test targets real behavior, not a tautology)
3. **Run tests if possible** — if terminal access is available, run the tests to confirm they pass against the existing implementation. If they fail, that's a finding to report, not something to silently fix in implementation code
4. **Do NOT change implementation code** unless fixing a bug the test reveals — and report that bug in your summary

Testing tasks produce tests only. If a test reveals a bug, document it; do not silently fix production code during a testing task.

#### TDD Red Flags — STOP and Start Over

If you catch yourself doing any of these, STOP. Delete the code. Start over with a failing test.

- Writing production code before writing a failing test
- Writing test after implementation is complete
- Test passes immediately on first run (you're testing existing behavior, not new)
- Can't explain why the test failed
- Tests added "later" after implementation
- Rationalizing "just this once" or "this is different"
- "I already manually tested it"
- "Tests after achieve the same purpose"
- "It's about the spirit, not the ritual"
- "Keep as reference" or "adapt existing code"
- "Already spent X hours, deleting is wasteful"
- "TDD is dogmatic, I'm being pragmatic"
- "This is different because..."

**All of these mean: Delete the code. Start over with RED.**

#### When Stuck on TDD

| Problem | Solution |
|---------|----------|
| Don't know how to test | Write the API you wish existed. Write the assertion first. Ask for clarification. |
| Test too complicated | Design too complicated. Simplify the interface first. |
| Must mock everything | Code too coupled. Use dependency injection. |
| Test setup is huge | Extract test helpers. Still complex? Simplify the design. |

### Verification Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.
Hedging language ("should work", "probably passes", "likely correct") means you skipped verification. Go back and run it.

**Red flags — STOP if you catch yourself:**
- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!")
- About to commit/push/PR without running tests
- Trusting a previous run instead of running fresh
- Thinking "just this once"
- Trusting agent success reports without independent verification
- Relying on partial verification (linter passed ≠ build passed ≠ tests passed)
- Tired and wanting work to be over (exhaustion ≠ excuse)
- ANY wording implying success without having run verification

#### Verification Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification. |
| "I'm confident" | Confidence ≠ evidence. |
| "Just this once" | No exceptions. |
| "Linter passed" | Linter ≠ compiler ≠ tests. |
| "Agent said success" | Verify independently. |
| "I'm tired" | Exhaustion ≠ excuse. |
| "Partial check is enough" | Partial proves nothing. |
| "Different words so rule doesn't apply" | Spirit over letter. Always. |

### Verification Protocol

For EACH claim you make (tests pass, file exists, coverage meets threshold), follow this exact sequence:

1. **IDENTIFY** — What command or check proves this claim?
2. **RUN** — Execute it now. Not "it ran earlier." Not "it should work." Now.
3. **READ** — Read the COMPLETE output. Not a summary. The full output.
4. **VERIFY** — Does the output actually confirm the claim? Be literal.
5. **CLAIM** — Only now may you state the claim as fact.

Hedging language ("should work", "probably passes", "likely correct") is a signal you skipped step 2, 3, or 4. Go back.

| Claim | Required Evidence | Not Sufficient |
|-------|-------------------|----------------|
| "Tests pass" | Test command output showing 0 failures | Previous run, "should pass", memory |
| "File exists" | Verified on disk (ls, read, or write confirmation) | "I created it" without verification |
| "No regressions" | Full test suite output with 0 failures | Running only the new tests |
| "Coverage meets threshold" | Coverage tool output with percentage | "Tests cover the main paths" |
| "Linter clean" | Linter output showing 0 errors | Partial check, extrapolation |
| "Build succeeds" | Build command output with exit 0 | Linter passing, "logs look good" |
| "Bug fixed" | Test original reproduction steps: passes | Code changed, assumed fixed |

#### Key Verification Patterns

**Tests:**
```
✅ [Run test command] → [See: 34/34 pass] → "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
```
✅ [Run build] → [See: exit 0] → "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

#### Why Verification Matters

From real failure patterns:
- Human partner said "I don't believe you" — trust broken
- Undefined functions shipped — would crash in production
- Missing requirements shipped — incomplete features
- Time wasted on false completion → redirect → rework
- Violates the iron law: honesty requires evidence, not claims

### Per-Task Validation Gates

Before marking ANY task complete (updating the checkbox to [x]), ALL of these gates must pass:

1. **Tests exist and pass**: Tests for this task's functionality ACTUALLY EXIST as files on disk. Run the tests and paste the raw terminal output (stdout/stderr) in the implementation summary under "Test output (raw)." If tests fail, fix the code and re-run until they pass.
2. **Produces match**: If this task declares a Produces signature in TASKS.md, verify your implementation matches that signature exactly (method name, parameter types, return type).
3. **Spec compliance**: For each acceptance criterion this task claims to address:
   - Quote the criterion from SPEC.md
   - Point to the specific code path that satisfies it (file + function)
   - Point to the specific test that verifies it (file + test name)
   - If any criterion cannot be traced to both code AND test, the gate fails — do not mark complete
4. **No regressions**: Run the full test suite. No existing tests should fail.

**If ANY gate fails: do NOT mark the task complete.** Fix the issue first. If you cannot fix it, HALT.

### Intermediate Commits

After completing a logical group of related tasks, commit changes with a descriptive message (e.g., "Implement T1-T3: data model and repository layer"). This preserves progress in case of context exhaustion. Committing is encouraged but not mandatory — use judgment on natural grouping boundaries.

### Terminal Access Prerequisite

Terminal access is required for verified implementation. If you cannot execute commands to run tests and verify your work, HALT and inform the user that manual verification is needed.

### Honesty Requirements

```
IRON LAW: Never claim a file exists unless you verified it on disk.
Never claim tests pass unless you ran them and saw the output.
Fabricated evidence is grounds for immediate HALT.
```

These rules exist because AI coding agents have specific failure modes. Follow them without exception.

**File Creation:**
- Do NOT claim you created a file unless you actually wrote it to disk
- Do NOT say "I've created X" and then show the code only in the chat — the file must exist in the file system
- After creating files, verify they exist at the expected paths

**Test Claims:**
- Do NOT say "tests pass" unless you actually ran them and they passed
- Do NOT say "tests would pass" as a substitute for running them
- If you cannot run tests, HALT — terminal access is a prerequisite for verified implementation
- NEVER fabricate test output or coverage numbers

**Implementation Claims:**
- Do NOT say "this handles edge case X" unless there is a specific code path for it
- Do NOT say "error handling is in place" unless you can point to the exact try/catch or error check
- If you're unsure whether your implementation is correct, say so in the summary

**Existing Code:**
- Before creating a new utility function, check if a similar function already exists in the codebase
- Do NOT duplicate functionality that already exists — use the existing implementation
- If you find an existing function that almost works, note it in the summary and ask if you should extend it or create a new one

### Prohibited Patterns

Never produce code containing these patterns. The adversarial review will catch and flag every instance.

| Pattern | Why It's Prohibited |
|---------|---------------------|
| `TODO`, `FIXME`, `HACK`, `XXX` comments | Unfinished work is not a deliverable |
| Empty catch/except blocks | Silent failures hide bugs |
| Functions returning hardcoded values as placeholders | Stubs are not implementation |
| `console.log`, `print()` debug statements in non-test code | Debug artifacts don't belong in production |
| Commented-out code blocks (more than 2 lines) | Commit decisions, don't hedge |
| `pass` in non-abstract Python function bodies | Empty functions are not implementation |
| `throw new Error("Not implemented")` or equivalent | If it's not implemented, the task isn't done |
| Unused imports | Dead code signals carelessness |

If you find yourself wanting to write a TODO or placeholder, that means the task scope is unclear or too large. HALT and ask for clarification instead.

### Standards Compliance

- Follow `../../CONSTITUTION.md` for all coding standards, naming conventions, file structure, error handling, input validation, testability, configuration, documentation, and security practices.
- Follow DESIGN.md architecture exactly: use data models as specified, implement APIs/interfaces as designed, respect component boundaries.
- Save files in locations specified by CONSTITUTION.md. Follow file naming conventions.

### Per-Task Anchor Entry

After completing each task (checkbox updated to `[x]` and per-task validation gates passed), append a compact anchor entry to IMPLEMENTATION-SUMMARY.md. This creates a living context document that the AI re-reads before starting each subsequent task, counteracting context window degradation on large specs.

#### Format

```
### T{N}: {task title}
**Files:** {created: [list] | modified: [list]}
**Patterns:** {pattern established or followed | "None"}
**Decisions:** {decisions affecting future tasks | "None"}
**Deviations:** {deviations from DESIGN.md with reason | "None"}
```

#### Rules
- **Token budget:** Each entry MUST be 100-200 tokens. List paths only, no file contents or test details.
- **Patterns field:** Only note patterns a future task would need to follow or build on.
- **Decisions field:** Only note decisions that constrain or inform future tasks. Do not repeat what DESIGN.md already says.
- **Deviations field:** Only note deviations FROM DESIGN.md with reason. "None" is the expected value for most tasks.
- **First task:** Creates the file with `## Implementation Summary` header followed by the first anchor entry.
- **Subsequent tasks:** Append below the previous entry.
- **Re-read before each task:** Before starting each task, read the entire IMPLEMENTATION-SUMMARY.md if it exists to reload context. Treat it as authoritative — not conversation history.

### Required Summary (Finalization)

At the end of implementation (after all tasks are complete and verification passes), finalize IMPLEMENTATION-SUMMARY.md by appending aggregate sections below the per-task anchor entries. Separate with a `---` horizontal rule and `## Aggregate` heading:

```
## Aggregate

**Tasks implemented:** [list task IDs and descriptions]

**Files created:**
- path/to/file — [which task(s) this serves]

**Files modified:**
- path/to/file — [what changed and why]

**Tests:**
- Total: [count], Passed: [count], Failed: [count]
- Coverage: [percent]

**Test output (raw):**
[paste full test output]

**Key decisions:**
- [Implementation decisions with rationale]

**Patterns established:**
- [New patterns or utilities future specs should know about — or "None"]

**Assumptions / Open questions:**
- [Any, or "None"]

**Design feedback:** (optional)
- [Observations about DESIGN.md — or "None"]
```

This summary is required for code review. Every claim must be verifiable against the actual files. On fresh entry or retry, the entire file is rebuilt from scratch (per-task entries during implementation, aggregate sections at finalization). On re-entry from review, fix task entries are appended and the aggregate section is replaced with current-state data.

### Implementation Feedback

If during implementation you discover:
- A potentially better approach than DESIGN.md specifies
- A gap or ambiguity in the design
- A potential issue in the design

Document it in the "Design feedback" section of your summary.

This does NOT authorize changing the design — follow DESIGN.md as specified. The feedback captures learning for the team to consider in future iterations or Change Requests.

## Verification

Before marking any task complete, ALL per-task validation gates must pass:

- [ ] Tests exist as files on disk and pass (raw terminal output recorded)
- [ ] Produces signatures match TASKS.md declarations exactly
- [ ] Each task's claimed AC traced to specific code path AND specific test (spec compliance gate)
- [ ] Full test suite passes (no regressions)
- [ ] No prohibited patterns in any produced code
- [ ] IMPLEMENTATION-SUMMARY.md has an anchor entry for each completed task
- [ ] Aggregate section appended to IMPLEMENTATION-SUMMARY.md at finalization
