#!/usr/bin/env zsh
#set -e

cd $OH_MY_GIL_SH
printf '\033[0;34m%s\033[0m\n' "Upgrading dotfiles"
#git pull origin master
git -c rebase.autoStash=true pull --rebase
sh ./oh-my-zsh/tools/upgrade.sh
cd - >/dev/null 2>&1
echo -e "\n${C_BLUE}Done!${C_RESTORE}"