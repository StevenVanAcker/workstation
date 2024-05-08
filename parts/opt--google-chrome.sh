#!/bin/sh -e

# DESCRIPTION: Google Chrome browser

# Install Google chrome browser

export PAGER=cat

dpkg -s google-chrome-stable && echo "==> Chrome already installed." && exit 0

curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
yes | aptdcon --hide-terminal --refresh
yes | aptdcon --hide-terminal --install="google-chrome-stable"
