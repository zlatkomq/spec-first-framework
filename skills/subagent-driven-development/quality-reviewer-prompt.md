# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent. Fill in all [BRACKETED] sections before dispatching.

**Purpose:** Verify the implementation is well-built (clean, tested, maintainable, standards-compliant).

**HARD GATE: Only dispatch AFTER spec compliance review returns PASS. If spec review has not passed, do NOT dispatch this reviewer.**

```
Task tool (general-purpose):
  description: "Review code quality for Task [N]: [task name]"
  prompt: |
    You are reviewing the code quality of an implementation that has ALREADY
    passed spec compliance review. The code does what it should — your job
    is to verify it is WELL-BUILT.

    ## Context

    **Task:** [N] — [task name]
    **What was implemented:** [from implementer's report — summary of changes]
    **Base SHA:** [commit before this task started]
    **HEAD SHA:** [current commit after this task]
    **Files changed:** [list from implementer's report]

    ## Project Standards

    [Paste relevant sections from CONSTITUTION.md: coding standards, naming conventions,
    file structure, error handling patterns, error response format, test framework,
    test commands, coverage thresholds, security standards.
    The subagent cannot read CONSTITUTION.md — provide what it needs here.]

    ## Review Scope

    Review ONLY the changes between Base SHA and HEAD SHA.
    Do NOT review unrelated code. Focus on this task's delta.

    ## Review Methodology

    Follow Phase 3 (Quality Audit) methodology. Check all of the following:

    ### 1. Project Standards Compliance

    Check the changed code against the Project Standards provided above.

    **Mechanically Verifiable** (show specific violations or confirm clean scan):
    - **Naming conventions:** Check against Project Standards naming conventions above. Show violations.
    - **File/folder structure:** Compare actual file locations against Project Standards file structure above. Flag misplaced files.
    - **Import patterns:** Check for prohibited import patterns. Show violations.
    - **Prohibited patterns scan:** TODO, FIXME, HACK, XXX, empty catch blocks,
      hardcoded stubs, debug prints, commented-out code (>2 lines), empty function
      bodies, not-implemented throws, unused imports. Flag every instance.

    **Requires Judgment** (show relevant code evidence, explain compliance or violation):
    - **Architectural patterns:** Verify classes/functions follow Project Standards patterns above.
    - **Error handling patterns:** Verify error handling matches Project Standards strategy above.
    - **Error responses:** Verify error response format matches Project Standards above.
    - **Security checks:** Input validation, auth checks, data handling.
    - **Secrets/credentials:** Check for hardcoded strings, API keys, passwords.
    - **Sensitive data in logs:** Check for user data in logging statements.

    ### 2. DESIGN.md Alignment

    Verify implementation matches the technical design:
    - Architecture followed as specified
    - Data models match design (field names, types, relationships)
    - APIs/interfaces match design (endpoints, request/response shapes, status codes)
    - No unauthorized deviations from design
    - Dependencies added are justified and listed in DESIGN.md

    If deviations exist, they must be justified. Unjustified deviations = finding.

    ### 3. Test Quality

    **TDD Compliance:**
    - Tests assert against spec behavior (acceptance criteria), not implementation structure
    - Tests would fail without the implementation (they test new behavior)
    - No tests where assertions mirror implementation details
      (e.g., `expect(mockFn).toHaveBeenCalled()` instead of behavioral assertions)

    **Test Quality Checks:**
    - Tests assert real behavior, not trivial truths
    - Tests cover error paths, not just happy paths
    - Assertions are specific (not just "no exception" or "result is not null")
    - No duplicate test logic with only descriptions changed
    - No tests that mock the thing being tested

    **Red Flags:**
    | Red Flag | What It Means |
    |----------|---------------|
    | Test only asserts `result is not None` or `.toBeDefined()` | Tests the mock, not the code |
    | Test has no assertions at all | Placeholder test for coverage |
    | Test description says "should handle errors" but only tests happy path | Misleading test |
    | Multiple tests with identical structure, different descriptions | Copy-paste tests |
    | Test mocks the thing it's supposed to be testing | Circular testing |
    | All tests pass but none test edge cases from acceptance criteria | Incomplete coverage |

    ### 4. Code Quality

    - Clean, readable, maintainable
    - No magic numbers or strings (extract to named constants)
    - Single responsibility (functions/classes do one thing)
    - Appropriate abstraction level (not over-engineered, not under-engineered)
    - Error messages are helpful and specific
    - No dead code or unreachable paths

    ## Report Format

    **Strengths:** [What is done well — be specific, reference code]

    **Issues:**

    | # | Severity | File | Issue | Suggestion |
    |---|----------|------|-------|------------|
    | 1 | [Critical/Important/Minor] | [file:identifier] | [description] | [how to fix] |

    **Severity Guide:**
    - **Critical:** Security flaw, data loss risk, test failure, false implementation claims
    - **Important:** CONSTITUTION violation, design deviation, insufficient test quality, missing error handling
    - **Minor:** Style, naming, optional improvements, minor readability

    **Assessment:** APPROVED / ISSUES FOUND

    If **APPROVED:** No Critical or Important issues found. Code is well-built.

    If **ISSUES FOUND:** List what must be fixed before approval.
    The implementer will fix the issues and you will re-review.

    ## Gate Result Logging

    After you report, the controller will log to IMPLEMENTATION-SUMMARY.md:
    - If APPROVED: `Quality Review: PASS [YYYY-MM-DD HH:MM]`
    - If ISSUES FOUND: `Quality Review: FAIL (attempt N) [YYYY-MM-DD HH:MM] — [issue count by severity]`
```
