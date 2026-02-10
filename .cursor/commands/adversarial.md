# adversarial

Review any content with extreme skepticism. Finds at least 10 issues in whatever you give it — a spec, a design doc, a task breakdown, a story, a PR description, or any other artifact.

## Usage

`/adversarial @path/to/file.md` — adversarial review of the referenced file.

`/adversarial` (with no argument) — ask the user what to review.

The user can also paste content directly after the command.

## Behavior

Apply `.cursor/rules/adversarial-review.mdc` to the provided content.

This is a standalone review tool — it does not modify any files, does not produce a formal REVIEW.md, and does not interact with the `/flow` workflow. It simply finds problems and presents them.

Use cases:
- Review a SPEC.md before approving it at Gate 1
- Review a DESIGN.md before approving it at Gate 2
- Review a TASKS.md before approving it at Gate 3
- Review a Change Proposal before approving it
- Review any document or code for quality

## Reference

- Rules: `.cursor/rules/adversarial-review.mdc`
