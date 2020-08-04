if [ ! -d ~/.config/bat ]; then
  mkdir -p ~/.config/bat
fi

if [ ! -d ~/.config/bat/themes ] && [ ! -L ~/.config/bat/themes ]; then
  ln -s $OH_MY_GIL_SH/scripts/themes/base16-themes/output/base16-textmate/Themes/ ~/.config/bat/themes
fi

# If it's a new theme, run: bat cache --build
export BAT_THEME="base16-gruvbox-dark-medium"
