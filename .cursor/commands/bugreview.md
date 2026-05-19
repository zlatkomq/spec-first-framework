# bugreview

Review a completed bugfix.

Apply @skills/bug-review/SKILL.md using @.framework/templates/BUG-REVIEW.template.md.

The user's message after /bugreview should reference the bug (e.g. "BUG-001" or "@bugs/BUG-001-description/BUG.md"). If not provided, ask which bug to review.

**Branch management:** This command does not handle branch finishing. After approval, use the finishing-development-branch skill (`@skills/finishing-development-branch/SKILL.md`) to merge, create a PR, or clean up the branch.