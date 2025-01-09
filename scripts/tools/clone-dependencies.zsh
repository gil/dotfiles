#!/bin/zsh

source $OH_MY_GIL_SH/scripts/colors.zsh

function _cloneDependency {
  printf "${C_CYAN}\n[$2]\n${C_RESTORE}\n"
  rm -rf $OH_MY_GIL_SH/$2
  git clone --depth=1 $1 $OH_MY_GIL_SH/$2
}

printf "${C_BLUE}Cloning dependencies...${C_RESTORE}\n"

_cloneDependency https://github.com/zsh-users/zsh-autosuggestions scripts/plugins/zsh-autosuggestions
_cloneDependency https://github.com/zsh-users/zsh-syntax-highlighting.git scripts/plugins/zsh-syntax-highlighting
_cloneDependency https://github.com/romkatv/powerlevel10k.git scripts/themes/powerlevel10k
_cloneDependency https://github.com/gil/base16-themes.git scripts/themes/base16-themes
