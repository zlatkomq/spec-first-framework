# Finishing a Development Branch

## Description

Use when implementation is complete, all tests pass, and you need to decide how to integrate the work — merge, PR, keep, or discard.
Not for ongoing implementation work — use the implementation skill. Not for worktree creation — use the git-worktrees skill.

## Instructions

You are completing a development branch by guiding the user through structured completion options. Follow these rules strictly.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

### Step 1: Verify Tests

**HARD GATE — do NOT proceed without passing this check.**

Run the project's test suite before presenting any options:

```bash
# Run project's test suite (auto-detect)
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Do NOT proceed to Step 2.

**If tests pass:** Continue to Step 2.

### Step 2: Determine Base Branch

Check `.workflow-state.md` frontmatter first (the git-worktrees skill records `baseBranch` there):

1. Read `baseBranch` from `.workflow-state.md` frontmatter. If set, use it.
2. If not in frontmatter, check the `## Worktree` markdown section for `**Base branch:**`.
3. If not found, detect from git:
   ```bash
   git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
   ```
4. Or ask: "This branch split from main — is that correct?"

### Step 3: Present Options

Present exactly these 4 options:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Don't add explanation** — keep options concise.

### Step 4: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>
```

**HARD GATE — verify tests pass on the merged result.**

```bash
# Run test suite on merged result
<test command>
```

**If tests fail on merged result:**
```
Tests failing on merged result (<N> failures).

[Show failures]

The merge introduced test failures. Options:
1. Revert the merge and investigate (git reset --hard HEAD~1)
2. Fix the failures now
```

Do NOT proceed to branch deletion with failing tests.

**If tests pass:**
```bash
git branch -d <feature-branch>
```

Then: Log to workflow state (Step 5), Cleanup worktree (Step 6).

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>
```

Before creating the PR, read the spec files to populate traceability sections:

```bash
# Read acceptance criteria and task list
cat specs/<spec-id>/SPEC.md
cat specs/<spec-id>/TASKS.md
```

Create the PR with spec-driven traceability:

```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Spec Traceability

**Spec:** specs/<spec-id>/SPEC.md
**Design:** specs/<spec-id>/DESIGN.md
**Tasks:** specs/<spec-id>/TASKS.md

### Acceptance Criteria Coverage
- [x] AC1: <criterion from SPEC.md> — implemented
- [x] AC2: <criterion from SPEC.md> — implemented

### Tasks Completed
- [x] T1: <task from TASKS.md>
- [x] T2: <task from TASKS.md>

## Test Plan
- [ ] All tests passing (<N> tests, 0 failures)
- [ ] No regressions (full suite green)
- [ ] <additional verification steps>
EOF
)"
```

Read the actual SPEC.md acceptance criteria and TASKS.md task list to populate these sections. Do NOT leave them as placeholders.

Then: Log to workflow state (Step 5), Cleanup worktree (Step 6).

#### Option 3: Keep As-Is

Report: "Keeping branch `<name>`. Worktree preserved at `<path>`."

**Do not cleanup worktree.**

Then: Log to workflow state (Step 5) only.

#### Option 4: Discard

**Confirm first:**

```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for the user to type exactly "discard". Do NOT accept variations.

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: Log to workflow state (Step 5), Cleanup worktree (Step 6).

### Step 5: Log to Workflow State

If `.workflow-state.md` exists in the spec directory:

**Update frontmatter fields:**
- For Options 1 (merge) and 4 (discard): clear `featureBranch`, `baseBranch`, and `worktreePath` to `''` (branch no longer active).
- For Options 2 (PR) and 3 (keep): leave frontmatter fields unchanged (branch still exists).

**Append a Branch Completion section** (historical record, always append regardless of option):

```markdown
## Branch Completion

- **Option chosen:** <1: Merge locally | 2: Push and create PR | 3: Keep as-is | 4: Discard>
- **Branch:** <branch-name>
- **Base branch:** <base-branch>
- **Outcome:** <merged to <base-branch> | PR #<number> created | kept as-is | discarded>
- **Completed:** <timestamp>
```

If `.workflow-state.md` does not exist, skip this step.

### Step 6: Cleanup Worktree

**For Options 1 and 4 only:**

Check if in worktree:
```bash
git worktree list | grep <feature-branch>
```

If yes:
```bash
git worktree remove <worktree-path>
```

**For Options 2 and 3:** Keep worktree. Option 2 may need it for PR review changes. Option 3 explicitly preserves it.

### Quick Reference

| Option | Merge | Push | Cleanup Worktree | Cleanup Branch | Log to State |
|--------|-------|------|------------------|----------------|--------------|
| 1. Merge locally | ✓ | - | ✓ | ✓ | ✓ |
| 2. Create PR | - | ✓ | - | - | ✓ |
| 3. Keep as-is | - | - | - | - | ✓ |
| 4. Discard | - | - | ✓ | ✓ (force) | ✓ |

### Common Mistakes

#### Skipping test verification

- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before offering options — this is a HARD GATE

#### Open-ended questions

- **Problem:** "What should I do next?" leads to ambiguous conversation
- **Fix:** Present exactly 4 structured options, no more, no less

#### Automatic worktree cleanup on Option 2

- **Problem:** Remove worktree when user may need it for PR review changes
- **Fix:** Only cleanup worktree for Options 1 and 4. Keep for Options 2 and 3.

#### No confirmation for discard

- **Problem:** Accidentally delete work permanently
- **Fix:** Require typed "discard" confirmation before executing Option 4

#### Generic PR body

- **Problem:** PR has no traceability to spec, design, or tasks
- **Fix:** PR body must reference SPEC.md acceptance criteria and TASKS.md task list

### Red Flags

**Never:**
- Proceed with failing tests
- Merge without verifying tests on the merged result
- Delete work without typed "discard" confirmation
- Force-push without explicit request
- Create a PR without spec traceability in the body
- Skip logging to `.workflow-state.md` when it exists

**Always:**
- Verify tests before offering options (HARD GATE)
- Verify tests after merge (HARD GATE)
- Present exactly 4 options
- Get typed "discard" confirmation for Option 4
- Clean up worktree for Options 1 and 4 only
- Log option chosen to `.workflow-state.md`
- Include SPEC.md and TASKS.md references in PR body

### Integration

**Pairs with:**
- **git-worktrees** — cleans up worktree created by that skill

**Called by:**
- **implementation** — after all tasks complete

## Verification

Before completing the branch workflow, confirm:

- [ ] Tests verified passing before options were presented (HARD GATE)
- [ ] Exactly 4 options presented to user (no more, no less)
- [ ] User's choice executed correctly
- [ ] For Option 1: Tests verified passing on merged result (HARD GATE)
- [ ] For Option 2: PR body includes SPEC.md acceptance criteria and TASKS.md task references
- [ ] For Option 4: Typed "discard" confirmation received before deletion
- [ ] Worktree cleaned up (Options 1 and 4 only)
- [ ] Branch completion logged to `.workflow-state.md` (if it exists)
