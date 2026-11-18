#!/usr/bin/env bash
set -euo pipefail

# Always run from the script's own directory
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
self="$here/$(basename "${BASH_SOURCE[0]}")"
cd "$here"

# --- tasks ----------------------------------------------------------

build() {   # production build
  pnpm build "$@"
}

dev() {     # dev build and run
  pnpm dev "$@"
}

watch() {   # dev build, rebuild on file changes
  pnpm dev --watch "$@"
}

test() {    # run tests
  pnpm test "$@"
}

help() {    # show available commands
  echo "Usage: ./gil.sh <command>"
  echo
  echo "Commands:"
  awk -F'[(]| *# *' '/^[a-z_]+\(\).*#/ {printf "  %-10s %s\n", $1, $NF}' "$self"
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
