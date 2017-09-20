#!/usr/bin/env zsh

# Ask for the administrator password upfront
if [ "$EUID" -ne 0  ]; then
  echo "Please run as root"
  exit
fi

oldAvailable=$(df -h / | tail -1 | awk '{print $4}')

echo "Empty the Trash on all mounted volumes and the main HDD..."
rm -rfv /Volumes/*/.Trashes &>/dev/null
rm -rfv ~/.Trash &>/dev/null

echo "Cleaning System Log Files..."
rm -rfv /private/var/log/asl/*.asl &>/dev/null
rm -rfv /Library/Logs/DiagnosticReports/* &>/dev/null
rm -rfv /Library/Logs/Adobe/* &>/dev/null
rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/* &>/dev/null
rm -rfv ~/Library/Logs/CoreSimulator/* &>/dev/null

echo "Cleaning Adobe Cache Files..."
rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null

echo "Cleaning iTunes iPhone/iPad updates..."
rm -rfv ~/Library/iTunes/iPhone\ Software\ Updates &>/dev/null
rm -rfv ~/Library/iTunes/iPad\ Software\ Updates &>/dev/null

echo "Cleaning Homebrew Cache..."
brew cleanup --force -s &>/dev/null
brew cask cleanup &>/dev/null
rm -rfv /Library/Caches/Homebrew/* &>/dev/null
brew tap --repair &>/dev/null

echo "Cleaning any old versions of gems..."
gem cleanup &>/dev/null

echo "Cleaning NPM cache..."
npm cache clean &>/dev/null

echo "Cleaning system cache..."
rm -rfv ~/Library/Caches/* &>/dev/null
rm -rfv /Library/Caches/* &>/dev/null
rm -rfv /System/Library/Caches/* &>/dev/null

echo "Running periodic jobs..."
periodic daily weekly monthly

echo "Purge inactive memory..."
purge

echo "Success!"

newAvailable=$(df -h / | tail -1 | awk '{print $4}')

echo "Previous space available: $oldAvailable"
echo "New space available: $newAvailable"
