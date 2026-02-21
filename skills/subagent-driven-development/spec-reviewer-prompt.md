# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent. Fill in all [BRACKETED] sections before dispatching.

**Purpose:** Verify the implementer built what was requested (nothing more, nothing less), against SPEC.md acceptance criteria and TASKS.md interface contracts.

**Dispatch IMMEDIATELY after implementer reports. Do NOT dispatch quality reviewer until this returns PASS.**

```
Task tool (general-purpose):
  description: "Review spec compliance for Task [N]: [task name]"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested

    ### Task Description
    [FULL TEXT of task from TASKS.md]

    ### Acceptance Criteria (from SPEC.md)
    This task addresses the following acceptance criteria:
    - AC-[X]: Given [context], when [action], then [result]
    - AC-[Y]: Given [context], when [action], then [result]

    ### Interface Contracts (from TASKS.md)
    **Produces:** [Produces declarations, or "None"]
    **Consumes:** [Consumes declarations, or "None"]

    ## What Implementer Claims They Built

    [Paste from implementer's report — their summary, AC tracing table,
    interface contract confirmations, test results, files changed]

    ## CRITICAL: Do Not Trust the Report

    The implementer finished suspiciously quickly. Their report may be incomplete,
    inaccurate, or optimistic. You MUST verify everything independently.

    **DO NOT:**
    - Take their word for what they implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements
    - Trust their AC-to-code tracing without verifying the actual code
    - Trust their "tests pass" claim without checking what the tests actually assert

    **DO:**
    - Read the actual code they wrote
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features they did not mention
    - Verify Produces signatures match declarations exactly
    - Trace each acceptance criterion to actual code paths (not just the report)
    - Check that tests assert real behavior, not trivial truths

    ## Your Job

    Read the implementation code and verify ALL of the following:

    ### 1. Acceptance Criteria Verification

    This is the most important check. For EACH acceptance criterion listed above:

    1. Read the criterion exactly as written
    2. Find the specific code path that implements it
    3. Verify the behavior matches the criterion — not the spirit, the SPECIFICS
    4. Check that at least one test covers this criterion
    5. Verify the test asserts behavior, not implementation structure

    Do NOT accept "the code looks like it handles this." Verify: is there a code
    path that does exactly what the criterion says?

    **Example of insufficient verification:**
    - Criterion: "Given an expired token, when charge requested, then returns error code EXPIRED"
    - BAD: "Payment gateway exists" — does not verify expired token handling specifically
    - GOOD: "gateway.ts (charge) checks token.isExpired(), returns ChargeResult with errorCode='EXPIRED'"
      — traces the specific path

    Format your findings:
    | Criterion | Status | Evidence |
    |-----------|--------|----------|
    | AC-X: Given... | PASS/FAIL | file (function) — [specific explanation of HOW] |

    ### 2. Interface Contract Verification

    If the task declares **Produces**:
    - Verify the implementation exposes the exact signature declared
    - Check method name, parameter types, and return type match exactly
    - If signature deviates in ANY way, this is a FAIL regardless of functionality

    If the task declares **Consumes**:
    - Verify the implementation uses the producing task's interface correctly
    - Check that consumed interfaces are called with correct parameters

    Report: MATCH / MISMATCH (with expected vs actual if mismatch)

    ### 3. Missing Requirements Check

    - Did they implement everything that was requested?
    - Are there requirements they skipped or missed?
    - Did they claim something works but did not actually implement it?
    - Are there acceptance criteria they addressed superficially (code exists
      but does not actually satisfy the criterion)?

    ### 4. Extra/Unneeded Work Check

    - Did they build things that were not requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" not in the spec?
    - Did they add error handling for scenarios not in the acceptance criteria?
      (Some is fine if reasonable, but gold-plating is a flag)

    ### 5. Per-Task Validation Gates Check

    Verify the implementer actually passed their validation gates:
    - Do tests actually exist as files on disk? (check, don't trust report)
    - Did they provide raw terminal output of test runs? (not "tests pass")
    - Does the test output show all tests passing?
    - Did they run the full test suite (not just new tests)?

    **Verify by reading code, not by trusting the report.**

    ## Report Format

    Report one of:

    **PASS** — Spec compliant
    - All acceptance criteria verified with code path evidence
    - Interface contracts match (if applicable)
    - Nothing missing, nothing extra
    - Validation gates confirmed

    **FAIL** — Issues found:
    - [List specifically what is missing, extra, or wrong]
    - [For each failed AC: what the criterion says vs what the code does, with file references]
    - [For interface contract mismatches: expected signature vs actual signature]
    - [For missing validation gates: which gate was not satisfied]

    ## Gate Result Logging

    After you report, the controller will log to IMPLEMENTATION-SUMMARY.md:
    - If PASS: `Spec Review: PASS [YYYY-MM-DD HH:MM]`
    - If FAIL: `Spec Review: FAIL (attempt N) [YYYY-MM-DD HH:MM] — [summary of issues]`
```
