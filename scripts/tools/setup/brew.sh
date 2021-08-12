#!/usr/bin/env zsh
if ! hash brew 2>/dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! xcode-select -p 1>/dev/null; then
  xcode-select --install
  echo
  echo Please run this again after XCode installation is finished!
  exit 0
fi

function _brewInstallOrUpdate {
    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Checking for package \"$1\"...${C_RESTORE}\n"
    if brew ls --versions "$1" >/dev/null; then
        printf "${C_PURPLE}[Brew] ${C_BLUE}Package \"$1\" found! Upgrading...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$1"
    else
        printf "${C_PURPLE}[Brew] ${C_BLUE}Package \"$1\" not found! Installing...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew install "$@"
    fi
}

function _caskInstallOrUpdate {
    printf "\n${C_PURPLE}[Cask] ${C_GREEN}Checking for package \"$1\"...${C_RESTORE}\n"
    if brew ls --cask --versions "$1" >/dev/null; then
        printf "${C_PURPLE}[Cask] ${C_BLUE}Package \"$1\" found! Upgrading...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade --cask "$1"
    else
        printf "${C_PURPLE}[Cask] ${C_BLUE}Package \"$1\" not found! Installing...${C_RESTORE}\n"
        HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask "$@"
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
    for package in tmux \
      wget \
      curl \
      figlet \
      fpp \
      fdupes \
      ncdu \
      mosh \
      clipper \
      reattach-to-user-namespace \
      socat \
      weechat \
      aria2 \
      pandoc \
      poppler \
      ranger \
      fd \
      ifstat \
      osx-cpu-temp \
      htop; do
        _brewInstallOrUpdate $package
    done

    # Dev tools
    for package in git \
      vim \
      neovim \
      nginx \
      node \
      pipenv \
      bat \
      ack \
      the_silver_searcher \
      ripgrep \
      rga \
      jq \
      efm-langserver \
      cmake; do
        _brewInstallOrUpdate $package
    done
    git config --global credential.helper osxkeychain # Is there a btter place for this?

    # Dependencies
    for package in graphicsmagick \
      ffmpeg \
      lame \
      atomicparsley \
      moreutils \
      libdvdcss \
      openssh; do
        _brewInstallOrUpdate $package
    done

    # Cask
    for package in xquartz \
      spectacle \
      imageoptim \
      iterm2 \
      keka \
      typora \
      xbar \
      oracle-jdk \
      vlc; do
        _caskInstallOrUpdate $package
    done

    # Not work-related formulas
    vared -p 'Would you like to install/update not work-related formulas? [y/n]' -c REPLY1
    if [[ $REPLY1 =~ ^[Yy]$ ]]; then
      for package in handbrake \
        youtube-dl; do
          _brewInstallOrUpdate $package
      done

      for package in handbrake \
        makemkv \
        jdownloader; do
          _caskInstallOrUpdate $package
      done
    fi

    vared -p 'Would you like to update all brew packages installed manualy as well? [y/n]' -c REPLY2
    if [[ $REPLY2 =~ ^[Yy]$ ]]; then
        brew upgrade
    fi

    printf "\n${C_PURPLE}[Brew] ${C_GREEN}Removing old packages...${C_RESTORE}\n"
    brew cleanup
fi
