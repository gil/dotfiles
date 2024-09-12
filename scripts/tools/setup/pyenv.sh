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
pyenv install --skip-existing 3.11
pyenv global 3.11

# Upgrade pip
pip install --upgrade pip

# Install packages
pip install pudb neovim python-lsp-server

if [[ $OSTYPE == darwin* ]]; then
  pip install pyobjc-framework-Quartz
fi
