#!/usr/bin/env zsh

source $OH_MY_GIL_SH/scripts/utils.zsh
_symlinkIfNeeded ~/.config/bitbar $OH_MY_GIL_SH/scripts/tools/bitbar/

# TODO: Move this to rbenv script?
gem install --user-install iStats