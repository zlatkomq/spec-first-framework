# validate

Check framework integrity — verify all required files exist and cross-references are valid.

## Usage

`/validate` — run all integrity checks and report results.

## Behavior

This is a read-only diagnostic. It does not modify any files.

### Checks

**1. Step files** — Verify all 6 step files exist in `.framework/steps/`:

| File | Purpose |
|------|---------|
| `step-00-continue.md` | Resume workflow |
| `step-01-spec.md` | Specification |
| `step-02-design.md` | Design |
| `step-03-tasks.md` | Task breakdown |
| `step-04-implement.md` | Implementation |
| `step-05-review.md` | Code review |

**2. Templates** — Verify all expected templates exist in `.framework/templates/`:

| File |
|------|
| `SPEC.template.md` |
| `DESIGN.template.md` |
| `TASKS.template.md` |
| `REVIEW.template.md` |
| `CONSTITUTION.template.md` |
| `BUG.template.md` |
| `BUG-REVIEW.template.md` |
| `CHANGE-PROPOSAL.template.md` |
| `SPEC-CURRENT.template.md` |
| `workflow-state.template.md` |

**3. Checklists** — Verify all expected checklists exist in `.framework/checklists/`:

| File |
|------|
| `verification-checklist.md` |

**4. Rules** — Verify all expected rules exist in `.cursor/rules/`:

| File |
|------|
| `spec-creation.mdc` |
| `design-creation.mdc` |
| `task-creation.mdc` |
| `implementation.mdc` |
| `code-review.mdc` |
| `constitution-creation.mdc` |
| `bugfixing.mdc` |
| `bug-implementation.mdc` |
| `bug-review.mdc` |
| `change-request.mdc` |
| `adversarial-review.mdc` |

**5. CONSTITUTION.md** — Check if `.framework/CONSTITUTION.md` exists. If missing, warn: "No CONSTITUTION.md found. Run `/constitute` to create one."

**6. Cross-references** — For each step file, verify that `ruleRef` and `templateRef` paths point to files that exist. For each rule file, verify that `@.framework/templates/*.md` references point to files that exist. Report any broken references.

### Output

Present results as a table:

```
Framework Integrity Report

| Category | Expected | Found | Status |
|----------|----------|-------|--------|
| Steps | 6 | 6 | ✅ |
| Templates | 10 | 10 | ✅ |
| Checklists | 1 | 1 | ✅ |
| Rules | 11 | 11 | ✅ |
| CONSTITUTION | 1 | 1 | ✅ |
| Cross-references | N | N | ✅ |

Result: Framework integrity verified.
```

If any files are missing or cross-references are broken, list them:

```
Missing files:
- .framework/steps/step-03-tasks.md

Broken cross-references:
- step-04-implement.md → ruleRef: .cursor/rules/implementation.mdc (NOT FOUND)

Result: Framework integrity FAILED — [N] issues found.
```
