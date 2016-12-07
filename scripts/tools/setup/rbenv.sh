#!/usr/bin/env zsh
set -e

if [ ! -d ~/.rbenv ]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
fi

cd ~/.rbenv
git pull
src/configure && make -C src
#~/.rbenv/bin/rbenv init
eval "$(rbenv init -)"

source ~/.zshrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
cd ~/.rbenv/plugins/ruby-build
git pull

rbenv install 2.3.3
rbenv global 2.3.3

source ~/.zshrc
