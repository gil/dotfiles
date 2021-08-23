#!/usr/bin/env zsh

if hash yum 2>/dev/null; then

  # Dev tools
  printf "\n${C_PURPLE}[yum] ${C_GREEN}Installing stuff required to compile other stuff...${C_RESTORE}\n"
  sudo yum groupinstall -y "Development Tools"
  sudo yum install -y automake openssl-devel readline-devel zlib-devel pcre-devel xz-devel gcc cmake git ncurses-devel libX11-devel libXtst-devel libffi-devel python-devel python3-devel

  # General tools
  printf "\n${C_PURPLE}[yum] ${C_GREEN}Installing general tools...${C_RESTORE}\n"
  sudo yum install -y vim tmux ack wget curl

  # Try installing new Python veresion
  #sudo yum install -y blue-python27
  #sudo ln -s /usr/local/bin/blue-python2.7 /usr/local/bin/python
  #sudo ln -s /opt/blue-python/2.7/bin/easy_install /usr/local/bin/easy_install

  # Create dirs to compile stuff
  printf "\n${C_PURPLE}[yum] ${C_GREEN}Creating directories for dev...${C_RESTORE}\n"
  mkdir -p ~/dev
  mkdir -p ~/.local/bin

  # The Silver Searcher (ag)
  if ! hash ag 2>/dev/null; then
    printf "\n${C_PURPLE}[yum] ${C_GREEN}Installing The Silver Searcher (ag)...${C_RESTORE}\n"
    cd /usr/local/src
    sudo git clone https://github.com/ggreer/the_silver_searcher.git
    cd the_silver_searcher
    sudo git pull
    sudo ./build.sh
    sudo make install
    cd -
  fi

  # Neovim
  if ! hash nvim 2>/dev/null; then
    printf "\n${C_PURPLE}[nvim] ${C_GREEN}Installing Neovim...${C_RESTORE}\n"

    mkdir -p ~/.nvim
    cd ~/.nvim

    wget https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract
    ln -s ~/.nvim/squashfs-root/usr/bin/nvim ~/.local/bin/nvim
  fi


  ## Install Python with pyenv (needed to compile vim)
  #if hash pyenv 2>/dev/null; then
    #printf "\n${C_PURPLE}[yum] ${C_GREEN}Installing Python to compile Vim...${C_RESTORE}\n"
    #cd $(pyenv root)
    #git pull
    #pyenv install --skip-existing 2.7.16
    #pyenv install --skip-existing 3.7.4
    #pyenv global 3.7.4 2.7.16
    #pyenv rehash
  #fi

  #printf "\n${C_PURPLE}[yum] ${C_GREEN}Installing pip...${C_RESTORE}\n"
  #easy_install --user pip

  # Compile more recent vim
  #cd ~/dev
  #if [ ! -d vim ]; then
    #printf "\n${C_PURPLE}[yum] ${C_GREEN}Clonning Vim...${C_RESTORE}\n"
    #git clone https://github.com/vim/vim.git
  #fi
  #printf "\n${C_PURPLE}[yum] ${C_GREEN}Updating Vim...${C_RESTORE}\n"
  #cd vim
  #git pull
  #printf "\n${C_PURPLE}[yum] ${C_GREEN}Cleaning old Vim build files...${C_RESTORE}\n"
  #rm auto/config.log 2>/dev/null
  #make distclean
  #printf "\n${C_PURPLE}[yum] ${C_GREEN}Configuring Vim...${C_RESTORE}\n"
  #./configure --with-features=huge \
            #--enable-multibyte \
            #--enable-rubyinterp \
            #--enable-pythoninterp \
            #--enable-perlinterp \
            #--enable-luainterp \
            #--enable-gui=auto \
            #--enable-gui=gtk2 \
            #--enable-gtk2-check \
            #--enable-gnome-check \
            #--enable-cscope \
            #--prefix=$HOME/.local
  #if [ $? -eq 0 ]; then
    #printf "\n${C_PURPLE}[yum] ${C_GREEN}Making Vim...${C_RESTORE}\n"
    #make -j8
  #fi
  #if [ $? -eq 0 ]; then
    #printf "\n${C_PURPLE}[yum] ${C_GREEN}Installing Vim...${C_RESTORE}\n"
    #make install
  #fi
  #if [ $? -eq 0 ]; then
    #printf "\n${C_PURPLE}[yum] ${C_GREEN}Vim installed!${C_RESTORE}\n"
  #fi
fi
