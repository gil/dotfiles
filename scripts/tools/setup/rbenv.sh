#!/usr/bin/env zsh

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv
git pull
src/configure && make -C src
~/.rbenv/bin/rbenv init

refresh_dotfiles

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
cd ~/.rbenv/plugins/ruby-build
git pull
