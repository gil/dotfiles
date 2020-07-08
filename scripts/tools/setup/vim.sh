#!/usr/bin/env zsh

function _symlinkIfNeeded {
  printf "${C_BLUE}Checking if $1 is right...${C_RESTORE}\n"
  if [ $1 -ef $2 ]; then
    printf "${C_GREEN}It is!${C_RESTORE}\n"
  else
    if [ -f $1 ] || [ -d $1 ] || [ -L $1 ]; then
      backup_path=$1.backup-$(date +%Y%m%d-%H%M%S)
      printf "${C_YELLOW}Found an old $1.${C_RESTORE} ${C_GREEN}Backing up to $backup_path${C_RESTORE}\n"
      mv $1 $backup_path;
    fi
    printf "${C_BLUE}Creating $1 symlink...${C_RESTORE}\n"
    ln -s $2 $1
    printf "${C_GREEN}Done!${C_RESTORE}\n"
  fi
}

function _createDirectoryIfNeeded {
  printf "${C_BLUE}Checking if $1 dir exists...${C_RESTORE}\n"
  if [ -d $1 ]; then
    printf "${C_GREEN}It does!${C_RESTORE}\n"
  else
    printf "${C_BLUE}Creating $1 dir...${C_RESTORE}\n"
    mkdir -p $1
    printf "${C_GREEN}Done!${C_RESTORE}\n"
  fi
}

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