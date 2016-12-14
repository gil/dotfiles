#!/usr/bin/env zsh
set -e

# Clone pyenv
if [ ! -d ~/.pyenv ]; then
  git clone https://github.com/yyuu/pyenv.git ~/.pyenv
fi

# Force loading for now
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Install python and update pip
pyenv install 2.7.12
pyenv global 2.7.12
pip install --upgrade pip
