#!/usr/bin/env zsh

printf "${C_BLUE}Looking for an existing .vimrc...${C_RESTORE}\n"
if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
  printf "${C_YELLOW}Found ~/.vimrc.${C_RESTORE} ${C_GREEN}Backing up to ~/.vimrc.backup${C_RESTORE}\n"
  mv ~/.vimrc ~/.vimrc.backup;
fi

printf "${C_BLUE}Creating .vimrc symlink...${C_RESTORE}\n"
ln -s $OH_MY_GIL_SH/vim/.vimrc ~/.vimrc

if [ ! -d ~/.vim ]; then
  printf "${C_BLUE}Creating ~/.vim dir...${C_RESTORE}\n"
  mkdir ~/.vim/
fi

printf "${C_BLUE}Looking for an existing ~/.vim/ftplugin directory...${C_RESTORE}\n"
if [ -d ~/.vim/ftplugin ] || [ -h ~/.vim/ftplugin ]; then
  printf "${C_YELLOW}Found ~/.vim/ftplugin.${C_RESTORE} ${C_GREEN}Backing up to ~/.vim/ftplugin.backup${C_RESTORE}\n"
  mv ~/.vim/ftplugin ~/.vim/ftplugin.backup;
fi

printf "${C_BLUE}Creating ~/.vim/ftplugin symlink...${C_RESTORE}\n"
ln -s $OH_MY_GIL_SH/vim/ftplugin/ ~/.vim/ftplugin

printf "${C_BLUE}Looking for an existing ~/.vim/UltiSnips directory...${C_RESTORE}\n"
if [ -d ~/.vim/UltiSnips ] || [ -h ~/.vim/UltiSnips ]; then
  printf "${C_YELLOW}Found ~/.vim/UltiSnips.${C_RESTORE} ${C_GREEN}Backing up to ~/.vim/UltiSnips.backup${C_RESTORE}\n"
  mv ~/.vim/UltiSnips ~/.vim/UltiSnips.backup;
fi

printf "${C_BLUE}Creating ~/.vim/UltiSnips symlink...${C_RESTORE}\n"
ln -s $OH_MY_GIL_SH/vim/UltiSnips/ ~/.vim/UltiSnips

printf "${C_BLUE}Looking for an existing ~/.vim/spell directory...${C_RESTORE}\n"
if [ -d ~/.vim/spell ] || [ -h ~/.vim/spell ]; then
  printf "${C_YELLOW}Found ~/.vim/spell.${C_RESTORE} ${C_GREEN}Backing up to ~/.vim/spell.backup${C_RESTORE}\n"
  mv ~/.vim/spell ~/.vim/spell.backup;
fi

printf "${C_BLUE}Creating ~/.vim/spell symlink...${C_RESTORE}\n"
ln -s $OH_MY_GIL_SH/vim/spell/ ~/.vim/spell

#if [ -d ~/.vim/bundle/Vundle.vim ]; then
    #printf "${C_BLUE}Updating Vundle...${C_RESTORE}\n"
    #cd ~/.vim/bundle/Vundle.vim
    #git pull origin master
    #cd -
#else
    #printf "${C_BLUE}Cloning Vundle...${C_RESTORE}\n"
    #git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#fi

#printf "${C_BLUE}Looking for an existing .ctags...${C_RESTORE}\n"
#if [ -f ~/.ctags ] || [ -h ~/.ctags ]; then
  #printf "${C_YELLOW}Found ~/.ctags.${C_RESTORE} ${C_GREEN}Backing up to ~/.ctags.backup${C_RESTORE}\n"
  #mv ~/.ctags ~/.ctags.backup;
#fi

#printf "${C_BLUE}Creating .ctags symlink...${C_RESTORE}\n"
#ln -s $OH_MY_GIL_SH/vim/.ctags ~/.ctags

if [ ! -f ~/.config/nvim/init.vim ]; then
  printf "${C_BLUE}Linking nvim config...${C_RESTORE}\n"
  mkdir -p ~/.config/nvim
  ln -s $OH_MY_GIL_SH/vim/init.vim ~/.config/nvim/init.vim
fi

printf "${C_BLUE}Installing plugins...${C_RESTORE}\n"
vim +PlugInstall +qall

printf "${C_BLUE}Looking for an existing .tmux.conf...${C_RESTORE}\n"
if [ -f ~/.tmux.conf ] || [ -h ~/.tmux.conf ]; then
  printf "${C_YELLOW}Found ~/.tmux.conf.${C_RESTORE} ${C_GREEN}Backing up to ~/.tmux.conf.backup${C_RESTORE}\n"
  mv ~/.tmux.conf ~/.tmux.conf.backup;
fi

printf "${C_BLUE}Creating .tmux.conf symlink...${C_RESTORE}\n"
ln -s $OH_MY_GIL_SH/vim/.tmux.conf ~/.tmux.conf

if [ -d ~/.tmux/plugins/tpm ]; then
    printf "${C_BLUE}Updating Tmux Plugin Manager...${C_RESTORE}\n"
    cd ~/.tmux/plugins/tpm
    git pull origin master
    cd -
else
    printf "${C_BLUE}Cloning Tmux Plugin Manager...${C_RESTORE}\n"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -d ~/.config ]; then
  printf "${C_YELLOW}Creating ~/.config directory.${C_RESTORE}\n"
  mkdir ~/.config
fi

#printf "${C_BLUE}Installing Tmuxinator...${C_RESTORE}\n"
#gem install tmuxinator