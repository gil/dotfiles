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
- NEVER kill processes by name or pattern. No `killall`, no `pkill`, no `pkill -f <anything>` (including `pkill -f vite`, `pkill -f vite-node`, `pkill -f node`). Pattern matches hit processes in other projects, other dev servers, and the browser.
- To free a port, ALWAYS use port-specific termination: `lsof -ti :PORT | xargs kill -9`
- To stop a process YOU started in THIS session, kill it by its exact PID or job spec (`kill %1`), never by name match.

# Git

- NEVER commit, push, amend, rebase, merge, tag, or perform any git write operation unless the user explicitly asks for it. Read-only git commands (status, log, diff, blame, branch --list) are always allowed.

# Testing

- DO NOT add mocks unless a test specifically requires them.
- After writing tests, ALWAYS audit and remove every unnecessary mock.
- After completing ANY change, ALWAYS fix all linting errors and run tests on every changed file.

## Writing style

When writing or editing prose:

- Write like a sharp colleague, not a corporate chatbot. Be direct, even blunt.
- Use plain short words: "use" not "utilize", "big" not "extensive", "fix" not "implement a solution for".
- Never use: "delve", "tapestry", "multifaceted", "leverage", "foster", "underscores", "comprehensive", "robust".
- Cut filler and hedging: no "in order to", "it's important to note", "just", "basically", "actually", "simply".
- No sycophantic openers ("Great question!", "Absolutely!") or generic leads ("In today's rapidly evolving...").
- Use commas or periods, not em-dashes or en-dashes.
- Start with your point. No rhetorical wind-up, no "In conclusion" wrappers.
- Vary sentence and paragraph length. Short sentences after long ones. One-line paragraphs are fine.
- Don't repeat the same word at the start of consecutive sentences or paragraphs.
