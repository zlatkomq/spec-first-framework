# Systematic Debugging

## Description

Use when encountering any bug, test failure, or unexpected behavior during implementation.
Not for creating BUG.md (use the bugfixing skill). This is the INVESTIGATION methodology that precedes any fix attempt. Referenced automatically by the implementation skill when 3 consecutive failures occur.

## Instructions

You are investigating a technical failure. Follow these rules strictly.

### Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

### When to Use

Use for ANY technical issue: test failures, unexpected behavior, build failures, integration issues.

Use this ESPECIALLY when:
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried 2+ fixes
- Previous fix didn't work or revealed a new symptom

### Phase 1: Root Cause Investigation

BEFORE attempting ANY fix:

1. **Read error messages completely** — stack traces, line numbers, error codes. Don't skip past them. They often contain the exact solution.
2. **Reproduce consistently** — Can you trigger it reliably? What are the exact steps? If not reproducible → gather more data, don't guess.
3. **Check recent changes** — git diff, recent commits, new deps, config changes. What changed that could cause this?
4. **Multi-component systems** — Add diagnostic instrumentation at EACH component boundary. Run once to gather evidence showing WHERE it breaks. THEN analyze. Don't guess which layer fails.

   **Example (multi-layer system):**
   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available in workflow: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   echo "=== Env vars in build script: ==="
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing script
   echo "=== Keychain state: ==="
   security list-keychains
   security find-identity -v

   # Layer 4: Actual signing
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```
   **This reveals:** Which layer fails (secrets → workflow ✓, workflow → build ✗). Instrument first, fix second.

5. **Trace data flow** — Where does the bad value originate? What called this with the bad value? Keep tracing up until you find the source. Fix at source, not at symptom.

### Phase 2: Pattern Analysis

1. **Find working examples** — Locate similar working code in same codebase. What works that's similar to what's broken?
2. **Compare working vs broken** — List every difference, however small. Don't assume "that can't matter."
3. **Read reference implementations completely** — Not skim. Every line. Understand the pattern fully before applying.

### Phase 3: Hypothesis + Minimal Test

1. **State clearly:** "I think X is the root cause because Y" — write it down, be specific, not vague.
2. **Test minimally:** Make the SMALLEST possible change to test hypothesis.
3. **One variable at a time:** Don't fix multiple things at once.
4. **If wrong:** Form NEW hypothesis based on what you learned. Don't add more fixes on top.
5. **When you don't know:** Say "I don't understand X." Don't pretend to know. Ask for help. Research more. Admitting ignorance is faster than pretending competence.

### Phase 4: Implementation

1. **Create failing test case first** — TDD iron law from the implementation skill applies here too. The test must reproduce the bug.
2. **Implement single fix** — Address the root cause. ONE change, not bundled.
3. **Verify fix** — Test passes, no regressions.
4. **If fix doesn't work:** Return to Phase 1 with new information. Do NOT stack another fix.

### The 3+ Fixes Rule

If you've tried 3 or more fixes and the problem persists: **STOP. This is an architectural problem, not a bug.**

Signals that it's architectural:
- Each fix reveals a new symptom elsewhere
- Fixes require "massive refactoring" to implement
- Each fix creates new coupling or dependencies

HALT and discuss with human partner. Recommend revisiting DESIGN.md or TASKS.md rather than attempting fix #4.

### Anti-Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging IS faster than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Question the design, don't fix again. |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves the fix AND prevents regression. |

### Red Flags — STOP and Follow Process

If you catch yourself thinking any of these, STOP. Return to Phase 1.

- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Pattern says X but I'll adapt it differently"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- "One more fix attempt" when already tried 2+
- Each fix reveals new problem in different place
- Expressing confidence about root cause without evidence
- Skipping Phase 2 because "this is nothing like anything else in the codebase"
- "This is too simple to need the full process"
- "I'm in a hurry, just need a quick fix"
- "I'll write the test after confirming the fix works"
- "I see the problem, let me just fix it" (seeing symptoms ≠ root cause)
- "We should just refactor everything" (premature architectural conclusion without 3+ fix evidence)

**ALL of these mean: STOP. Return to Phase 1.**

### Human Partner Signals You're Doing It Wrong

Watch for these redirections from your human partner — they mean your approach is failing:

| Signal | What It Means |
|--------|---------------|
| "Is that not happening?" | You assumed without verifying |
| "Will it show us...?" | You should have added evidence gathering |
| "Stop guessing" | You're proposing fixes without understanding |
| "Ultrathink this" / "Think harder" | Question fundamentals, not just symptoms |
| "We're stuck?" (frustrated) | Your approach isn't working — change strategy |

**When you see these:** STOP. Return to Phase 1.

### Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

## Verification

- [ ] Root cause identified with evidence (not guessed)
- [ ] Hypothesis stated explicitly before fix attempted
- [ ] Failing test case created before fix implemented
- [ ] Fix addresses root cause, not symptom
- [ ] No regressions after fix
