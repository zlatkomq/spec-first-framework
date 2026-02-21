# Implementer Subagent Prompt Template

Use this template when dispatching an implementer subagent. Fill in all [BRACKETED] sections before dispatching.

**Purpose:** Implement a single task from TASKS.md with TDD, verify against acceptance criteria, and report back.

```
Task tool (general-purpose):
  description: "Implement Task [N]: [task name]"
  prompt: |
    You are implementing Task [N]: [task name]

    ## Task Description

    [FULL TEXT of task from TASKS.md — paste it here, do NOT make subagent read files]

    ## Interface Contracts

    **Produces:** [Produces declarations from TASKS.md, or "None"]
    **Consumes:** [Consumes declarations with producing task's signature resolved, or "None"]

    ## Acceptance Criteria Addressed

    This task addresses the following acceptance criteria from SPEC.md:
    [Paste the specific acceptance criteria verbatim:]
    - AC-[X]: Given [context], when [action], then [result]
    - AC-[Y]: Given [context], when [action], then [result]

    ## Context

    [Scene-setting: where this task fits in the overall implementation]
    [What tasks came before and what they established]
    [Relevant patterns or decisions from IMPLEMENTATION-SUMMARY.md]
    [Architectural context from DESIGN.md relevant to this task]

    ## Before You Begin

    If you have questions about:
    - The requirements or acceptance criteria
    - The approach or implementation strategy
    - Interface contracts (Produces/Consumes) and how to satisfy them
    - Dependencies or assumptions
    - Anything unclear in the task description

    **Ask them now.** Raise any concerns before starting work.

    ## Your Job

    Once you are clear on requirements, implement the task following these rules strictly.

    ### TDD Mandate (RED-GREEN-REFACTOR)

    ```
    IRON LAW: TEST FIRST, THEN IMPLEMENT
    ```

    Every piece of functionality follows this cycle:
    1. **RED** — Write test(s) that assert against acceptance criteria behavior
       (not implementation structure). Run tests. Confirm they FAIL for the
       expected reason (feature missing, not syntax error).
    2. **GREEN** — Write the simplest code to make tests pass. Run tests.
       Confirm they PASS. Confirm no regressions.
    3. **REFACTOR** — Clean up (only after green). Keep tests green.
       Do not add behavior.
    4. **Repeat** — Next test for next behavior within this task.

    **Code before test? Delete it.** If you wrote production code before writing
    the failing test — even "just to explore" — delete it. Start over with RED.
    No exceptions: do not keep it as "reference", do not "adapt" it, do not
    look at it while writing the test.

    Test assertions must target **spec behavior**, not **implementation structure**:
    - GOOD: `expect(response.status).toBe(401)` — tests the AC
    - BAD: `expect(validateToken).toHaveBeenCalled()` — tests implementation detail

    ### Verification Iron Law

    ```
    NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
    ```

    If you have not run the verification command in this message, you cannot claim
    it passes. "Should work", "probably passes", "likely correct" means you skipped
    verification. Go back and run it.

    For EACH claim you make (tests pass, file exists, no regressions):
    1. **IDENTIFY** — What command proves this claim?
    2. **RUN** — Execute it now. Not "it ran earlier." Now.
    3. **READ** — Read the COMPLETE output.
    4. **VERIFY** — Does the output actually confirm the claim?
    5. **CLAIM** — Only now may you state the claim as fact.

    ### Implementation Steps

    1. Implement exactly what the task specifies — nothing more, nothing less
    2. Follow TDD (RED-GREEN-REFACTOR) for each behavior
    3. Verify Produces signature matches exactly (if declared)
    4. Verify Consumes interfaces are used correctly (if declared)
    5. Run task-specific tests and confirm all pass
    6. Run full test suite and confirm no regressions
    7. Commit your work with a descriptive message
    8. Self-review (see below)
    9. Report back

    Work from: [worktree directory path]

    **While you work:** If you encounter something unexpected or unclear,
    **ask questions**. It is always OK to pause and clarify.
    Do not guess or make assumptions.

    ### Per-Task Validation Gates

    Before reporting back, ALL of these gates must pass:

    1. **Tests exist and pass**: Tests for this task ACTUALLY EXIST as files on disk.
       Run them and paste the raw terminal output.
    2. **Produces match**: If this task declares a Produces signature, verify your
       implementation matches that signature exactly (method name, parameter types,
       return type).
    3. **Spec compliance**: For each acceptance criterion this task addresses:
       - Quote the criterion
       - Point to the specific code path that satisfies it (file + function)
       - Point to the specific test that verifies it (file + test name)
       - If any criterion cannot be traced to both code AND test, the gate fails
    4. **No regressions**: Full test suite passes (paste output).

    If ANY gate fails: do NOT report as complete. Fix the issue first. If you
    cannot fix it after 3 attempts, report the failure with what you tried.

    ## Before Reporting Back: Self-Review

    Review your work with fresh eyes:

    **Completeness:**
    - Did I fully implement everything in the task spec?
    - Did I address all acceptance criteria listed above?
    - Are there edge cases I did not handle?
    - Does my Produces signature match exactly?

    **Quality:**
    - Is this my best work?
    - Are names clear and accurate (match what things do, not how they work)?
    - Is the code clean and maintainable?

    **Discipline:**
    - Did I avoid overbuilding (YAGNI)?
    - Did I only build what was requested?
    - Did I follow existing patterns in the codebase?
    - Did I follow TDD strictly (tests first)?

    **Testing:**
    - Do tests assert against acceptance criteria behavior, not implementation structure?
    - Did I follow RED-GREEN-REFACTOR?
    - Are tests comprehensive?
    - Do tests actually verify behavior (not just mock behavior)?

    If you find issues during self-review, fix them now before reporting.

    ## Report Format

    When done, report:

    **Summary:** What you implemented (brief)

    **Acceptance Criteria Tracing:**
    | Criterion | Code Path | Test |
    |-----------|-----------|------|
    | AC-X: Given... | file (function) | test_file (test_name) |

    **Interface Contracts:**
    - Produces: [confirmed match / N/A]
    - Consumes: [confirmed usage / N/A]

    **Test Results:** [paste raw terminal output]

    **Files Changed:**
    - Created: [list]
    - Modified: [list]

    **Self-Review Findings:** [issues found and how you fixed them, or "None"]

    **Issues or Concerns:** [any, or "None"]

    **Git Commit:** [SHA]
```
