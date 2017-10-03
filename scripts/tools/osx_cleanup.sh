#!/usr/bin/env zsh
setopt +o nomatch

oldAvailable=$(df -h / | tail -1 | awk '{print $4}')

if [ "$EUID" -eq 0  ]; then
  echo "Please run this command again without sudo!"
  exit
fi

echo "Empty the Trash on all mounted volumes and the main HDD..."
sudo rm -rfv /Volumes/*/.Trashes/* &>/dev/null
sudo rm -rfv ~/.Trash/* &>/dev/null

echo "Cleaning System Log Files..."
sudo rm -rfv /private/var/log/asl/*.asl &>/dev/null
sudo rm -rfv /Library/Logs/DiagnosticReports/* &>/dev/null
sudo rm -rfv /Library/Logs/Adobe/* &>/dev/null
sudo rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/* &>/dev/null
sudo rm -rfv ~/Library/Logs/CoreSimulator/* &>/dev/null

echo "Cleaning Adobe Cache Files..."
sudo rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null

echo "Cleaning iTunes iPhone/iPad updates..."
sudo rm -rfv ~/Library/iTunes/iPhone\ Software\ Updates &>/dev/null
sudo rm -rfv ~/Library/iTunes/iPad\ Software\ Updates &>/dev/null

echo "Cleaning Homebrew Cache..."
brew cleanup --force -s &>/dev/null
brew cask cleanup &>/dev/null
sudo rm -rfv /Library/Caches/Homebrew/* &>/dev/null
brew tap --repair &>/dev/null

echo "Cleaning any old versions of gems..."
gem cleanup &>/dev/null

echo "Cleaning NPM cache..."
npm cache clean &>/dev/null

echo "Cleaning system cache..."
sudo rm -rfv ~/Library/Caches/* &>/dev/null
sudo rm -rfv /Library/Caches/* &>/dev/null
sudi rm -rfv /System/Library/Caches/* &>/dev/null

echo "Checking if Docker is running..."
docker info &>/dev/null

if [ $? -eq 0 ]; then
    echo "Cleaning old Docker container/images (spotify/docker-gc)..."
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc:ro spotify/docker-gc
fi

echo "Running periodic jobs..."
sudo periodic daily weekly monthly

echo "Purge inactive memory..."
sudo purge

if [ ! -d /Applications/OmniDiskSweeper.app ]; then
    echo "Installing OmniDiskSweeper..."
    brew cask uninstall omnidisksweeper &> /dev/null
    brew cask install omnidisksweeper
fi

echo "Success!"

newAvailable=$(df -h / | tail -1 | awk '{print $4}')

echo "Previous space available: $oldAvailable"
echo "New space available: $newAvailable"

open -a OmniDiskSweeper
