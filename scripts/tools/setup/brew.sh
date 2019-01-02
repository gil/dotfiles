#!/usr/bin/env zsh
if ! hash brew 2>/dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

function _brewInstallOrUpdate {
    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Checking for package \"$1\"...${C_RESTORE}\n"
    if brew ls --versions "$1" >/dev/null; then
        printf "${C_PURPLE}[Brew] ${C_BLUE}Package \"$1\" found! Upgrading...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade --cleanup "$1"
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
    brew prune

    # General tools
    for package in tmux ack the_silver_searcher ripgrep wget curl figlet youtube-dl ghostscript lame fpp fdupes ncdu mosh clipper reattach-to-user-namespace pipenv; do
        _brewInstallOrUpdate $package
    done
    _brewInstallOrUpdate vim --with-override-system-vi
    _brewInstallOrUpdate graphicsmagick --with-libtiff --with-webp --with-ghostscript
    _brewInstallOrUpdate ffmpeg --with-libvpx --with-libvorbis --with-webp
    _brewInstallOrUpdate weechat --with-python@2 --with-perl --with-ruby

    # Servers
    for package in nginx; do
        _brewInstallOrUpdate $package
    done

    # Dev tools
    for package in git node; do
        _brewInstallOrUpdate $package
    done

    # Cask
    for package in xquartz spectacle; do
        _caskInstallOrUpdate $package
    done

    vared -p 'Would you like to update all brew packages installed manualy as well? [y/n]' -c REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew upgrade --cleanup
    fi
fi
