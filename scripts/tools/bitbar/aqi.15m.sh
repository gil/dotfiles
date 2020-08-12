#!/bin/bash
#
# <bitbar.title>Air Quality Index</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Chongyu Yuan</bitbar.author>
# <bitbar.author.github>nnnggel</bitbar.author.github>
# <bitbar.desc>Real-time Air Quality Index, you need an 'aqi api token' and install 'jq' first.</bitbar.desc>
# <bitbar.image>https://i.imgur.com/7bc5qqh.jpg</bitbar.image>
# <bitbar.dependencies>bash</bitbar.dependencies>
# <bitbar.abouturl>http://www.yuanchongyu.com</bitbar.abouturl>
#
# Adapted by Andre Gil <https://github.com/gil/>
#

# TODO: Find a way of resolving $OH_MY_GIL_SH, so maybe this is not even needed
source ~/.dotfiles/custom/.zshrc # To read $AQI_TOKEN

COLORS=("#0ed812" "#ffde33" "#ff9933" "#cc0033" "#660099" "#7e0023" "#404040")

# where to get the token -> https://aqicn.org/api/
CITY="amsterdam"

URL="http://aqicn.org/city/${CITY}/"

DATA=$(curl -s http://api.waqi.info/feed/${CITY}/?token=${AQI_TOKEN})

# how to install jq -> https://stedolan.github.io/jq/download/
AQI=$(echo "${DATA}" | /usr/local/bin/jq '.data.aqi' | sed -e "s/\"//g")

function colorize {
  if [ "$AQI" = "-" ]; then
    echo "${COLORS[6]}"
  elif [ "$1" -le 50 ]; then
    echo "${COLORS[0]}"
  elif [ "$1" -le 100 ]; then
    echo "${COLORS[1]}"
  elif [ "$1" -le 150 ]; then
    echo "${COLORS[2]}"
  elif [ "$1" -le 200 ]; then
    echo "${COLORS[3]}"
  elif [ "$1" -le 300 ]; then
    echo "${COLORS[4]}"
  else
    echo "${COLORS[5]}"
  fi
}

COLOR="$(colorize "${AQI}")"
echo ":leaves: ${AQI} | color=${COLOR}"

echo "---"
echo "0-50: Good | color=${COLORS[0]}"
echo "51-100: Moderate | color=${COLORS[1]}"
echo "101-150: Unhealthy for Sensitive Groups | color=${COLORS[2]}"
echo "151-200: Unhealthy | color=${COLORS[3]}"
echo "201-300: Very Unhealthy | color=${COLORS[4]}"
echo "301+: Hazardous | color=${COLORS[5]}"

echo "---"
echo "Open details... | href=${URL}"
echo "Refresh... | refresh=true"