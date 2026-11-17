---
name: command-runner
description: Create or update gil.sh, a plain bash task runner at the repo root with build, dev, watch, and test commands detected from the project, plus any extra commands the user asks for (deploy, backup, QA builds, etc).
disable-model-invocation: true
---

# Command Runner

Create `gil.sh` at the root of the current repo, or update it if it already exists. It is a small bash task runner: each task is a function, run with `./gil.sh <task>`.

## What to do

1. Check if `gil.sh` exists at the repo root.
   - **Exists:** read it and edit in place. Keep every task, variable, and custom tweak the user already has. Only add or change what was asked. If the file is missing pieces from the structure below (like the `help` task or the dispatcher), add them without touching existing tasks.
   - **Missing:** start from `assets/gil.sh` (next to this file) and fill in the real commands.
2. If the user gave no instructions, fill in the default tasks: `build`, `dev`, `watch`, `test`. If they gave instructions, do those. Also add any default task that is missing, unless they said not to.
3. `chmod +x gil.sh`.
4. Check it: `bash -n gil.sh`, then `./gil.sh help`. Don't run the tasks themselves unless the user asks; dev and watch never exit, and builds and tests can be slow.
5. Tell the user which tasks you added and which command each one runs. Name any default task you skipped and why.
6. Suggest extra tasks the project would clearly benefit from, based on what you saw while reading it. Don't add them yet; list each with a name, the command it would run, and why. Examples of good signals:
   - `lint` / `format` / `typecheck`: the project has those scripts or tools configured.
   - `deploy`: a deploy script, CI deploy job, `Dockerfile`, or hosting config (`fly.toml`, `vercel.json`, etc).
   - `build_qa` or similar: env-specific config or modes (`.env.qa`, `--mode staging`).
   - `clean`, `db_migrate`, `release`, `preview`: matching scripts or documented steps.

   Only suggest tasks backed by something in the repo, and keep it short (a few at most). If nothing stands out, skip this step rather than padding it.

## Finding the default commands

Read the project's own files to learn how it is built. Look at, in rough order:

- `README` / `CONTRIBUTING` / docs: often say the exact commands.
- `package.json` `scripts`. Pick the package manager from the `packageManager` field or the lockfile (`pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lockb`/`bun.lock` → bun, `package-lock.json` → npm). No lockfile and no field → pnpm.
- `Makefile`, `justfile`, `Taskfile.yml`: wrap the existing targets instead of copying their contents.
- `Cargo.toml`, `go.mod`, `pyproject.toml`, `Gemfile`, `mix.exs`, `build.gradle`, `pom.xml`, `CMakeLists.txt`, `Dockerfile`/`compose.yaml`, etc.
- Bundler or tool config (`vite.config.*`, `tsdown.config.*`, `webpack.config.*`, `tsconfig.json`) to see what supports watch mode.

What each default task means:

- **build**: the production / release build. Examples: `pnpm build`, `cargo build --release`, `go build ./...`.
- **dev**: the development build or dev server. If the project has a dev server (`pnpm dev`, `rails server`), use that. If not, a non-release build (`cargo build`, `tsc`).
- **watch**: dev build that rebuilds when files change. Only add it if the project really supports it: a `watch` script, a tool flag (`tsdown --watch`, `tsc --watch`, `vite build --watch`, `webpack --watch`), or a watcher that is already a dependency or documented. If `dev` is already a dev server with hot reload, `watch` would just duplicate it; skip it and say so. Don't add a watcher that needs installing (like `cargo-watch` or `entr`) unless it's documented or already in use; mention it as an option instead.
- **test**: run the test suite once and exit. Examples: `pnpm test`, `cargo test`, `go test ./...`, `pytest`. If the test command defaults to watch mode (like `vitest`), use its run-once form (`vitest run`). If the project has no tests set up, skip it. The `test` function replaces bash's `test` builtin inside `gil.sh`, so always write checks as `[[ ... ]]`, never `test -f ...`.

Prefer calling the project's existing scripts (`pnpm build`) over inlining what they do. That way `gil.sh` doesn't drift when `package.json` changes.

If a default task has no clear command, skip it and tell the user. A guess that fails is worse than a missing task.

## Script rules

These keep every `gil.sh` consistent and the `help` output working. Follow them when adding any task.

- **Task = function.** Name with lowercase letters and underscores only (`build_qa`, not `build-qa`). The `help` parser only matches `^[a-z_]+\(\)`.
- **Description = `#` comment on the same line as the function name.** That's what `help` prints. Line them up with spaces after `{`:
  ```bash
  build() {   # production build
  ```
  Mention arguments in the description using `[...]`, e.g. `# build for QA [env, default: qa]`.
- **Pass extra args through with `"$@"`.** Most tasks just wrap another runner, so end that command with `"$@"`: `pnpm dev "$@"` lets `./gil.sh dev --port 4000` work. Put it where the wrapped tool expects extra args (usually last). Some runners need a separator to forward args to the script: `npm run dev -- "$@"`, `cargo run -- "$@"`. pnpm, yarn, and bun don't. Skip `"$@"` only when the task has no single command that could take them (e.g. it runs several steps), or when it already uses `$1` for its own argument; then `shift` that one off first (see "Arguments" below). No need to mention plain passthrough in the description.
- **Keep the header lines.** `set -euo pipefail` stops on the first error, on unset variables, and on failed pipes. `here`/`self`/`cd "$here"` make it run from its own folder, wherever it's called from. `help` reads `$self` to list tasks.
- **Keep the dispatcher at the bottom.** It runs only functions defined in the script (`declare -F`), so random commands can't be passed in. No args runs `help`. Unknown command prints an error, then help, and exits 1.
- **Only bash and standard Unix tools in the runner itself.** Tasks can call the project's tools, of course.
- Keep sections in this order: header, `.env` loading (if any), `# --- environment ---` (if any), `# --- tasks ---`, `help`, `# --- dispatcher ---`.

## Patterns for extra tasks

Use these when the user asks for more than the defaults. Add only what a task actually needs. A script with just build/dev/watch has no `.env` loading and no environment section.

### Arguments

Optional argument with a default:

```bash
build_qa() {   # build for QA [env, default: qa]
  local env="${1:-qa}"
  shift || true
  pnpm build --mode "$env" "$@"
}
```

`shift || true` drops the first arg so the rest still pass through. The `|| true` matters: `shift` fails when there are no args, and `set -e` would stop the script.

Pass extra flags straight through with `"$@"`:

```bash
deploy() {  # build and rsync to server [extra rsync args, e.g. --dry-run]
  build
  rsync -avz --delete "$@" dist/ "${DEPLOY_HOST:?set DEPLOY_HOST in .env}:$DEPLOY_PATH/"
}
```

Under `set -u`, always use `${1:-default}` for optional args. A bare `$1` crashes when it's missing.

### One task calling another

Just call the function: `deploy` calls `build` first. If `build` fails, `set -e` stops `deploy` too.

### Environment variables and `.env`

The first time a task needs a variable, add three things.

1. `.env` loading, right after `cd "$here"`:
   ```bash
   # Load .env if present (e.g. DEPLOY_HOST=user@myserver)
   if [[ -f .env ]]; then
     set -a; source .env; set +a
   fi
   ```
2. An environment section before the tasks. Each variable gets a default (empty if there's no sane one) and a `#` description. `help` reads these lines, so keep the `NAME="${NAME:-default}"  # description` shape:
   ```bash
   # --- environment ----------------------------------------------------

   DEPLOY_HOST="${DEPLOY_HOST:-}"                 # user@host for deploy and backup
   DEPLOY_PATH="${DEPLOY_PATH:-/var/www/mysite}"  # remote web root (default /var/www/mysite)
   ```
   Names are uppercase letters and underscores. Put the default in the description when there is one.
3. The environment block in `help`, after the commands list:
   ```bash
     echo
     echo "Environment (.env):"
     awk -F'=| *# *' '/^[A-Z_]+=.*#/ {printf "  %-12s %-42s %s\n", $1, $NF, ($1 in ENVIRON ? "set" : "")}' "$self"
   ```
   This marks a variable "set" when it comes from `.env` or the shell (both are exported, so `awk` sees them).

**Required variables:** use `${VAR:?message}` where the task uses it, so it stops with a clear message instead of running with an empty value:

```bash
ssh "${DEPLOY_HOST:?set DEPLOY_HOST in .env}" "..."
```

Don't use `:?` at the top of the file. That would break every task, `help` included, when the variable is missing.

If you add `.env` loading and the repo has no `.env` in `.gitignore`, tell the user (don't edit `.gitignore` unless asked).

### Local variables

Use `local` for variables inside tasks so they don't leak into other tasks:

```bash
backup() {  # tar the site on the server [name, default: today's date]
  local name="${1:-$(date +%F)}"
  ssh "${DEPLOY_HOST:?set DEPLOY_HOST in .env}" "tar czf ~/backup-$name.tgz $DEPLOY_PATH"
}
```

## Full example

A `gil.sh` using every pattern above:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Always run from the script's own directory
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
self="$here/$(basename "${BASH_SOURCE[0]}")"
cd "$here"

# Load .env if present (e.g. DEPLOY_HOST=user@myserver)
if [[ -f .env ]]; then
  set -a; source .env; set +a
fi

# --- environment ----------------------------------------------------

DEPLOY_HOST="${DEPLOY_HOST:-}"                 # user@host for deploy and backup
DEPLOY_PATH="${DEPLOY_PATH:-/var/www/mysite}"  # remote web root (default /var/www/mysite)

# --- tasks ----------------------------------------------------------

dev() {     # start dev server
  pnpm dev "$@"
}

build() {   # production build
  pnpm build "$@"
}

deploy() {  # build and rsync to server [extra rsync args, e.g. --dry-run]
  build
  rsync -avz --delete "$@" dist/ "${DEPLOY_HOST:?set DEPLOY_HOST in .env}:$DEPLOY_PATH/"
}

backup() {  # tar the site on the server [name, default: today's date]
  local name="${1:-$(date +%F)}"
  ssh "${DEPLOY_HOST:?set DEPLOY_HOST in .env}" "tar czf ~/backup-$name.tgz $DEPLOY_PATH"
}

help() {    # show available commands
  echo "Usage: ./gil.sh <command>"
  echo
  echo "Commands:"
  awk -F'[(]| *# *' '/^[a-z_]+\(\).*#/ {printf "  %-10s %s\n", $1, $NF}' "$self"
  echo
  echo "Environment (.env):"
  awk -F'=| *# *' '/^[A-Z_]+=.*#/ {printf "  %-12s %-42s %s\n", $1, $NF, ($1 in ENVIRON ? "set" : "")}' "$self"
}

# --- dispatcher -----------------------------------------------------

cmd="${1:-help}"
shift || true

if declare -F "$cmd" >/dev/null; then
  "$cmd" "$@"
else
  echo "Unknown command: $cmd" >&2
  echo >&2
  help >&2
  exit 1
fi
```
