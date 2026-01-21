# Spec-First AI Development Framework

A structured methodology for AI-assisted software development. Ensures traceability, quality gates, and consistent outputs across projects.

## Quick Start

1. Copy `.cursor/` and `.framework/` folders into your project
2. Create `CONSTITUTION.md` using: `@constitution-creation.mdc` + your project description
3. For each feature, follow the workflow: SPEC → DESIGN → TASKS → Implementation → Review

## Workflow

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
│       └── constitution-creation.mdc
├── .framework/
│   ├── templates/
│   │   ├── SPEC.template.md
│   │   ├── DESIGN.template.md
│   │   ├── TASKS.template.md
│   │   └── CONSTITUTION.template.md
│   └── CONSTITUTION.md          ← You create this
├── specs/
│   └── FEAT-XXX-feature-name/
│       ├── SPEC.md
│       ├── DESIGN.md
│       ├── TASKS.md
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
@spec-creation.mdc Create SPEC.md for FEAT-001 user authentication:
[paste requirements from PO/client]
```

### Step 2: Create Technical Design

```
@design-creation.mdc Create DESIGN.md based on @specs/FEAT-001/SPEC.md
```

### Step 3: Create Task Breakdown

```
@task-creation.mdc Create TASKS.md based on @specs/FEAT-001/DESIGN.md
```

### Step 4: Implement

```
@implementation.mdc Implement T1 from @specs/FEAT-001/TASKS.md
```

### Step 5: Review

```
@code-review.mdc Review FEAT-001 against @specs/FEAT-001/SPEC.md
```

## Documentation

- [FOLDER-STRUCTURE.md](FOLDER-STRUCTURE.md) — Detailed folder and file descriptions
- [framework-workflow-final.mermaid](framework-workflow-final.mermaid) — Visual workflow diagram
- [framework-legacy-analysis.mermaid](framework-legacy-analysis.mermaid) — Brownfield analysis flow (coming soon)

## Status

**Greenfield workflow:** ✅ Complete
**Brownfield workflow:** 🚧 In progress

## License

Proprietary — Q Agency
