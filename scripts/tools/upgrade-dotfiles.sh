#!/usr/bin/env zsh
#set -e

cd $OH_MY_GIL_SH
printf '\033[0;34m%s\033[0m\n' "Upgrading dotfiles..."
git -c rebase.autoStash=true pull --rebase

printf '\033[0;34m%s\033[0m\n' "Upgrading submodules..."
git submodule update --init --remote --recursive --rebase

printf '\033[0;34m%s\033[0m\n' "Running oh-my-zsh upgrade script..."
sh ./oh-my-zsh/tools/upgrade.sh
cd - >/dev/null 2>&1

printf '\033[0;34m%s\033[0m\n' "Generate bar theme cache..."
if hash bat 2>/dev/null; then
  bat cache --build
fi

printf "\n${C_BLUE}Done!${C_RESTORE}\n"