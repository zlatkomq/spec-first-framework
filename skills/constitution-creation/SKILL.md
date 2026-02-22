# Constitution Creation

## Description

Use when creating or updating the `CONSTITUTION.md` project standards document from a Tech Lead's project description.
Not for feature specifications — use the spec-creation skill. Not for technical design — use the design-creation skill.

## Instructions

You are creating a project constitution document. Follow these rules strictly.

### Required Inputs

Before creating a CONSTITUTION.md, you must have:
- Freeform project description from Tech Lead (tech stack, standards, constraints)

If the input is too vague to fill required sections, ASK for clarification. Do not invent standards.

#### Clarification Style

When gathering project details or resolving ambiguity:
- Ask ONE question at a time. Never dump a list of questions.
- Prefer multiple-choice over open-ended ("Should we use pytest or unittest?" instead of "What testing framework?")
- Wait for the user's answer before asking the next question.
- Each question should build on the previous answer, narrowing scope progressively.

### Template

Always use the template structure from `../../.framework/templates/CONSTITUTION.template.md`

### Field Rules

#### Metadata
- **Project Name**: Extract from input or ask if unclear
- **Project Type**: GREENFIELD or BROWNFIELD (ask if not specified)
- Status is always DRAFT until Tech Lead approves
- Author: Tech Lead name + "/ AI-assisted"
- Date: today's date

#### Overview
- Maximum 3 sentences
- Must answer: What is this project? What problem does it solve?
- If not provided, ASK — do not invent project purpose

#### Tech Stack
- Every layer mentioned must have a concrete version (e.g., "Python 3.12", not "Python" or "latest")
- If version not specified, ASK
- Common layers: Language, Framework, Database, Testing, Linting, Package Manager
- **Package Manager**: Must be specified (e.g., npm, yarn, pnpm, bun, pip, poetry, go modules). If not specified, ASK.
- **Module System**: For JavaScript/TypeScript projects, must specify ESM or CJS. For other languages, use N/A.
- Add rows for additional tech (ORM, caching, message queue, etc.) if mentioned

#### Project Structure
- **Source and Test directories must be explicitly named** in the directory table (e.g., Source: `src/`, Tests: `test/`). These are referenced by downstream skills (implementation, code-review) to locate code and tests.
- Show actual folder tree below the table, reflecting the framework's conventions (e.g., FastAPI, Django, Express patterns)
- If not specified, propose standard structure for the chosen framework

#### Commands
- Every action in the table must have a concrete, executable command (e.g., `npm test`, not "run the tests")
- **Run all tests** and **Build** are mandatory. If the project has no build step, write `N/A`.
- **Run single test file**: Must include the placeholder pattern (e.g., `npm test -- <file>`, `pytest <file>`, `go test <package>`)
- **Lint**, **Type check**, **Format**: Fill if applicable, remove row if not
- If commands are not specified, derive from the tech stack and confirm with user
- These commands are used by task-creation (Verify fields) and code-review (test execution)

#### Coding Standards

**Naming Conventions**
- Must be specific and enforceable (e.g., "snake_case" not "descriptive names")
- Provide concrete examples for each element
- If not specified, propose language-standard conventions and confirm with user

**Patterns to Use / Avoid**
- Be specific (e.g., "Repository pattern for data access" not "use good patterns")
- Include at least 2 items in each list
- If not specified, propose common patterns for the tech stack and confirm

#### Error Handling
- **Strategy**: Must specify the approach (throw exceptions, return Result/Either type, error codes). If not specified, ASK — this affects every file the implementation skill creates.
- **Logging**: Must specify library and level conventions (e.g., "pino with levels: error, warn, info" or "logging module, WARNING level for production"). If no logging needed, write "No logging — CLI/library project."
- **User-facing errors**: Must specify format. For APIs, reference the API Standards error format. For CLIs, describe error output conventions. For libraries, describe error types/classes.
- If not specified, propose conventions for the tech stack and confirm

#### Testing Standards
- Coverage threshold must be a number (e.g., "80%", not "high")
- Specify test frameworks explicitly
- If not specified, ASK for coverage requirement — do not assume

#### API Standards
- Only include if project has an API
- Error format should be concrete (e.g., "RFC 7807 Problem Details" or show JSON structure)
- If project has no API, remove this section entirely

#### Security Standards
- Must use the structured table format with three mandatory concerns:
  - **Input Validation**: Specific library or approach (e.g., "Zod schemas" or "Pydantic models" or "manual validation with early returns")
  - **Authentication**: Method if applicable (e.g., "JWT with RS256", "session-based", or "N/A — no auth")
  - **Secrets Handling**: How secrets are managed (e.g., "env vars via dotenv, never committed", "AWS Secrets Manager")
- Be specific (e.g., "Zod for input validation" not "validate inputs")
- If not specified, propose security baseline and confirm

#### Quality Gates
- List concrete checks that must pass before merge
- Each gate should reference a command from the Commands section where applicable (e.g., "All tests pass (`npm test`)")
- Typical gates: linting, type checking, unit tests, coverage threshold, security scan
- These should be automatable in CI/CD

#### Open Questions
- Capture any unresolved decisions
- Format as checklist: `- [ ] Question here?`
- These should be resolved before first spec begins

### Constraints

- Do NOT invent project requirements or standards not provided
- Do NOT use vague language ("appropriate", "proper", "good") — be specific
- Do NOT leave placeholder text — ask if info is missing
- Do NOT include brownfield sections (Legacy Boundaries, Migration Strategy) for greenfield projects
- All bracket placeholders from template must be removed from output
- Versions must be concrete (3.12, not "latest")
- Commands must be executable (not descriptions of what to do)

### Output

Save the file to: `.framework/CONSTITUTION.md`

## Verification

- [ ] All required sections filled (no placeholders)
- [ ] Tech stack has concrete versions
- [ ] Package manager specified
- [ ] Module system specified (or N/A for non-JS/TS)
- [ ] Source and test directories explicitly named in Project Structure table
- [ ] Commands table has executable commands for test and build
- [ ] Naming conventions have examples
- [ ] Error handling strategy, logging, and user-facing error format specified
- [ ] Security standards table has input validation, authentication, and secrets handling
- [ ] Coverage threshold is a specific number
- [ ] Quality gates are actionable and reference commands where applicable
- [ ] Status set to DRAFT
- [ ] File saved in correct location
