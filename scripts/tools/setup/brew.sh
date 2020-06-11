#!/usr/bin/env zsh
if ! hash brew 2>/dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

function _brewInstallOrUpdate {
    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Checking for package \"$1\"...${C_RESTORE}\n"
    if brew ls --versions "$1" >/dev/null; then
        printf "${C_PURPLE}[Brew] ${C_BLUE}Package \"$1\" found! Upgrading...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$1"
    else
        printf "${C_PURPLE}[Brew] ${C_BLUE}Package \"$1\" not found! Installing...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew install $@
    fi
}

function _caskInstallOrUpdate {
    printf "\n${C_PURPLE}[Cask] ${C_GREEN}Checking for package \"$1\"...${C_RESTORE}\n"
    if brew cask ls --versions "$1" >/dev/null; then
        printf "${C_PURPLE}[Cask] ${C_BLUE}Package \"$1\" found! Upgrading...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew cask upgrade "$1"
    else
        printf "${C_PURPLE}[Cask] ${C_BLUE}Package \"$1\" not found! Installing...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew cask install $@
    fi
}

if hash brew 2>/dev/null; then
    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Updating Homebrew...${C_RESTORE}\n"
    # Repos
    #brew tap homebrew/dupes
    #brew tap homebrew/versions
    #brew tap homebrew/homebrew-php

    # Update formulas
    brew update

    # General tools
    for package in vim neovim tmux ack the_silver_searcher ripgrep wget curl figlet youtube-dl lame fpp fdupes ncdu mosh clipper reattach-to-user-namespace pipenv socat graphicsmagick ffmpeg weechat aria2 moreutils libdvdcss openssh ranger fd bat; do
        _brewInstallOrUpdate $package
    done

    # Servers
    for package in nginx; do
        _brewInstallOrUpdate $package
    done

    # Dev tools
    for package in git node cmake; do
        _brewInstallOrUpdate $package
    done

    # Cask
    for package in xquartz spectacle imageoptim iterm2; do
        _caskInstallOrUpdate $package
    done

    vared -p 'Would you like to update all brew packages installed manualy as well? [y/n]' -c REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew upgrade
    fi

    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Removing old packages...${C_RESTORE}\n"
    brew cleanup
fi
