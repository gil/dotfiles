#!/usr/bin/env zsh
if ! which nvm 2>&1 >/dev/null; then
    printf "\n${C_PURPLE}[NVM] ${C_GREEN}Couldn't find NVM, let's try to install it...${C_RESTORE}\n"

    if ! command grep -qc '/nvm.sh' ~/.zshrc; then
        echo "# This line is here to prevent NVM from adding its code during installation and sourcing /nvm.sh and \$NVM_DIR/bash_completion automatically, since we'll lazy load it later. You can probably remove this if you want." >> ~/.zshrc
    fi
    if ! command grep -qc '/nvm.sh' ~/.bashrc; then
        echo "# This line is here to prevent NVM from adding its code during installation and sourcing /nvm.sh and \$NVM_DIR/bash_completion automatically, since we'll lazy load it later. You can probably remove this if you want." >> ~/.bashrc
    fi

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

if which nvm 2>&1 >/dev/null; then
    printf "\n${C_PURPLE}[NVM] ${C_GREEN}Installing latest node...${C_RESTORE}\n"
    nvm install node
    nvm use node

    printf "\n${C_PURPLE}[NVM] ${C_GREEN}Done! If NVM is not working, run refresh_dotfiles manually now.${C_RESTORE}\n"
else
    printf "\n${C_PURPLE}[NVM] ${C_RED}Couldn't find NVM!${C_RESTORE}\n"
fi
