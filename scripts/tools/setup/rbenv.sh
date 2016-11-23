#!/usr/bin/env zsh

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv
git pull
src/configure && make -C src
~/.rbenv/bin/rbenv init

#refresh_dotfiles


