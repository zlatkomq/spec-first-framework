# review

Generate REVIEW.md for a completed spec.

Apply @skills/code-review/SKILL.md using @.framework/templates/REVIEW.template.md and @CONSTITUTION.md.

The user's message after /review should reference the spec (e.g. "006" or "@specs/006-user-export/SPEC.md"). If not provided, ask which spec to review.

**Branch management:** This command does not manage branches. For the full workflow with branch isolation and post-review branch finishing, use `/flow`.