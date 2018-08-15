#!/usr/bin/env zsh
set -e

if ! hash yarn 2>/dev/null; then
    if hash brew 2>/dev/null; then
        brew install yarn --without-node
    fi
    if hash yum 2>/dev/null; then
        curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
        sudo yum install yarn
    fi
fi


if hash yarn 2>/dev/null; then
    printf "\n${C_PURPLE}[Yarn] ${C_GREEN}Installing/Updating modules...${C_RESTORE}\n"
    yarn global add karma-cli nodemon csscomb eslint eslint_d
else
    printf "\n${C_PURPLE}[Yarn] ${C_RED}Couldn't find Yarn!${C_RESTORE}\n"
fi
