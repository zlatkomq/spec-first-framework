/**
 * Spec-First Framework plugin for OpenCode.
 *
 * Injects framework context via system prompt transform so the AI knows
 * spec-first skills are available in this project.
 *
 * Skills are discovered natively by OpenCode from the symlinked skills directory.
 * See .opencode/INSTALL.md for setup instructions.
 */

export const SpecFirstFrameworkPlugin = async ({ client, directory }) => {
  const bootstrap = `## Spec-First Framework

This project uses the spec-first-framework. Skills are available in the \`skills/\` directory.
Load the relevant SKILL.md before starting any of the following tasks:

| Skill | Use for |
|-------|---------|
| spec-creation | Creating SPEC.md specification documents |
| design-creation | Creating DESIGN.md technical designs |
| uix-creation | Creating UIX-SPEC.md (Figma mapping) and managing the cached \`figma/\` design context |
| task-creation | Creating TASKS.md task breakdowns |
| implementation | Implementing code following specs and tasks |
| subagent-driven-development | Multi-task orchestration via dispatched subagents |
| code-review | Reviewing code against specs (end-of-feature review) |
| adversarial-review | Reviewing any document with extreme skepticism |
| bugfixing | Creating BUG.md bug reports |
| bug-implementation | Implementing bug fixes |
| bug-review | Reviewing bug fixes |
| change-request | Handling scope changes and change proposals |
| constitution-creation | Creating CONSTITUTION.md project standards |
| git-worktrees | Workspace isolation for feature branches |
| finishing-development-branch | Branch merge / PR / cleanup |
| systematic-debugging | Root-cause investigation (\`/debug\`) |`;

  return {
    'experimental.chat.system.transform': async (_input, output) => {
      (output.system ||= []).push({ type: 'text', text: bootstrap });
    }
  };
};
