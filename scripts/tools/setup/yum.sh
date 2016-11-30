#!/usr/bin/env zsh

if hash yum 2>/dev/null; then

	# Dev tools
  sudo yum groupinstall -y "Development Tools"
  sudo yum install -y openssl-devel readline-devel zlib-devel pcre-devel xz-devel
  sudo yum install -y blue-python27-pip.noarch

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
