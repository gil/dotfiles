#!/usr/bin/env zsh

echo "${C_BLUE}Looking for an existing .vimrc...${C_RESTORE}"
if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
  echo "${C_YELLOW}Found ~/.vimrc.${C_RESTORE} ${C_GREEN}Backing up to ~/.vimrc.backup${C_RESTORE}";
  mv ~/.vimrc ~/.vimrc.backup;
fi

echo "${C_BLUE}Creating .vimrc symlink...${C_RESTORE}"
ln -s ~/.dotfiles/vim/.vimrc ~/.vimrc

if [ -d ~/.vim/bundle/Vundle.vim ]; then
	echo "${C_BLUE}Updating Vundle...${C_RESTORE}"
	cd ~/.vim/bundle/Vundle.vim
	git pull origin master
	cd -
else
	echo "${C_BLUE}Cloning Vundle...${C_RESTORE}"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo "${C_BLUE}Installing Powerline...${C_RESTORE}"
pip3 install powerline-status #--user

echo "${C_BLUE}Installing plugins...${C_RESTORE}"
vim +PluginInstall +qall