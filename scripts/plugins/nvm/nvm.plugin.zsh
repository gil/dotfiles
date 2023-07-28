# remove duplicates defined below, otherwise it'll break
NODE_GLOBALS_IGNORE="pnpm|npm|npx|yarn"

# find global node bin installed in multiple places
NODE_GLOBALS="$(
  (
    echo vim nvim ;
    find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' 2>/dev/null ;
    find ~/.yarn/bin -maxdepth 1 -type l -wholename '*' 2>/dev/null ;
    find /usr/local/bin -lname '*yarn*' 2>/dev/null ;
  ) | xargs -n1 basename | sort | uniq | grep -v -i -w -E "$NODE_GLOBALS_IGNORE" | xargs echo -n
)"

zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' lazy-cmd $NODE_GLOBALS

########################
## Original script goes below
##
## Just remember to include this inside of lazy loading thingy:
##   export PATH="$PATH:$(yarn global bin)"
########################

# See https://github.com/nvm-sh/nvm#installation-and-update
if [[ -z "$NVM_DIR" ]]; then
  if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
  elif [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvm" ]]; then
    export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
  elif (( $+commands[brew] )); then
    NVM_HOMEBREW="${NVM_HOMEBREW:-${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/nvm}"
    if [[ -d "$NVM_HOMEBREW" ]]; then
      export NVM_DIR="$NVM_HOMEBREW"
    fi
  fi
fi

# Don't try to load nvm if command already available
# Note: nvm is a function so we need to use `which`
which nvm &>/dev/null && return

if [[ -z "$NVM_DIR" ]] || [[ ! -f "$NVM_DIR/nvm.sh" ]]; then 
  return
fi

if zstyle -t ':omz:plugins:nvm' lazy && \
  ! zstyle -t ':omz:plugins:nvm' autoload; then
  # Call nvm when first using nvm, node, npm, pnpm, yarn or other commands in lazy-cmd
  zstyle -a ':omz:plugins:nvm' lazy-cmd nvm_lazy_cmd
  eval "
    function nvm node npm npx pnpm yarn $nvm_lazy_cmd {
      unfunction nvm node npm npx pnpm yarn $nvm_lazy_cmd
      # Load nvm if it exists in \$NVM_DIR
      [[ -f \"\$NVM_DIR/nvm.sh\" ]] && source \"\$NVM_DIR/nvm.sh\"
      export PATH=\"\$PATH:\$(yarn global bin)\"
      \"\$0\" \"\$@\"
    }
  "
  unset nvm_lazy_cmd
else
  source "$NVM_DIR/nvm.sh"
fi

# Load nvm bash completion
for nvm_completion in "$NVM_DIR/bash_completion" "$NVM_HOMEBREW/etc/bash_completion.d/nvm"; do
  if [[ -f "$nvm_completion" ]]; then
    # Load bashcompinit
    autoload -U +X bashcompinit && bashcompinit
    # Bypass compinit call in nvm bash completion script. See:
    # https://github.com/nvm-sh/nvm/blob/4436638/bash_completion#L86-L93
    ZSH_VERSION= source "$nvm_completion"
    break
  fi
done

unset NVM_HOMEBREW nvm_completion
