#!/usr/bin/env zsh
set -e

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

for package in grunt-cli gulp-cli bower karma-cli nodemon
do
  _npmInstallOrUpdate $package
done

_npmInstallOrUpdate eslint 
