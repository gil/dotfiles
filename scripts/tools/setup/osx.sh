#!/usr/bin/env zsh

# Ask for the administrator password upfront
sudo -v

# ctrl+cmd drag windows
defaults write -g NSWindowShouldDragOnGesture -bool true

# Finder: Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Sort folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# No .DS_Store on network storages and USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable annoying keyboard popups
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

# Tab navitgate all fields
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Show the ~/Library folder
# chflags nohidden ~/Library

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Show application windows
defaults write com.apple.dock wvous-tr-corner -int 3
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Put display to sleep
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

# Dock: No delay and faster animation
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Dock: Don't show recently used apps
defaults write com.apple.dock show-recents -bool false

# Screenshot: No shadow
defaults write com.apple.screencapture disable-shadow -bool true

# Screenshot: Dedicated folder
mkdir -p $HOME/Pictures/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# TextEdit: Use plain text mode for new documents
defaults write com.apple.TextEdit RichText -int 0

# TextEdit Open and save files as UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Disable clipboard sharing with iPhone (on work Mac)
# defaults write ~/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled 0

for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
