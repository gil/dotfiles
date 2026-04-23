---
description: Global coding, testing, tooling, and shell usage rules
alwaysApply: true
---

# Code Style

- DO NOT add code comments unless they explain non-obvious intent, trade-offs, or constraints. Never comment obvious behavior.
- Keep responses concise. Omit filler, narration, and redundant explanations.

# Tooling

- ALWAYS use `pnpm` with Corepack when creating a new JavaScript or TypeScript project. NEVER use npm or yarn.
- ALWAYS use ripgrep (`rg`) instead of `grep` for file searching. NEVER use `grep`.

# Environment Setup

- ALWAYS run `fnm use` before ANY shell command in a Node.js project. Do this once at the start of the session.
- ALWAYS run `export GIT_PAGER=cat` before ANY git command. Do this once at the start of the session.

# Shell Usage

- Prefer tools that don't require Bash permission prompts (e.g. Read, Grep, Glob) over Shell whenever possible.
- Avoid compound Shell commands (`&&`, `||`, `;`, pipes) and command substitutions (`$()`). Use separate sequential tool calls instead.
- If a Shell command unexpectedly triggers a permission prompt, flag it and suggest updating this guidance or `settings.json` permissions to prevent it.

# Git

- NEVER commit, push, amend, rebase, merge, tag, or perform any git write operation unless the user explicitly asks for it. Read-only git commands (status, log, diff, blame, branch --list) are always allowed.

# Testing

- DO NOT add mocks unless a test specifically requires them.
- After writing tests, ALWAYS audit and remove every unnecessary mock.
- After completing ANY change, ALWAYS fix all linting errors and run tests on every changed file.
