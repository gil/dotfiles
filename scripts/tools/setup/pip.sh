#!/usr/bin/env zsh
set -e

cd /tmp
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
cd ~
