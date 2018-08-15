#!/usr/bin/env zsh
set -e

#######
## WARNING: This file won't be used anymore, since I'm using Yarn now
#######

_npmInstallOrUpdate() {
  printf "\n${C_PURPLE}[NPM] ${C_GREEN}Checking for package \"$1\"...${C_RESTORE}\n"
  if npm list --depth 0 --global $1 > /dev/null 2>&1 ; then
    printf "${C_PURPLE}[NPM] ${C_BLUE}Package \"$1\" found! Updating...${C_RESTORE}\n"
    npm update --global $1
  else
    printf "${C_PURPLE}[NPM] ${C_BLUE}Package \"$1\" not found! Installing...${C_RESTORE}\n"
    npm install --global $1
  fi
}

for package in karma-cli nodemon csscomb; do
  _npmInstallOrUpdate $package
done

# I don't rememeber why eslint was outside the main loop... Have to investigate later :/
_npmInstallOrUpdate eslint
_npmInstallOrUpdate eslint_d

