#!/usr/bin/env zsh

echo -e "${C_BLUE}Looking for an existing .vimrc...${C_RESTORE}"
if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
  echo -e "${C_YELLOW}Found ~/.vimrc.${C_RESTORE} ${C_GREEN}Backing up to ~/.vimrc.backup${C_RESTORE}";
  mv ~/.vimrc ~/.vimrc.backup;
fi

echo -e "${C_BLUE}Creating .vimrc symlink...${C_RESTORE}"
ln -s $OH_MY_GIL_SH/vim/.vimrc ~/.vimrc

echo -e "${C_BLUE}Looking for an existing ~/.vim/ftplugin directory...${C_RESTORE}"
if [ -d ~/.vim/ftplugin ] || [ -h ~/.vim/ftplugin ]; then
  echo -e "${C_YELLOW}Found ~/.vim/ftplugin.${C_RESTORE} ${C_GREEN}Backing up to ~/.vim/ftplugin.backup${C_RESTORE}";
  mv ~/.vim/ftplugin ~/.vim/ftplugin.backup;
fi

echo -e "${C_BLUE}Creating ~/.vim/ftplugin symlink...${C_RESTORE}"
ln -s $OH_MY_GIL_SH/vim/ftplugin/ ~/.vim/ftplugin

echo -e "${C_BLUE}Looking for an existing ~/.vim/UltiSnips directory...${C_RESTORE}"
if [ -d ~/.vim/UltiSnips ] || [ -h ~/.vim/UltiSnips ]; then
  echo -e "${C_YELLOW}Found ~/.vim/UltiSnips.${C_RESTORE} ${C_GREEN}Backing up to ~/.vim/UltiSnips.backup${C_RESTORE}";
  mv ~/.vim/UltiSnips ~/.vim/UltiSnips.backup;
fi

echo -e "${C_BLUE}Creating ~/.vim/UltiSnips symlink...${C_RESTORE}"
ln -s $OH_MY_GIL_SH/vim/UltiSnips/ ~/.vim/UltiSnips

echo -e "${C_BLUE}Looking for an existing ~/.vim/spell directory...${C_RESTORE}"
if [ -d ~/.vim/spell ] || [ -h ~/.vim/spell ]; then
  echo -e "${C_YELLOW}Found ~/.vim/spell.${C_RESTORE} ${C_GREEN}Backing up to ~/.vim/spell.backup${C_RESTORE}";
  mv ~/.vim/spell ~/.vim/spell.backup;
fi

echo -e "${C_BLUE}Creating ~/.vim/spell symlink...${C_RESTORE}"
ln -s $OH_MY_GIL_SH/vim/spell/ ~/.vim/spell

if [ -d ~/.vim/bundle/Vundle.vim ]; then
	echo -e "${C_BLUE}Updating Vundle...${C_RESTORE}"
	cd ~/.vim/bundle/Vundle.vim
	git pull origin master
	cd -
else
	echo -e "${C_BLUE}Cloning Vundle...${C_RESTORE}"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo -e "${C_BLUE}Looking for an existing .ctags...${C_RESTORE}"
if [ -f ~/.ctags ] || [ -h ~/.ctags ]; then
  echo -e "${C_YELLOW}Found ~/.ctags.${C_RESTORE} ${C_GREEN}Backing up to ~/.ctags.backup${C_RESTORE}";
  mv ~/.ctags ~/.ctags.backup;
fi

echo -e "${C_BLUE}Creating .ctags symlink...${C_RESTORE}"
ln -s $OH_MY_GIL_SH/vim/.ctags ~/.ctags

echo -e "${C_BLUE}Installing Powerline requirements...${C_RESTORE}"
#pip3 install powerline-status #--user
pip install psutil
pip install netifaces

echo -e "${C_BLUE}Installing plugins...${C_RESTORE}"
vim +PluginInstall +qall

echo -e "${C_BLUE}Looking for an existing .tmux.conf...${C_RESTORE}"
if [ -f ~/.tmux.conf ] || [ -h ~/.tmux.conf ]; then
  echo -e "${C_YELLOW}Found ~/.tmux.conf.${C_RESTORE} ${C_GREEN}Backing up to ~/.tmux.conf.backup${C_RESTORE}";
  mv ~/.tmux.conf ~/.tmux.conf.backup;
fi

echo -e "${C_BLUE}Creating .tmux.conf symlink...${C_RESTORE}"
ln -s $OH_MY_GIL_SH/vim/.tmux.conf ~/.tmux.conf

if [ ! -d ~/.config ]; then
  echo -e "${C_YELLOW}Creating ~/.config directory.${C_RESTORE}";
  mkdir ~/.config
fi

echo -e "${C_BLUE}Looking for an existing ~/.config/powerline directory...${C_RESTORE}"
if [ -d ~/.config/powerline ] || [ -h ~/.config/powerline ]; then
  echo -e "${C_YELLOW}Found ~/.config/powerline.${C_RESTORE} ${C_GREEN}Backing up to ~/.config/powerline.backup${C_RESTORE}";
  mv ~/.config/powerline ~/.config/powerline.backup;
fi

echo -e "${C_BLUE}Creating ~/.config/powerline symlink...${C_RESTORE}"
ln -s $OH_MY_GIL_SH/vim/config/powerline/ ~/.config/powerline

echo -e "${C_BLUE}Installing Tmuxinator...${C_RESTORE}"
gem install tmuxinator