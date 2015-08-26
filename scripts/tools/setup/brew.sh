#!/usr/bin/env zsh
if ! hash brew 2>/dev/null; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if hash brew 2>/dev/null; then
	# Repos
	brew tap homebrew/dupes
	brew tap homebrew/versions
	brew tap homebrew/homebrew-php

	# Update formulas
	brew update

	# Upgrade everything already installed
	brew prune
	brew upgrade

	# General tools
	brew install vim
	brew install ack
	brew install wget
	brew install curl
	brew install figlet
	brew install youtube-dl
	brew install ghostscript
	brew install graphicsmagick --with-libtiff --with-webp --with-ghostscript

	# Databases
	brew install postgresql
	brew install mysql
	brew install redis

	# Servers
	brew install nginx
	brew install php56 --with-fpm

	# Dev tools
	brew install git
	brew install maven
	brew install gradle
	brew install node
	brew install rbenv
	brew install ruby-build
	brew install docker
	brew install docker-machine
fi