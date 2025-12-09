#!/usr/bin/env zsh

#####
## Install latest NodeJS with FNM
#####

if which fnm 2>&1 >/dev/null; then

    printf "\n${C_PURPLE}[FNM] ${C_GREEN}Installing NodeJS LTS...${C_RESTORE}\n"
    fnm install --lts
    fnm default lts-latest

    printf "\n${C_PURPLE}[FNM] ${C_GREEN}Upgrading NPM...${C_RESTORE}\n"
    npm update -g npm
else
    printf "\n${C_PURPLE}[FNM] ${C_RED}Couldn't find FNM!${C_RESTORE}\n"
fi

#####
## Install Yarn from latest NodeJS
#####

printf "\n${C_PURPLE}[Yarn] ${C_GREEN}Installing latest Yarn...${C_RESTORE}\n"
npm install -g yarn

#####
## Install all global tools with Yarn
#####

if hash yarn 2>/dev/null; then
    printf "\n${C_PURPLE}[Yarn] ${C_GREEN}Installing/Updating modules...${C_RESTORE}\n"
    yarn global add \
      nodemon \
      eslint_d \
      http-server \
      typescript \
      neovim \
      slugify-cli \
      prettier
else
    printf "\n${C_PURPLE}[Yarn] ${C_RED}Couldn't find Yarn!${C_RESTORE}\n"
fi
