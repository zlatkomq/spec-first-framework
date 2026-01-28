# Changelog

All notable changes to the Spec-First AI Development Framework will be documented in this file.

## [0.5.0] - 2026-01-28

### Summary

Added comprehensive **bugfixing workflow** support to the framework. This release extends the framework beyond greenfield development to include structured bug fixing and maintenance workflows.

### What's New

#### Bugfixing Workflow
- **3-step bugfix process**: BUG → Implementation → Review
- **2 quality gates** with human approval checkpoints
- **Full traceability** from bug report to fix, linked back to original SPEC.md
- **Regression testing** requirements built into the workflow

#### New Rules (`.cursor/rules/`)
- `bugfixing.mdc` — Create bug reports from issues
- `bug-implementation.mdc` — Implement bug fixes following standards
- `bug-review.mdc` — Review fixes against bug criteria and original spec

#### New Templates (`.framework/templates/`)
- `BUG.template.md` — Bug report structure with severity, steps to reproduce, and acceptance criteria
- `BUG-REVIEW.template.md` — Bug fix review structure

#### Workflow Diagrams
- `framework-bugfix-workflow.mermaid` — Visual bugfix workflow diagram
- `framework-workflow-final.mermaid` — Updated feature workflow (separated from bugfix)

#### Bug Status Lifecycle
- **DRAFT** → Tech Lead approval → **CONFIRMED** → Fix implemented → **FIXED**

### Improvements

- Separated feature and bugfix workflows into distinct diagrams for clarity
- Moved framework examples to `docs/examples/` for better organization
- Updated `.gitignore` to exclude `specs/` folder (testing only)
- Aligned all rules and templates for consistency

### How to Use Bugfixing

1. When a bug is found, reference the original `SPEC.md`
2. Create `BUG.md` using: `@bugfixing.mdc` + `@SPEC.md` + issue description
3. Tech Lead approves bug report (Gate 1)
4. Implement fix using: `@bug-implementation.mdc` + `@BUG.md` + `@DESIGN.md`
5. Review fix using: `@bug-review.mdc` + `@BUG.md` + `@SPEC.md`
6. Reviewer approves fix (Gate 2)
7. Update original `SPEC.md` Bug History section

See [README.md](README.md) and workflow diagrams for detailed instructions.

---

## [0.4.0] - 2026-01-23

### Summary

First public release of the Spec-First AI Development Framework. This version provides a complete workflow for **greenfield backend API development** using AI-assisted coding.

### What's Included

#### Workflow
- **5-step development process**: SPEC → DESIGN → TASKS → Implementation → Review
- **4 quality gates** with human approval checkpoints
- **Full traceability** from requirements to code

#### Rules (`.cursor/rules/`)
- `spec-creation.mdc` — Create specifications from requirements
- `design-creation.mdc` — Generate technical designs from approved specs
- `task-creation.mdc` — Break designs into atomic, implementable tasks
- `implementation.mdc` — Implement code following standards
- `code-review.mdc` — Review code against acceptance criteria
- `constitution-creation.mdc` — Define project-level standards

#### Templates (`.framework/templates/`)
- `SPEC.template.md` — Specification structure
- `DESIGN.template.md` — Technical design structure
- `TASKS.template.md` — Task breakdown structure
- `CONSTITUTION.template.md` — Project standards structure

#### Example
- Complete 001 User Registration example showing full workflow execution

#### Documentation
- `README.md` — Quick start guide
- `PHILOSOPHY.md` — Framework principles and approach
- `FOLDER-STRUCTURE.md` — Detailed folder and file descriptions
- `WORKFLOW-DEMO.md` — Live walkthrough of the workflow

### Scope & Limitations

**Current version is optimized for:**
- Greenfield projects (new codebases)
- Backend API development (services, APIs, database-backed applications)
- Cursor IDE (using `.mdc` rule files)

**Not yet supported:**
- Frontend/mobile development (planned)
- Brownfield/legacy codebases (planned)
- Other IDEs (Claude Code, Antigravity — planned)
- Enforcement tooling (CI checks, pre-commit hooks — planned)

### How to Adopt

1. Copy `.cursor/` and `.framework/` folders into your project
2. Create `CONSTITUTION.md` using: `@constitution-creation.mdc` + your project description
3. For each spec, follow the workflow: SPEC → DESIGN → TASKS → Implementation → Review

See [README.md](README.md) for detailed instructions.

---

## Planned for Future Releases

### 0.6.0 (Planned)
- Frontend/mobile templates and rules
- Component architecture support
- State management patterns

### 0.7.0 (Planned)
- Brownfield/legacy codebase support
- Codebase analysis rules
- Legacy assessment templates

### 1.0.0 (Planned)
- Production-ready across all domains
- Enforcement tooling
- Multi-IDE support
- Jira integration
