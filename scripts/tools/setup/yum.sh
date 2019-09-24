#!/usr/bin/env zsh

if hash yum 2>/dev/null; then

  # Dev tools
  sudo yum groupinstall -y "Development Tools"
  sudo yum install -y automake openssl-devel readline-devel zlib-devel pcre-devel xz-devel gcc git ncurses-devel libX11-devel libXtst-devel libffi-devel

  # General tools
  sudo yum install -y vim tmux ack wget curl

  # Try installing new Python veresion
  #sudo yum install -y blue-python27
  #sudo ln -s /usr/local/bin/blue-python2.7 /usr/local/bin/python
  #sudo ln -s /opt/blue-python/2.7/bin/easy_install /usr/local/bin/easy_install

  # Create dirs to compile stuff
  mkdir -p ~/dev
  mkdir -p ~/.local

  # The Silver Searcher (ag)
  if ! hash ag 2>/dev/null; then
    cd /usr/local/src
    sudo git clone https://github.com/ggreer/the_silver_searcher.git
    cd the_silver_searcher
    sudo git pull
    sudo ./build.sh
    sudo make install
    cd -
  fi

  ## Install Python with pyenv (needed to compile vim)
  if hash pyenv 2>/dev/null; then
    cd $(pyenv root)
    git pull
    pyenv install --skip-existing 2.7.16
    pyenv install --skip-existing 3.7.4
    pyenv global 3.7.4 2.7.16
    pyenv rehash
  fi

  # Compile more recent vim
  cd ~/dev
  if [ ! -d vim ]; then
    git clone https://github.com/vim/vim.git
  fi
  cd vim
  git pull
  rm auto/config.log 2>/dev/null
  make distclean
  ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --enable-shared \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=auto \
            --enable-gui=gtk2 \
            --enable-gtk2-check \
            --enable-gnome-check \
            --enable-cscope \
            --prefix=$HOME/.local
  make -j8
  make install

fi
