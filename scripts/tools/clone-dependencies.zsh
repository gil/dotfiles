#!/bin/zsh

source $OH_MY_GIL_SH/scripts/colors.zsh

function _cloneDependency {
  printf "${C_CYAN}\n[$2]\n${C_RESTORE}\n"
  rm -rf $OH_MY_GIL_SH/$2
  git clone --depth=1 $1 $OH_MY_GIL_SH/$2
}

printf "${C_BLUE}Cloning dependencies...${C_RESTORE}\n"

file="$OH_MY_GIL_SH/scripts/tools/dependencies"
while read -r repo dir; do
  _cloneDependency "$repo" "$dir"
done < "$file"
