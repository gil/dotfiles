#!/usr/bin/env zsh

source $OH_MY_GIL_SH/scripts/utils.zsh

### Vim/Neovim ###

_symlinkIfNeeded ~/.vimrc $OH_MY_GIL_SH/vim/.vimrc
_createDirectoryIfNeeded ~/.vim/
_symlinkIfNeeded ~/.vim/ftplugin $OH_MY_GIL_SH/vim/ftplugin/
_symlinkIfNeeded ~/.vim/UltiSnips $OH_MY_GIL_SH/vim/UltiSnips/
_symlinkIfNeeded ~/.vim/spell $OH_MY_GIL_SH/vim/spell/
_createDirectoryIfNeeded ~/.config/nvim
_symlinkIfNeeded ~/.config/nvim/init.vim $OH_MY_GIL_SH/vim/init.vim

printf "${C_BLUE}Installing Vim plugins...${C_RESTORE}\n"
vim +PlugInstall +qall

### TMUX ###

_symlinkIfNeeded ~/.tmux.conf $OH_MY_GIL_SH/vim/.tmux.conf

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