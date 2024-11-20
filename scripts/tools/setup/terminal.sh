#!/usr/bin/env zsh
#
source $OH_MY_GIL_SH/scripts/utils.zsh

### Fonts ###
cp "$OH_MY_GIL_SH/scripts/tools/assets/InconsolataGoNerdFont-Regular.ttf" ~/Library/Fonts
cp "$OH_MY_GIL_SH/scripts/tools/assets/Inconsolata[wdth,wght].ttf" ~/Library/Fonts

### Kitty ###
_createDirectoryIfNeeded ~/.config/kitty
_symlinkIfNeeded ~/.config/kitty/kitty.conf $OH_MY_GIL_SH/config/kitty/kitty.conf
_symlinkIfNeeded ~/.config/kitty/kitty.app.icns $OH_MY_GIL_SH/config/kitty/kitty.app.icns

## Mac Terminal ###
open $OH_MY_GIL_SH/scripts/tools/assets/Solarized\ Dark\ 256.terminal
