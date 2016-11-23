#!/usr/bin/env zsh

KEEP_MENU_OPEN=true
PS3='Please enter your choice: '
options=("OSX" "Fonts and Terminal Theme (OSX)" "Command Line Tools (If you don't want XCode)" "Homebrew (OSX)" "Vim & tmux" "Quit")

while $KEEP_MENU_OPEN
do

  echo "${C_GREEN}\nSelect the script(s) you want to run to setup your environment:\n${C_RESTORE}"

  select opt in "${options[@]}"
  do
    case $opt in
      "OSX")
        echo ""
        ~/.dotfiles/scripts/tools/setup/osx.sh
        break
        ;;
      "Fonts and Terminal Theme (OSX)")
        echo ""
        ~/.dotfiles/scripts/tools/setup/fonts-and-themes.sh
        break
        ;;
      "Command Line Tools (If you don't want XCode)")
        echo ""
        xcode-select --install
        sudo xcodebuild -license
        break
        ;;
      "Homebrew (OSX)")
        ~/.dotfiles/scripts/tools/setup/brew.sh
        break
        ;;
      "Vim & tmux")
        ~/.dotfiles/scripts/tools/setup/vim.sh
        break
        ;;
      "Quit")
        KEEP_MENU_OPEN=false
        break
        ;;
      *) echo invalid option;;
    esac
  done
done