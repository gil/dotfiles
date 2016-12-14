#!/usr/bin/env zsh

if hash yum 2>/dev/null; then

  # Dev tools
  sudo yum groupinstall -y "Development Tools"
  sudo yum install -y automake openssl-devel readline-devel zlib-devel pcre-devel xz-devel

  # Try installing new Python veresion
  sudo yum install -y blue-python27
  sudo ln -s /usr/local/bin/blue-python2.7 /usr/local/bin/python
  sudo ln -s /opt/blue-python/2.7/bin/easy_install /usr/local/bin/easy_install

  # General tools
  sudo yum install -y vim
  sudo yum install -y tmux
  sudo yum install -y ack
  sudo yum install -y wget
  sudo yum install -y curl

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

fi
