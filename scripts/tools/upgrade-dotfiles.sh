#!/usr/bin/env zsh
#set -e

cd ~/.dotfiles
printf '\033[0;34m%s\033[0m\n' "Upgrading dotfiles"
git pull origin master
sh ./oh-my-zsh/tools/upgrade.sh
cd - >/dev/null 2>&1
echo "\n${C_BLUE}Done!${C_RESTORE}"

env zsh
. ~/.zshrc