# bugfix

Implement a task from an approved BUG.md.

Apply @skills/bug-implementation/SKILL.md using @CONSTITUTION.md.

The user's message after /bugfix should specify the task (e.g. "T1 from BUG-001" or "@bugs/BUG-001-description/BUG.md"). If not provided, ask which bug task to implement.

**Branch management:** The bug-implementation skill will invoke git-worktrees for workspace isolation. After the fix is reviewed and approved via `/bugreview`, use the finishing-development-branch skill manually to handle merge/PR/cleanup.