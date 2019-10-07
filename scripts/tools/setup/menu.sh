#!/usr/bin/env zsh

KEEP_MENU_OPEN=true
PS3='Please enter your choice: '
options=(
  "OSX Settings"
  "Fonts and Terminal Theme (OSX)"
  "Command Line Tools (If you don't want XCode)"
  "Homebrew (OSX)"
  "yum (Linux)"
  "NVM + NodeJS"
  "Yarn"
  "pyenv (Python)"
  "rbenv + Ruby"
  "Vim & tmux"
  "Quit"
)

while $KEEP_MENU_OPEN
do

  printf "${C_GREEN}\nSelect the script(s) you want to run to setup your environment:\n${C_RESTORE}\n"

  select opt in "${options[@]}"
  do
    case $opt in
      "OSX Settings")
        echo ""
        $OH_MY_GIL_SH/scripts/tools/setup/osx.sh
        break
        ;;
      "Fonts and Terminal Theme (OSX)")
        echo ""
        $OH_MY_GIL_SH/scripts/tools/setup/fonts-and-themes.sh
        break
        ;;
      "Command Line Tools (If you don't want XCode)")
        echo ""
        xcode-select --install
        sudo xcodebuild -license
        break
        ;;
      "Homebrew (OSX)")
        $OH_MY_GIL_SH/scripts/tools/setup/brew.sh
        break
        ;;
      "yum (Linux)")
        $OH_MY_GIL_SH/scripts/tools/setup/yum.sh
        break
        ;;
      "NVM + NodeJS")
        $OH_MY_GIL_SH/scripts/tools/setup/nvm.sh
        break
        ;;
      "Yarn")
        $OH_MY_GIL_SH/scripts/tools/setup/yarn.sh
        break
        ;;
      "pyenv (Python)")
        $OH_MY_GIL_SH/scripts/tools/setup/pyenv.sh
        break
        ;;
      "rbenv + Ruby")
        $OH_MY_GIL_SH/scripts/tools/setup/rbenv.sh
        break
        ;;
      "Vim & tmux")
        $OH_MY_GIL_SH/scripts/tools/setup/vim.sh
        break
        ;;
      "Quit")
        break
        ;;
      *) echo invalid option;;
    esac
  done

  KEEP_MENU_OPEN=false
done
