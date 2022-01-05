#!/usr/bin/env zsh

# _npmInstallOrUpdate() {
  #printf "\n${C_PURPLE}[NPM] ${C_GREEN}Checking for package \"$1\"...${C_RESTORE}\n"
  #if npm list --depth 0 --global $1 > /dev/null 2>&1 ; then
    #printf "${C_PURPLE}[NPM] ${C_BLUE}Package \"$1\" found! Updating...${C_RESTORE}\n"
    #npm update --global $1
  #else
    #printf "${C_PURPLE}[NPM] ${C_BLUE}Package \"$1\" not found! Installing...${C_RESTORE}\n"
    #npm install --global $1
  #fi
#}

#####
## Install/Update NVM
#####

printf "\n${C_PURPLE}[NVM] ${C_GREEN}Installing or updating NVM...${C_RESTORE}\n"

if ! command grep -qc '/nvm.sh' ~/.zshrc; then
    echo "# This line is here to prevent NVM from adding its code during installation and sourcing /nvm.sh and \$NVM_DIR/bash_completion automatically, since we'll lazy load it later. You can probably remove this if you want." >> ~/.zshrc
fi
if ! command grep -qc '/nvm.sh' ~/.bashrc; then
    echo "# This line is here to prevent NVM from adding its code during installation and sourcing /nvm.sh and \$NVM_DIR/bash_completion automatically, since we'll lazy load it later. You can probably remove this if you want." >> ~/.bashrc
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

#####
## Install latest NodeJS with NVM
#####

NODE_VERSION="node"

if which nvm 2>&1 >/dev/null; then

    printf "\n${C_PURPLE}[NVM] ${C_GREEN}Installing $NODE_VERSION...${C_RESTORE}\n"
    nvm install $NODE_VERSION
    nvm use $NODE_VERSION
    nvm alias default $NODE_VERSION

    printf "\n${C_PURPLE}[NVM] ${C_GREEN}Installing latest NPM for this version...${C_RESTORE}\n"
    nvm install-latest-npm

    printf "\n${C_PURPLE}[NVM] ${C_GREEN}Done! If NVM is not working, run refresh_dotfiles manually now.${C_RESTORE}\n"
else
    printf "\n${C_PURPLE}[NVM] ${C_RED}Couldn't find NVM!${C_RESTORE}\n"
fi

#####
## Install Yarn from latest NodeJS
#####

printf "\n${C_PURPLE}[Yarn] ${C_GREEN}Installing latest Yarn for this version...${C_RESTORE}\n"
npm install -g yarn

#####
## Install all global tools with Yarn
#####

if hash yarn 2>/dev/null; then
    printf "\n${C_PURPLE}[Yarn] ${C_GREEN}Installing/Updating modules...${C_RESTORE}\n"
    yarn global add \
      karma-cli \
      nodemon \
      csscomb \
      eslint \
      eslint_d \
      http-server \
      typescript \
      typescript-language-server \
      vls \
      neovim \
      slugify-cli \
      prettier
else
    printf "\n${C_PURPLE}[Yarn] ${C_RED}Couldn't find Yarn!${C_RESTORE}\n"
fi
