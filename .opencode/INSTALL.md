# OpenCode Setup

OpenCode requires manual registration of the plugin and skills directory.
Run the commands below from the root of this repository.

## 1. Register the plugin

```bash
mkdir -p ~/.config/opencode/plugins
ln -s "$(pwd)/.opencode/plugins/spec-first.js" ~/.config/opencode/plugins/spec-first.js
```

## 2. Register the skills

```bash
mkdir -p ~/.config/opencode/skills
ln -s "$(pwd)/skills" ~/.config/opencode/skills/spec-first
```

## 3. Restart OpenCode

Restart your OpenCode session. The spec-first-framework context and skills will be available.

## Uninstall

```bash
rm ~/.config/opencode/plugins/spec-first.js
rm ~/.config/opencode/skills/spec-first
```
