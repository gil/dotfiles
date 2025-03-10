#!/usr/bin/env zsh

source $OH_MY_GIL_SH/scripts/utils.zsh

if [ -d ~/.tmux/plugins/tpm ]; then
    printf "${C_BLUE}Updating Tmux Plugin Manager...${C_RESTORE}\n"
    cd ~/.tmux/plugins/tpm
    git pull --rebase origin master
    cd -
else
    printf "${C_BLUE}Cloning Tmux Plugin Manager...${C_RESTORE}\n"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

printf "${C_BLUE}Installing new Tmux Plugins...${C_RESTORE}\n"
~/.tmux/plugins/tpm/bin/install_plugins
printf "${C_BLUE}Cleaning unused Tmux Plugins...${C_RESTORE}\n"
~/.tmux/plugins/tpm/bin/clean_plugins
printf "${C_BLUE}Updating Tmux Plugins...${C_RESTORE}\n"
~/.tmux/plugins/tpm/bin/update_plugins all
