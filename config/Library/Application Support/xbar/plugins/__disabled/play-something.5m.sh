#!/usr/bin/env bash
FILE_PATH=~/Library/Application\ Support/xbar/.xbar-play-something

if [[ "$(pmset -g | grep ' sleep')" == *"coreaudiod"* ]]; then
  echo 🔉
  rm "$FILE_PATH" 2> /dev/null
else
  echo 🔇
  if [ ! -f "$FILE_PATH" ]; then
    osascript -e 'display notification "Wanna play something?" with title "🔉"'
    touch "$FILE_PATH"
  fi
fi

exit 0
