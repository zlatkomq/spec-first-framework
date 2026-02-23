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

### Creation Flow

Follow this sequence when creating a constitution:

#### Phase 1: Gather Essentials

Get the minimum needed to derive everything else:
1. Project name and overview (extract from input or ask)
2. Project type: GREENFIELD or BROWNFIELD
3. Tech stack: Language, Framework, Database, Testing framework

These four decisions unlock the defaults for everything else.

#### Phase 2: Propose Defaults

Once the tech stack is known, propose a **complete constitution draft** with industry-standard defaults derived from the tech stack. Present it as a single block for the user to review, not as individual questions.

Derivable defaults (propose based on tech stack):
- **Package Manager**: npm for Node.js, pip/poetry for Python, go modules for Go, etc.
- **Commands**: Test, build, lint commands standard for the tech stack
- **Naming Conventions**: Language-standard conventions (camelCase for JS, snake_case for Python, etc.)
- **File Structure**: Framework-standard directory layout
- **Test File Conventions**: Standard for the chosen test framework
- **Quality Gates**: Standard set (tests pass, lint clean, coverage threshold)

Present as: "Based on [tech stack], here are the proposed defaults. Review and tell me what to change:"

#### Phase 3: Ask Project-Specific Questions

After defaults are confirmed, ask ONE AT A TIME about fields that genuinely vary between projects and cannot be derived from the tech stack:

1. **Error handling strategy** — "Should errors be thrown as exceptions, returned as Result types, or use error codes?"
2. **Logging** — "What logging library and level conventions? Or no logging if it's a simple project?"
3. **User-facing error format** — "For API errors, use RFC 7807, custom JSON, or HTTP status only?" (skip if no API)
4. **Security: Input validation** — "What library for input validation? (e.g., Zod, Joi, Pydantic, manual)"
5. **Security: Authentication** — "What auth method? (JWT, session-based, API key, or N/A)"
6. **Security: Secrets handling** — "How are secrets managed? (env vars, vault, config files)"
7. **Coverage threshold** — "What minimum test coverage? (e.g., 80%)"
8. **Patterns to Use / Avoid** — "Any specific patterns you want enforced or banned beyond the defaults?"

Skip questions the user already answered in their initial description. Skip questions that don't apply (e.g., don't ask about API error format for a CLI tool).

#### Phase 4: Generate

Produce the final CONSTITUTION.md with all confirmed values.

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
- Add rows for additional tech (ORM, caching, message queue, etc.) if mentioned

#### Commands
- Every action in the table must have a concrete, executable command (e.g., `npm test`, not "run the tests")
- **Run all tests** and **Build** are mandatory. If the project has no build step, write `N/A`.
- **Run single test file**: Must include the placeholder pattern (e.g., `npm test -- <file>`, `pytest <file>`, `go test <package>`)
- **Lint**, **Type check**, **Format**: Fill if applicable, remove row if not
- These commands are used by task-creation (Verify fields) and code-review (test execution)

#### Coding Standards

**Naming Conventions**
- Must be specific and enforceable (e.g., "snake_case" not "descriptive names")
- Provide concrete examples for each element
- Propose language-standard conventions as defaults — only ask if the user wants non-standard conventions

**File Structure**
- Show actual folder tree, reflecting the framework's conventions (e.g., FastAPI, Django, Express patterns)
- Propose standard structure for the chosen framework as default

**Patterns to Use / Avoid**
- Be specific (e.g., "Repository pattern for data access" not "use good patterns")
- Include at least 2 items in each list
- Propose common patterns for the tech stack as defaults, confirm with user

#### Error Handling
- **Strategy**: Must specify the approach (throw exceptions, return Result/Either type, error codes). ASK — this affects every file the implementation skill creates.
- **Logging**: Must specify library and level conventions. If no logging needed, write "No logging — CLI/library project."
- **User-facing errors**: Must specify format. For APIs, reference the API Standards error format. For CLIs, describe error output conventions. For libraries, describe error types/classes.

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

Save the file to: `CONSTITUTION.md`

## Verification

- [ ] All required sections filled (no placeholders)
- [ ] Tech stack has concrete versions
- [ ] Package manager specified
- [ ] Commands table has executable commands for test and build
- [ ] Naming conventions have examples
- [ ] File structure reflects framework conventions
- [ ] Error handling strategy, logging, and user-facing error format specified
- [ ] Security standards table has input validation, authentication, and secrets handling
- [ ] Coverage threshold is a specific number
- [ ] Quality gates are actionable and reference commands where applicable
- [ ] Status set to DRAFT
- [ ] File saved in correct location
