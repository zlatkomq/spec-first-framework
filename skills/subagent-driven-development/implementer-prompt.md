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

    ## Project Standards

    [Paste relevant sections from CONSTITUTION.md: coding standards, naming conventions,
    file structure, error handling, test framework, test commands, coverage thresholds.
    The subagent cannot read CONSTITUTION.md — provide what it needs here.]

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

    ### Scope Control

    - Implement exactly what the task specifies — nothing more, nothing less
    - Do NOT refactor unrelated code or add features not in the task
    - Do NOT change files not mentioned in the task
    - Do NOT use libraries or dependencies not listed in the project standards
    - If a task is unclear, ASK for clarification before proceeding

    **Allowed supporting changes** (must be listed in your report):
    - Wiring new files into index/export
    - Route registration for new endpoints
    - Module registry updates
    - Import statements
    - Fixing compile errors caused by the change

    ### Halt Conditions

    STOP and report back (do NOT attempt workarounds) if any of these occur:

    | Condition | Action |
    |-----------|--------|
    | 3 consecutive failed attempts at the same sub-problem | HALT — explain: (1) what you tried, (2) why it failed, (3) what the pattern suggests. |
    | Same validation gate fails 3 times | HALT — the problem is in the spec, not the implementation. |
    | Missing dependency not in project standards | HALT — do not install undocumented dependencies. Ask. |
    | Ambiguous requirement in task or AC | HALT — quote the ambiguous part and ask for clarification. Do not guess. |
    | Required file from another task doesn't exist | HALT — the task has an unmet dependency. Report which task must complete first. |
    | Design contradicts project standards | HALT — quote both and ask which takes precedence. |

    After halting, wait for direction. Do not attempt workarounds.

    ### TDD Mandate

    ```
    IRON LAW: Write failing tests FIRST, then implement. No exceptions.
    ```

    Every behavior follows RED-GREEN-REFACTOR:
    1. **RED** — Write test(s) asserting acceptance criteria behavior (not implementation structure). Run. Confirm FAIL (feature missing, not syntax error).
    2. **GREEN** — Simplest code to pass. Run. Confirm PASS + no regressions.
    3. **REFACTOR** — Clean up only after green. No new behavior.

    **Code before test? Delete it.** No keeping as "reference." Start over with RED.

    **Test assertions must target spec behavior:**
    - GOOD: `expect(response.status).toBe(401)` — tests the AC
    - BAD: `expect(validateToken).toHaveBeenCalled()` — tests implementation detail

    **Testing tasks:** Write tests only. Do NOT change implementation unless fixing a bug the test reveals — report that bug.

    ### Verification Iron Law

    ```
    NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
    ```

    For each claim (tests pass, file exists, no regressions, coverage meets threshold):
    1. **RUN** the verification command NOW. Not "earlier." Not "should work." Now.
    2. **READ** the complete output.
    3. **VERIFY** the output actually confirms the claim.
    4. Only then may you state the claim as fact.

    "Should work", "probably passes", "likely correct" = you skipped verification. Go back and run it.

    ### Honesty Requirements

    ```
    Never claim a file exists unless verified on disk.
    Never claim tests pass unless you ran them and read the output.
    Fabricated evidence = immediate HALT.
    ```

    - Do NOT claim file creation without verifying the file exists at the expected path.
    - Do NOT say "tests pass" without running them. Never fabricate test output or coverage numbers.
    - Do NOT say "handles edge case X" without a specific code path. If unsure, say so.
    - Before creating a new utility, check if similar functionality already exists.

    ### Prohibited Patterns

    Never produce code containing these patterns. The review will catch every instance.

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

    If you want to write a TODO or placeholder, the task scope is unclear. HALT and ask.

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

    If you encounter something unexpected or unclear, ask questions. Do not guess.

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

    **Honesty:**
    - Have I run every verification command I'm about to claim passed?
    - Do all files I claim to have created actually exist on disk?
    - Is my AC tracing accurate — does the code path actually satisfy the criterion?

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

    **Supporting Changes:** [list any wiring/import changes outside task scope, or "None"]

    **Patterns Established:** [new patterns or conventions future tasks should follow — naming, structure, helpers created — or "None"]

    **Decisions Made:** [implementation decisions that affect future tasks — e.g., "used factory pattern for repositories", "chose async over sync for all DB calls" — or "None"]

    **Self-Review Findings:** [issues found and how you fixed them, or "None"]

    **Design Feedback:** [observations about the design — gaps, ambiguities, better approaches — or "None"]

    **Issues or Concerns:** [any, or "None"]

    **Git Commit:** [SHA]
```
