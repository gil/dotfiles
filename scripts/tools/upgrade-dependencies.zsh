#!/bin/zsh

source $OH_MY_GIL_SH/scripts/colors.zsh

function _pullDependency {
  printf "${C_CYAN}\n[$1]\n${C_RESTORE}\n"
  cd $OH_MY_GIL_SH/$1
  git pull --rebase
  cd -
}

printf "${C_BLUE}Pulling dependency upgrades...${C_RESTORE}\n"

file="$OH_MY_GIL_SH/scripts/tools/dependencies"
while read -r repo dir; do
  _pullDependency "$dir"
done < "$file"
