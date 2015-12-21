#!/usr/bin/env zsh

echo "${C_BLUE}Looking for an existing .vimrc...${C_RESTORE}"
if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
  echo "${C_YELLOW}Found ~/.vimrc.${C_RESTORE} ${C_GREEN}Backing up to ~/.vimrc.backup${C_RESTORE}";
  mv ~/.vimrc ~/.vimrc.backup;
fi

echo "${C_BLUE}Creating .vimrc symlink...${C_RESTORE}"
ln -s ~/.dotfiles/vim/.vimrc ~/.vimrc

echo "${C_BLUE}Looking for an existing ~/.vim/ftplugin directory...${C_RESTORE}"
if [ -d ~/.vim/ftplugin ] || [ -h ~/.vim/ftplugin ]; then
  echo "${C_YELLOW}Found ~/.vim/ftplugin.${C_RESTORE} ${C_GREEN}Backing up to ~/.vim/ftplugin.backup${C_RESTORE}";
  mv ~/.vim/ftplugin ~/.vim/ftplugin.backup;
fi

echo "${C_BLUE}Creating ~/.vim/ftplugin symlink...${C_RESTORE}"
ln -s ~/.dotfiles/vim/ftplugin/ ~/.vim/ftplugin

echo "${C_BLUE}Looking for an existing ~/.vim/UltiSnips directory...${C_RESTORE}"
if [ -d ~/.vim/UltiSnips ] || [ -h ~/.vim/UltiSnips ]; then
  echo "${C_YELLOW}Found ~/.vim/UltiSnips.${C_RESTORE} ${C_GREEN}Backing up to ~/.vim/UltiSnips.backup${C_RESTORE}";
  mv ~/.vim/UltiSnips ~/.vim/UltiSnips.backup;
fi

echo "${C_BLUE}Creating ~/.vim/UltiSnips symlink...${C_RESTORE}"
ln -s ~/.dotfiles/vim/UltiSnips/ ~/.vim/UltiSnips

if [ -d ~/.vim/bundle/Vundle.vim ]; then
	echo "${C_BLUE}Updating Vundle...${C_RESTORE}"
	cd ~/.vim/bundle/Vundle.vim
	git pull origin master
	cd -
else
	echo "${C_BLUE}Cloning Vundle...${C_RESTORE}"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo "${C_BLUE}Looking for an existing .ctags...${C_RESTORE}"
if [ -f ~/.ctags ] || [ -h ~/.ctags ]; then
  echo "${C_YELLOW}Found ~/.ctags.${C_RESTORE} ${C_GREEN}Backing up to ~/.ctags.backup${C_RESTORE}";
  mv ~/.ctags ~/.ctags.backup;
fi

echo "${C_BLUE}Creating .ctags symlink...${C_RESTORE}"
ln -s ~/.dotfiles/vim/.ctags ~/.ctags

echo "${C_BLUE}Installing Powerline requirements...${C_RESTORE}"
#pip3 install powerline-status #--user
pip install psutil
pip install netifaces

echo "${C_BLUE}Installing plugins...${C_RESTORE}"
vim +PluginInstall +qall

echo "${C_BLUE}Looking for an existing .tmux.conf...${C_RESTORE}"
if [ -f ~/.tmux.conf ] || [ -h ~/.tmux.conf ]; then
  echo "${C_YELLOW}Found ~/.tmux.conf.${C_RESTORE} ${C_GREEN}Backing up to ~/.tmux.conf.backup${C_RESTORE}";
  mv ~/.tmux.conf ~/.tmux.conf.backup;
fi

echo "${C_BLUE}Creating .tmux.conf symlink...${C_RESTORE}"
ln -s ~/.dotfiles/vim/.tmux.conf ~/.tmux.conf

if [ ! -d ~/.config ]; then
  echo "${C_YELLOW}Creating ~/.config directory.${C_RESTORE}";
  mkdir ~/.config
fi

echo "${C_BLUE}Looking for an existing ~/.config/powerline directory...${C_RESTORE}"
if [ -d ~/.config/powerline ] || [ -h ~/.config/powerline ]; then
  echo "${C_YELLOW}Found ~/.config/powerline.${C_RESTORE} ${C_GREEN}Backing up to ~/.config/powerline.backup${C_RESTORE}";
  mv ~/.config/powerline ~/.config/powerline.backup;
fi

echo "${C_BLUE}Creating ~/.config/powerline symlink...${C_RESTORE}"
ln -s ~/.dotfiles/vim/config/powerline/ ~/.config/powerline

echo "${C_BLUE}Installing Tmuxinator...${C_RESTORE}"
gem install tmuxinator