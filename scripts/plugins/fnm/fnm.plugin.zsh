if (( ! $+commands[fnm] )); then
  return
fi

eval "$(fnm env --use-on-cd --resolve-engines --version-file-strategy=recursive)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `fnm`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fnm" ]]; then
  typeset -g -A _comps
  autoload -Uz _fnm
  _comps[fnm]=_fnm
fi

fnm completions --shell=zsh >| "$ZSH_CACHE_DIR/completions/_fnm" &|
