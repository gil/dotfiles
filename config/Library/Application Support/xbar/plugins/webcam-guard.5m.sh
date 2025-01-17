#!/usr/bin/env bash
FILE_PATH=~/Library/Application\ Support/xbar/.xbar-webcam-guard
LAST_VALUE=$(cat "$FILE_PATH")
IS_RUNNING=$(osascript -e 'tell application "System Events" to (name of processes) contains "zoom.us"')

if [[ "$LAST_VALUE" != "$IS_RUNNING" ]]; then
  if [[ "$IS_RUNNING" == "true" ]]; then
    osascript -e 'display notification "You can open your cam now!" with title "Webcam Guard"'
  else
    osascript -e 'display notification "Remember to close your webcam!" with title "Webcam Guard"'
  fi
fi

if [[ "$IS_RUNNING" == "true" ]]; then
  echo 🔴🔴🔴 # 🐵
else
  echo ⚪️ # 🙈
fi

echo $IS_RUNNING > "$FILE_PATH"
