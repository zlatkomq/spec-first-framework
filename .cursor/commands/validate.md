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

**4. Skills** — Verify all 11 skill directories exist in `skills/`, each containing a `SKILL.md`:

| Directory | Skill |
|-----------|-------|
| `skills/spec-creation/` | Spec creation |
| `skills/constitution-creation/` | Constitution creation |
| `skills/design-creation/` | Technical design |
| `skills/task-creation/` | Task breakdown |
| `skills/implementation/` | Implementation |
| `skills/code-review/` | Code review |
| `skills/adversarial-review/` | Adversarial review |
| `skills/bugfixing/` | Bug analysis |
| `skills/bug-implementation/` | Bug implementation |
| `skills/bug-review/` | Bug review |
| `skills/change-request/` | Change requests |

**5. CONSTITUTION.md** — Check if `CONSTITUTION.md` exists. If missing, warn: "No CONSTITUTION.md found. Run `/constitute` to create one."

**6. Cross-references** — Verify that all skill and command references resolve to existing files:

- For each `skills/<name>/SKILL.md`: verify that relative framework refs (`../../.framework/templates/*.md`, `../../CONSTITUTION.md`, `../../.framework/checklists/*.md`) point to files that exist. Verify that cross-skill refs (`../other-skill/SKILL.md`) point to files that exist.
- For each command file in `.cursor/commands/`: verify that `@skills/<name>/SKILL.md` paths point to existing SKILL.md files.
- For each step file in `.framework/steps/`: verify that `ruleRef: '@skills/<name>/SKILL.md'` paths point to existing SKILL.md files, and that `templateRef` paths exist.

Report any broken references.

**7. No stale .mdc references** — Scan all files in `.cursor/commands/` and `.framework/steps/`. Fail if any reference to `.cursor/rules/*.mdc` is found.

**8. Platform adapters** — Verify that all three platform adapter files exist:

| File | Platform |
|------|----------|
| `.cursor-plugin/plugin.json` | Cursor |
| `.claude-plugin/plugin.json` | Claude Code |
| `.opencode/plugins/spec-first.js` | OpenCode |

### Output

Present results as a table:

```
Framework Integrity Report

| Category        | Expected | Found | Status |
|-----------------|----------|-------|--------|
| Steps           | 6        | 6     | ✅     |
| Templates       | 10       | 10    | ✅     |
| Checklists      | 1        | 1     | ✅     |
| Skills          | 11       | 11    | ✅     |
| CONSTITUTION    | 1        | 1     | ✅     |
| Cross-references| N        | N     | ✅     |
| Stale .mdc refs | 0        | 0     | ✅     |
| Adapters        | 3        | 3     | ✅     |

Result: Framework integrity verified.
```

If any files are missing or cross-references are broken, list them:

```
Missing files:
- skills/implementation/SKILL.md

Broken cross-references:
- skills/code-review/SKILL.md → ../implementation/SKILL.md (NOT FOUND)

Stale .mdc references:
- .cursor/commands/implement.md → @.cursor/rules/implementation.mdc (STALE)

Missing adapters:
- .opencode/plugins/spec-first.js (NOT FOUND)

Result: Framework integrity FAILED — [N] issues found.
```
