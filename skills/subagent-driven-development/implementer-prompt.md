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

    Follow TDD (tests first, then implementation) for every behavior.
    **Testing tasks:** Write tests only. Do NOT change implementation unless fixing a bug the test reveals — report that bug.

    ### Verification Requirement

    Verify every claim by running commands and reading output before reporting. No claim without fresh evidence.

    ### Prohibited Patterns

    No TODOs, stubs, or placeholder code. If scope is unclear, halt and ask.

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

    **Testing:**
    - Do tests assert against acceptance criteria behavior, not implementation structure?

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
