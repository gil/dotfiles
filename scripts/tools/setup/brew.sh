#!/usr/bin/env zsh

# Ask for the administrator password upfront
sudo -v || exit 1

if ! hash brew 2>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! xcode-select -p 1>/dev/null; then
    xcode-select --install
    echo
    echo Please run this again after XCode installation is finished!
    exit 0
fi

#if [ "$TERM_PROGRAM" = tmux ]; then
#    printf "\n${C_PURPLE}[Brew] ${C_RED}Please don't run from tmux and an upgrade may break it!${C_RESTORE}\n"
#    exit 1
#fi

if hash brew 2>/dev/null; then
    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Updating Homebrew...${C_RESTORE}\n"
    brew update

    if [ "$TERM_PROGRAM" = tmux ]; then
      brew pin tmux ## to avoid breaking session
    fi

    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Installing and updating packages...${C_RESTORE}\n"
    brew bundle --file=$OH_MY_GIL_SH/scripts/tools/setup/Brewfile

    git config --global credential.helper osxkeychain # Is there a btter place for this?

    # Not work-related formulas
    vared -p 'Would you like to install/update not work-related formulas? [y/n]' -c REPLY1
    if [[ $REPLY1 =~ ^[Yy]$ ]]; then
      brew bundle --file=$OH_MY_GIL_SH/scripts/tools/setup/Brewfile-nonwork
    fi

    vared -p 'Would you like to update all brew packages installed manualy as well? [y/n]' -c REPLY2
    if [[ $REPLY2 =~ ^[Yy]$ ]]; then
        brew upgrade
    fi

    brew unpin tmux

    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Removing old packages...${C_RESTORE}\n"
    brew cleanup

    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Running brew doctor to be sure everything is okay...${C_RESTORE}\n"
    brew doctor
fi
