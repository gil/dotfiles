#!/usr/bin/env zsh

source $OH_MY_GIL_SH/scripts/utils.zsh
_symlinkIfNeeded ~/Library/Application\ Support/xbar/plugins $OH_MY_GIL_SH/scripts/tools/bitbar/

# TODO: Move this to rbenv script?
gem install --user-install iStats