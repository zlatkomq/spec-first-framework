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
- Access to `../../.framework/CONSTITUTION.md` for coding standards

If TASKS.md is not approved (Status != APPROVED), STOP and inform the user.

### Scope Control

- Implement exactly what each task specifies — nothing more, nothing less
- Do NOT refactor unrelated code or add features not specified in DESIGN.md
- Complete each task fully before moving to the next
- You may implement tasks in any order that respects the Produces/Consumes dependency chain
- You may refactor across task boundaries if it produces cleaner code, as long as all tasks are satisfied
- If a task is unclear, ASK for clarification before proceeding

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
| 3 consecutive failed attempts at the same sub-problem | HALT — this is an architectural signal, not an effort problem. Each failed attempt reveals coupling or assumptions that patching cannot fix. Explain: (1) what you tried, (2) why it failed, (3) what the pattern of failures suggests about the design. Recommend revisiting DESIGN.md (step 2) or TASKS.md (step 3) rather than trying a fourth time. |
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
- Writing a test after the code is already working instead of alongside it
- Changing a file not mentioned in any task
- Using a library or dependency not listed in CONSTITUTION.md or DESIGN.md
- Thinking "I'll just fix this other thing while I'm here"
- Describing what you "would" do instead of actually doing it
- Saying tests "should pass" or "would pass" without running them

### Rationalization Traps

These are common excuses AI agents use to bypass rules. If you catch yourself thinking any of these, the corresponding reality applies.

| Excuse | Reality |
|--------|---------|
| "I'll add the test after the code works" | Test-accompaniment mandate: tests and code ship together. No exceptions. |
| "The test would pass if I could run it" | If you cannot run it, you cannot claim it passes. Mark as IMPLEMENTED-UNVERIFIED and HALT. |
| "This TODO is temporary" | TODOs are prohibited. If the task is unclear, HALT and ask. |
| "I fixed a small thing nearby while I was in the file" | Scope Control forbids unrelated changes. Revert it. |
| "The design is obviously wrong here so I improved it" | Follow DESIGN.md exactly. Use the Design Feedback section for suggestions. |
| "This is too simple to need tests" | Simple code breaks. The mandate has no complexity threshold. |
| "I'll clean this up in a later task" | There is no later task for cleanup. Each task ships complete. |

### Test-Accompaniment Mandate

```
IRON LAW: No task is complete without corresponding test coverage.
Tests must EXIST as files on disk and PASS when executed.
"Tests would pass" is not evidence. Run them.
```

Every implementation task MUST produce tests alongside code. The AI may write tests first, code first, or interleaved — the ORDER is not prescribed. But the OUTCOME is non-negotiable: when a task is marked complete, tests for that task's functionality must exist and pass.

- Implementation tasks produce code AND tests for that code
- Testing tasks (if separate) produce additional test coverage
- No task is complete without corresponding test coverage

#### If the task is an Implementation task (code):
- Implement the specified component/function/endpoint
- Write tests that verify the implementation works correctly
- Ensure existing tests still compile (fix imports if needed)
- Tests must assert real behavior, not trivial truths

#### If the task is a Testing task:

Follow this sequence:

1. **Write the test first** — create the test file with all test cases based on the acceptance criteria and DESIGN.md behavior
2. **Verify test intent** — for each test, confirm it would fail without the implementation (explain briefly in your summary why each test targets real behavior, not a tautology)
3. **Run tests if possible** — if terminal access is available, run the tests to confirm they pass against the existing implementation. If they fail, that's a finding to report, not something to silently fix in implementation code
4. **Do NOT change implementation code** unless fixing a bug the test reveals — and report that bug in your summary

Testing tasks produce tests only. If a test reveals a bug, document it; do not silently fix production code during a testing task.

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

### Per-Task Validation Gates

Before marking ANY task complete (updating the checkbox to [x]), ALL of these gates must pass:

1. **Tests exist and pass**: Tests for this task's functionality ACTUALLY EXIST as files on disk. Run the tests and paste the raw terminal output (stdout/stderr) in the implementation summary under "Test output (raw)." If tests fail, fix the code and re-run until they pass.
2. **Produces match**: If this task declares a Produces signature in TASKS.md, verify your implementation matches that signature exactly (method name, parameter types, return type).
3. **AC traceability**: State which acceptance criterion/criteria from SPEC.md this task addresses and how (one line). This is a traceability annotation, not a self-assessment — the adversarial review will verify your claim.
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

- Follow `../../.framework/CONSTITUTION.md` for all coding standards, naming conventions, file structure, error handling, input validation, testability, configuration, documentation, and security practices.
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
- [ ] Each task annotates which SPEC.md acceptance criterion it addresses
- [ ] Full test suite passes (no regressions)
- [ ] No prohibited patterns in any produced code
- [ ] IMPLEMENTATION-SUMMARY.md has an anchor entry for each completed task
- [ ] Aggregate section appended to IMPLEMENTATION-SUMMARY.md at finalization
