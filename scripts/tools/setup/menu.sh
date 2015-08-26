#!/usr/bin/env zsh

KEEP_MENU_OPEN=true
PS3='Please enter your choice: '
options=("OSX" "Command Line Tools (If you don't want XCode)" "Homebrew" "Quit")

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
      "Command Line Tools (If you don't want XCode)")
        echo ""
        xcode-select --install
        break
        ;;
      "Homebrew")
        ~/.dotfiles/scripts/tools/setup/brew.sh
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