#!/usr/bin/env bash
# Read-only scan. Never executes anything from the target.
set -euo pipefail

target="${1:?usage: scan.sh <repo-path>}"
target="$(realpath "$target")"
cd /

max_hits="${MAX_HITS:-40}"

if ! command -v rg >/dev/null; then
  echo "rg not found. Install with: brew install ripgrep" >&2
  exit 1
fi

section() {
  printf '\n===== %s =====\n' "$1"
}

search() {
  local output
  output="$(rg --hidden --no-ignore --no-config -n -i --max-columns 200 --max-columns-preview \
    -g '!.git/' -g '!node_modules/' -g '!*.lock' -g '!*-lock.*' -g '!*.min.js' -g '!*.map' \
    "$@" "$target" 2>/dev/null | head -n "$max_hits" || true)"
  if [[ -n "$output" ]]; then
    printf '%s\n' "${output//$target\//}"
  else
    echo "(none)"
  fi
}

list_files() {
  local output
  output="$(find "$target" -path "$target/.git" -prune -o -path '*/node_modules' -prune -o "$@" -print 2>/dev/null | head -n "$max_hits" || true)"
  if [[ -n "$output" ]]; then
    printf '%s\n' "${output//$target\//}"
  else
    echo "(none)"
  fi
}

section "Overview"
echo "target: $target"
find "$target" -path "$target/.git" -prune -o -type f -print | wc -l | xargs echo "files:"
du -sh "$target" | cut -f1 | xargs echo "size:"

section "Auto-run: install and build"
list_files -type f \( -name setup.py -o -name pyproject.toml -o -name setup.cfg -o -name '*.pth' \
  -o -name sitecustomize.py -o -name usercustomize.py -o -name build.rs -o -name binding.gyp \
  -o -name Makefile -o -name GNUmakefile -o -name CMakeLists.txt -o -name configure -o -name meson.build \
  -o -name '*.gemspec' -o -name Gemfile -o -name Rakefile -o -name .pnpmfile.cjs -o -name .npmrc \
  -o -name .yarnrc.yml -o -name bunfig.toml -o -name justfile -o -name Taskfile.yml -o -name noxfile.py \
  -o -name tox.ini -o -name tasks.py -o -name 'install*.sh' -o -name 'setup*.sh' -o -name 'bootstrap*.sh' \
  -o -name gradlew -o -name 'build.gradle*' -o -name Dockerfile -o -name 'compose*.y*ml' -o -name 'docker-compose*.y*ml' \)

section "Auto-run: package.json lifecycle scripts"
search -g 'package.json' '"(preinstall|install|postinstall|prepare|prepack|prepublish)"\s*:'

section "Auto-run: Go generate"
search -g '*.go' '^//go:generate'

section "Auto-run: on open or cd (direnv, mise, editors, devcontainer)"
list_files \( -name .envrc -o -name .mise.toml -o -name mise.toml -o -name .tool-versions -o -name .rtx.toml \
  -o -path '*/.vscode/*' -o -path '*/.devcontainer/*' -o -path '*/.idea/*.xml' \) -type f

section "Auto-run: test, commit, CI"
list_files -type f \( -name conftest.py -o -name 'jest.config.*' -o -name 'vitest.config.*' -o -name .pre-commit-config.yaml \
  -o -name lefthook.yml -o -path '*/.husky/*' -o -path '*/.github/workflows/*' \)

section "AI agent files"
list_files \( -name 'CLAUDE*.md' -o -name 'AGENTS.md' -o -name 'GEMINI.md' -o -name .cursorrules -o -name .windsurfrules \
  -o -name .clinerules -o -name .mcp.json -o -name copilot-instructions.md -o -path '*/.claude/*' -o -path '*/.cursor/*' \
  -o -path '*/.roo/*' -o -path '*/.continue/*' -o -name '.aider*' \) -type f

section "AI agent files: suspicious content"
search -g 'CLAUDE*.md' -g 'AGENTS.md' -g 'GEMINI.md' -g '.cursorrules' -g '.windsurfrules' -g '.clinerules' -g '**/.claude/**' \
  -g '**/.cursor/**' -g '.mcp.json' -g 'copilot-instructions.md' -g 'README*' \
  'ignore (all |any )?(previous|prior|above)|do not (tell|mention|inform)|hooks|"command"|npx |uvx |curl |wget |base64|ANTHROPIC_|BASE_URL|permissions|bypass|dangerously|<!--'

section "Git: submodules, LFS, attributes"
list_files -maxdepth 1 -type f \( -name .gitmodules -o -name .lfsconfig -o -name .gitattributes \)
search -g '.gitmodules' -g '.lfsconfig' -g '.gitattributes' 'url|filter=|diff=|merge=|ext::|file://'

section "Git: local config and hooks (local repos only)"
if [[ -f "$target/.git/config" ]]; then
  rg -n -i 'fsmonitor|pager|sshcommand|editor|external|filter|hookspath|include|^\s*\w+\s*=\s*!' "$target/.git/config" || echo "(none)"
  find "$target/.git/hooks" -type f ! -name '*.sample' 2>/dev/null || true
else
  echo "(no .git/config)"
fi

section "Dependency sources: git URLs, custom registries, direct URLs"
search -g 'package.json' -g '.npmrc' -g '.yarnrc*' -g 'requirements*.txt' -g 'pyproject.toml' -g 'setup.py' -g 'setup.cfg' \
  -g 'Cargo.toml' -g 'go.mod' -g 'Gemfile' -g 'pnpm-workspace.yaml' \
  'git\+|github:|gitlab:|bitbucket:|https?://[^ "]+\.(tgz|tar\.gz|zip|whl)|registry\s*=|index-url|find-links|^\s*replace\s|\bgit\s*='

section "Download and execute"
search 'curl[^|\n]*\|\s*(ba|z)?sh|wget[^|\n]*\|\s*(ba|z)?sh|iex\s*\(|invoke-expression|downloadstring|\beval\s*\(\s*(await\s+)?(fetch|require\(.https?)|import\(\s*["'\'']https?://'

section "Dynamic code execution"
search -g '!*.md' '\beval\s*\(|new Function\s*\(|\bvm\.(run|Script|compile)|\bexec\s*\(|\bcompile\s*\(|__import__\s*\(|importlib\.import_module|marshal\.loads|pickle\.loads'

section "Subprocess and shell"
search -g '!*.md' 'child_process|\bexecSync\b|\bspawn(Sync)?\s*\(|subprocess\.|os\.system|os\.popen|Command::new|exec\.Command|Runtime\.getRuntime|shell\s*=\s*True|osascript|/bin/(ba|z)?sh\b'

section "Native code and FFI"
search -g '!*.md' '\bdlopen\b|process\.dlopen|\bctypes\b|\bcffi\b|\bffi-napi\b|koffi|require\([^)]*\.node["'\'']\)|#cgo|LoadLibrary|libloading'

section "Network: webhooks, paste sites, tunnels, raw IPs"
search -g '!*.md' 'discord(app)?\.com/api/webhooks|api\.telegram\.org|hooks\.slack\.com|pastebin\.com|paste\.ee|hastebin|transfer\.sh|ngrok|trycloudflare|webhook\.site|requestbin|pipedream|interact\.sh|burpcollaborator|\b(\d{1,3}\.){3}\d{1,3}:\d{2,5}\b'

section "Network: all outbound URLs (unique hosts)"
rg --hidden --no-ignore --no-config -o -I -N -g '!.git/' -g '!node_modules/' -g '!*.md' -g '!*.lock' -g '!*-lock.*' \
  -r '$1' 'https?://([a-zA-Z0-9.-]+)' "$target" 2>/dev/null | sort | uniq -c | sort -rn | head -n "$max_hits" || true

section "Secrets and sensitive paths"
search -g '!*.md' '\.ssh/|id_rsa|id_ed25519|\.aws/|\.gnupg|\.kube/config|\.docker/config|\.npmrc|\.pypirc|\.netrc|\.git-credentials|gh/hosts\.yml|Library/Keychains|security (find|dump)-|keychain|Login Data|Cookies|Local State|Application Support/(Google|BraveSoftware|Firefox|Microsoft Edge)|wallet|metamask|exodus|electrum|\.env\b'

section "Environment harvesting"
search -g '!*.md' 'JSON\.stringify\(\s*process\.env|Object\.(keys|entries)\(\s*process\.env|\{\s*\.\.\.process\.env|dict\(\s*os\.environ|os\.environ\.items|os\.environ\.copy|env::vars\(\)|os\.Environ\(\)|\bprintenv\b|\benv\s*>'

section "Persistence"
search -g '!*.md' 'LaunchAgents|LaunchDaemons|launchctl|crontab|\.zshrc|\.zprofile|\.bashrc|\.bash_profile|\.profile\b|login ?items|LSSharedFileList|SMAppService|systemctl|/etc/rc|\.config/autostart'

section "macOS permission and Gatekeeper tampering"
search 'com\.apple\.quarantine|xattr\s+-[a-z]*d|spctl\s+--master-disable|tccutil|TCC\.db|csrutil|sudo\s'

section "Obfuscation: encoding helpers"
search -g '!*.md' 'atob\s*\(|Buffer\.from\([^)]*["'\'']base64|b64decode|base64\s+-d|fromCharCode|\\x[0-9a-f]{2}(\\x[0-9a-f]{2}){7,}|\\u00[0-9a-f]{2}(\\u00[0-9a-f]{2}){7,}|String\.raw|rot13|codecs\.decode'

section "Obfuscation: long base64 or hex blobs"
search -o -g '!*.md' -g '!*.svg' -g '!*.json' '[A-Za-z0-9+/]{300,}={0,2}|[0-9a-f]{300,}'

section "Hidden Unicode (zero-width, bidi controls)"
search '[\x{200B}-\x{200F}\x{202A}-\x{202E}\x{2060}-\x{2064}\x{2066}-\x{2069}\x{FEFF}\x{E0000}-\x{E007F}]'

section "Very long lines in source files (code hidden past the edge)"
list_output="$(rg --hidden --no-ignore --no-config -l -g '!.git/' -g '!node_modules/' -g '!dist/' -g '!build/' -g '!*.min.*' -g '!*.map' \
  -g '!*.json' -g '!*.svg' -g '!*.lock' -g '!*-lock.*' -g '!*.md' '.{1000,}' "$target" 2>/dev/null | head -n "$max_hits" || true)"
if [[ -n "$list_output" ]]; then printf '%s\n' "${list_output//$target\//}"; else echo "(none)"; fi

section "Compiled binaries and archives"
binaries="$(find "$target" -path "$target/.git" -prune -o -path '*/node_modules' -prune -o -type f -size +1k -print0 2>/dev/null \
  | xargs -0 file -N 2>/dev/null \
  | rg -i 'Mach-O|ELF|PE32|executable|shared (object|library)|WebAssembly|Java archive|Zip archive|gzip|tar archive|7-zip|RAR' \
  | rg -v -i 'script text|text executable|\(for architecture' | head -n "$max_hits" || true)"
if [[ -n "$binaries" ]]; then printf '%s\n' "${binaries//$target\//}"; else echo "(none)"; fi

section "Done"
echo "Hits are leads, not verdicts. Read each one in context. Sections cap at $max_hits lines (set MAX_HITS to change)."
