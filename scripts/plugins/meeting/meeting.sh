# Idea from Pliim: https://github.com/zehfernandes/pliim
if ! hash do-not-disturb 2>/dev/null; then
  yarn global add do-not-disturb-cli
fi

if [ "$1" = "back" ]; then

  echo "🙊 Disabling \"Do Not Disturb\"..."
  do-not-disturb off

  echo "📂 Unhiding Desktop icons..."
  defaults write com.apple.finder CreateDesktop false
  killall Finder

  echo "↘️  Unhiding all windows..."
  osascript <<EOD
    tell application "System Events"
      set visible of (every process) to true
    end tell
EOD

  echo "✅ Done!"
else

  echo "🙊 Enabling \"Do Not Disturb\"..."
  do-not-disturb on

  echo "📂 Hiding Desktop icons..."
  defaults write com.apple.finder CreateDesktop false
  killall Finder

  echo "🔊 Checking if any audio is playing..."
  if [[ "$(pmset -g | grep ' sleep')" == *"coreaudiod"* ]]; then
    echo 🔊 Audio is playing, pausing it...
    python "$OH_MY_GIL_SH/scripts/plugins/mediakeys/mediakeys.py" playpause
  else
    echo 🔊 Nope!
  fi

  echo "↘️  Minimizing and hiding all windows..."
  osascript <<EOD
    tell application "System Events"
      set listOfProcesses to (name of every process where visible is true)
      repeat with procName in listOfProcesses
        set value of attribute "AXMinimized" of windows of process procName to true
        set visible of process procName to false
      end repeat
    end tell
EOD

  if [[ "$(pmset -g | grep ' sleep')" == *"coreaudiod"* ]]; then
    echo "🔊 Let\'s wait and see it that sound playing wasn\'t a false positive"
    sleep 5
    if [[ "$(pmset -g | grep ' sleep')" == *"coreaudiod"* ]]; then
      echo "🔊 Audio could still playing, waiting bit more..."
      sleep 5
      if [[ "$(pmset -g | grep ' sleep')" == *"coreaudiod"* ]]; then
        echo "🔊 Audio seems to still be playing, sorry! Pausing it now..."
        python /Users/agil/.dotfiles/scripts/plugins/mediakeys/mediakeys.py playpause
      fi
    fi
  fi

  echo "✅ Done! Good meeting :]"
fi
