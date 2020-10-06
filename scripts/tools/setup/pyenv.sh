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

# Update pyenv
cd $(pyenv root)
git pull

# Install python and update pip
pyenv install --skip-existing 2.7.16
pyenv install --skip-existing 3.7.4
pyenv global 3.7.4 2.7.16
pip install --upgrade pip

pip install pudb neovim pyobjc-framework-Quartz
pip2.7 install neovim pyobjc-framework-Quartz
