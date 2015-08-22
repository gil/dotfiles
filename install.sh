set -e
source ~/.dotfiles/scripts/colors.zsh
ZSH=~/.dotfiles/oh-my-zsh

if [ -d "$ZSH" ]; then
	echo "${C_BLUE}Removing old Oh My Zsh...${C_RESTORE}"
  rm -rf $ZSH
fi

echo "${C_BLUE}Cloning Oh My Zsh...${C_RESTORE}"
hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH || {
  echo "git not installed"
  exit
}

echo "${C_BLUE}Looking for an existing zsh config...${C_RESTORE}"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
  echo "${C_YELLOW}Found ~/.zshrc.${C_RESTORE} ${C_GREEN}Backing up to ~/.zshrc.backup${C_RESTORE}";
  mv ~/.zshrc ~/.zshrc.backup;
fi

echo "${C_BLUE}Creating the zsh config...${C_RESTORE}"
echo "source $HOME/.dotfiles/init.sh" >> ~/.zshrc

TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    echo "${C_BLUE}Time to change your default shell to zsh!${C_RESTORE}"
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
fi
unset TEST_CURRENT_SHELL

echo "${C_GREEN}"'          __                                _ __        __              ___ '"${C_RESTORE}"
echo "${C_GREEN}"'   ____  / /_     ____ ___  __  __   ____ _(_) /  _____/ /_       _    /  / '"${C_RESTORE}"
echo "${C_GREEN}"'  / __ \/ __ \   / __ `__ \/ / / /  / __ `/ / /  / ___/ __ \     (_)   / /  '"${C_RESTORE}"
echo "${C_GREEN}"' / /_/ / / / /  / / / / / / /_/ /  / /_/ / / /  (__  ) / / /    _     / /   '"${C_RESTORE}"
echo "${C_GREEN}"' \____/_/ /_/  /_/ /_/ /_/\__, /   \__, /_/_/  /____/_/ /_/    (_)  _/ /    '"${C_RESTORE}"
echo "${C_GREEN}"'                         /____/   /____/                           /__/     ....is now installed!'"${C_RESTORE}"

env zsh
. ~/.zshrc