---
description: Global coding, testing, tooling, and shell usage rules
alwaysApply: true
---

# Code Style

- DO NOT add code comments unless they explain non-obvious intent, trade-offs, or constraints. Never comment obvious behavior.
- Keep responses concise. Omit filler, narration, and redundant explanations.
- If something isn't clear, don't make assumptions. Ask me questions, suggest alternatives when possible.

# Tooling

- ALWAYS use `pnpm` with Corepack when creating a new JavaScript or TypeScript project. NEVER use npm or yarn.
- ALWAYS use `tsdown` instead of `tsup`.
- Prefer ripgrep (`rg`) over of `grep` for file searching.
- If any tool would help you perform your task more easily, stop and tell me how you'd install it, offering to do it for me in case I approve.

# Environment Setup

- ALWAYS run `fnm use` before ANY shell command in a Node.js project. Do this once at the start of the session.
- ALWAYS run `export GIT_PAGER=cat` before ANY git command. Do this once at the start of the session.

# Shell Usage

- Prefer tools that don't require Bash permission prompts (e.g. Read, Grep, Glob) over Shell whenever possible.
- Avoid compound Shell commands (`&&`, `||`, `;`, pipes) and command substitutions (`$()`). Use separate sequential tool calls instead.
- If a Shell command unexpectedly triggers a permission prompt, flag it and suggest updating this guidance or `settings.json` permissions to prevent it.
- NEVER kill processes by name or pattern. No `killall`, no `pkill`, no `pkill -f <anything>` (including `pkill -f vite`, `pkill -f vite-node`, `pkill -f node`). Pattern matches hit processes in other projects, other dev servers, and the browser.
- To free a port, ALWAYS use port-specific termination: `lsof -ti :PORT | xargs kill -9`
- To stop a process YOU started in THIS session, kill it by its exact PID or job spec (`kill %1`), never by name match.

# Git

- NEVER commit, push, amend, rebase, merge, tag, or perform any git write operation unless the user explicitly asks for it. Read-only git commands (status, log, diff, blame, branch --list) are always allowed.
- NEVER branch without approval. Ask me if you think branching is appropriate.

# Testing

- DO NOT add mocks unless a test specifically requires them.
- After writing tests, ALWAYS audit and remove every unnecessary mock.
- After completing ANY change, ALWAYS fix all linting errors and run tests on every changed file.
