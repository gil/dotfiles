if ! env | grep -q ^OH_MY_GIL_SH=; then
  export OH_MY_GIL_SH=$HOME/.dotfiles
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR="vim"

# Path to your oh-my-zsh installation.
export ZSH=$OH_MY_GIL_SH/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="miloshadzic"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$OH_MY_GIL_SH/scripts

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git rbenv pyenv rails gem node npm bower gradle grunt brew z docker docker-compose docker-machine osx terminalapp sublimetext extract tmux fzf)

# User configuration
export POWERLINE_SCRIPTS_PATH="$HOME/.vim/bundle/powerline/scripts"
export POWERLINE_CONFIG_COMMAND="$POWERLINE_SCRIPTS_PATH/powerline-config"
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$POWERLINE_SCRIPTS_PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
source $OH_MY_GIL_SH/scripts/utils.zsh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [[ $OSTYPE == darwin* ]]; then
  ulimit -n 10240
fi

alias setup_dotfiles="sh $OH_MY_GIL_SH/scripts/tools/setup/menu.sh"
alias upgrade_dotfiles="sh $OH_MY_GIL_SH/scripts/tools/upgrade-dotfiles.sh && source ~/.zshrc"
alias refresh_dotfiles="source ~/.zshrc"

alias dev_chrome="open -n -a \"Google Chrome\" --args --profile-directory=\"Debug Profile\""
alias simple_server="python -m SimpleHTTPServer 8080"

alias vi="vim"
alias v="vim"
alias work="vim -o \`git status -s --porcelain -uall | cut -c4- | sed \"s,\${\$(git rev-parse --show-prefix):-ºº},,\" | tr '\n' ' '\`"

### Experimental Clipboard Sharing Code ###
function clcopy {
  if hash pbcopy 2>/dev/null; then
    tee /tmp/__ssh_clipboard__ | pbcopy
  else
    tee /tmp/__ssh_clipboard__
  fi
}
function clpaste {
  cat /tmp/__ssh_clipboard__
}
function clsend {
  scp /tmp/__ssh_clipboard__ $1:/tmp/
}
function clget {
  scp $1:/tmp/__ssh_clipboard__ /tmp/
  if hash pbcopy 2>/dev/null; then
    cat /tmp/__ssh_clipboard__ | pbcopy
  fi
}
### Experimental Clipboard Sharing Code ###

if [ -f $OH_MY_GIL_SH/custom/.zshrc ]; then
  source $OH_MY_GIL_SH/custom/.zshrc
fi

