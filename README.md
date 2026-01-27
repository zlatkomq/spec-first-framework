# Spec-First AI Development Framework

A structured methodology for AI-assisted software development. Ensures traceability, quality gates, and consistent outputs across projects.

## Quick Start

1. Copy `.cursor/` and `.framework/` folders into your project
2. Create `CONSTITUTION.md` using: `@constitution-creation.mdc` + your project description
3. For each spec, follow the workflow: SPEC → DESIGN → TASKS → Implementation → Review

## Workflow

### Feature Workflow

```
STEP 0: CONSTITUTION.md (once per project)
         ↓
STEP 1: SPEC.md → Gate 1 (PO approves)
         ↓
STEP 2: DESIGN.md → Gate 2 (Tech Lead approves)
         ↓
STEP 3: TASKS.md → Gate 3 (Tech Lead approves)
         ↓
STEP 4: Implementation (per task)
         ↓
STEP 5: Code Review → Gate 4 (Reviewer approves) → Done
```

### Bugfix Workflow

```
BUG REPORTED + Original SPEC.md reference
         ↓
STEP 1: BUG.md → Gate 1 (Tech Lead confirms)
         ↓
STEP 2: Implementation (fix + regression test)
         ↓
STEP 3: Bug Review → Gate 2 (Reviewer approves)
         ↓
Update original SPEC.md Bug History → Done
```

## Folder Structure

```
your-project/
├── .cursor/
│   └── rules/
│       ├── spec-creation.mdc
│       ├── design-creation.mdc
│       ├── task-creation.mdc
│       ├── implementation.mdc
│       ├── code-review.mdc
│       ├── bugfixing.mdc
│       ├── bug-implementation.mdc
│       ├── bug-review.mdc
│       └── constitution-creation.mdc
├── .framework/
│   ├── templates/
│   │   ├── SPEC.template.md
│   │   ├── DESIGN.template.md
│   │   ├── TASKS.template.md
│   │   ├── BUG.template.md
│   │   ├── BUG-REVIEW.template.md
│   │   └── CONSTITUTION.template.md
│   └── CONSTITUTION.md          ← You create this
├── specs/
│   └── XXX-description/
│       ├── SPEC.md
│       ├── DESIGN.md
│       ├── TASKS.md
│       └── REVIEW.md
├── bugs/
│   └── BUG-XXX-description/
│       ├── BUG.md
│       └── REVIEW.md
└── src/
```

## Usage

### Step 0: Project Setup (once)

```
@constitution-creation.mdc Create CONSTITUTION.md:
- Python 3.12, FastAPI
- PostgreSQL
- pytest, 80% coverage
- REST API
```

### Step 1: Create Specification

```
@spec-creation.mdc Create SPEC.md for 001 user authentication:
[paste requirements from PO/client]
```

### Step 2: Create Technical Design

```
@design-creation.mdc Create DESIGN.md based on @specs/001-user-authentication/SPEC.md
```

### Step 3: Create Task Breakdown

```
@task-creation.mdc Create TASKS.md based on @specs/001-user-authentication/DESIGN.md
```

### Step 4: Implement

```
@implementation.mdc Implement T1 from @specs/001-user-authentication/TASKS.md
```

### Step 5: Review

```
@code-review.mdc Review 001 against @specs/001-user-authentication/SPEC.md
```

---

## Bugfix Usage

### Step 1: Create Bug Report

```
@bugfixing.mdc Create BUG.md for issue in @specs/FEAT-001-user-registration/SPEC.md:
Email validation passes for "user@domain" (missing TLD).
Steps: Enter "test@domain", click register, succeeds but shouldn't.
```

### Step 2: Implement Fix

```
@bug-implementation.mdc Implement T1 from @bugs/BUG-001-email-validation/BUG.md
```

### Step 3: Review Fix

```
@bug-review.mdc Review @bugs/BUG-001-email-validation/BUG.md
```

After approval, update the original SPEC.md Bug History table.

---

## When to Use Each Workflow

| Situation | Workflow |
|-----------|----------|
| New feature or enhancement | Feature workflow (SPEC.md) |
| Code violates existing acceptance criteria | Bugfix workflow (BUG.md) |
| Acceptance criteria was missing or wrong | Feature workflow (narrow spec) |
| Refactoring without behavior change | Feature workflow (Type: Refactor) |
| Performance optimization | Feature workflow (Type: Performance) |
| Database/system migration | Feature workflow (Type: Migration) |

Note: Dedicated workflows for Refactor, Performance, and Migration may be added in future versions.

## Documentation

- [FOLDER-STRUCTURE.md](FOLDER-STRUCTURE.md) — Detailed folder and file descriptions
- [framework-workflow-final.mermaid](framework-workflow-final.mermaid) — Visual workflow diagram
- [framework-legacy-analysis.mermaid](framework-legacy-analysis.mermaid) — Brownfield analysis flow (coming soon)

## Status

**Greenfield workflow:** ✅ Complete
**Bugfix workflow:** ✅ Complete
**Brownfield workflow:** 🚧 In progress
