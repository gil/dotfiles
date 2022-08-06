#!/usr/bin/env zsh
set -e

# Clone pyenv
if [ ! -d ~/.pyenv ]; then
  git clone https://github.com/yyuu/pyenv.git ~/.pyenv
fi

# Force loading for now
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"

# Update pyenv
cd $(pyenv root)
git pull

# Install python and update pip
pyenv install --skip-existing 2.7.18
pyenv install --skip-existing 3.9.6
pyenv global 3.9.6 2.7.18

# Upgrade pip
pip install --upgrade pip
pip2 install --upgrade pip

# Install packages
pip install pudb neovim python-lsp-server
pip2 install pudb neovim python-lsp-server

if [[ $OSTYPE == darwin* ]]; then
  pip install pyobjc-framework-Quartz
  pip2 install pyobjc-framework-Quartz
fi
