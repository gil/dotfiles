# alias brews='brew list -1'
# alias bubo='brew update && brew outdated'
# alias bubc='brew upgrade && brew cleanup'
# alias bubu='bubo && bubc'

export HOMEBREW_NO_INSTALL_UPGRADE=1
export HOMEBREW_NO_AUTO_UPDATE=1

# Trying to avoid breaking the formulas below, after an update
export HOMEBREW_NO_CLEANUP_FORMULAE=tmux,vim,neovim
