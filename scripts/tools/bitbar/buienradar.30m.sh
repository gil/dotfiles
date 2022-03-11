#!/bin/bash

# <bitbar.title>Buienradar.nl</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Andre Gil</bitbar.author>
# <bitbar.author.github>gil</bitbar.author.github>
# <bitbar.desc>Read Amsterdam weather data from Buienradar.nl API.</bitbar.desc>
# <bitbar.dependencies>jq,curl,gm</bitbar.dependencies>

PATH=/usr/local/bin:/opt/homebrew/bin:$PATH
TEMPERATURE=$( curl -s https://data.buienradar.nl/2.0/feed/json | jq '.actual.stationmeasurements[] | select(.regio == "Amsterdam")' )
ICON_URL=$( echo $TEMPERATURE | jq .iconurl | cut -d "\"" -f 2 )
echo "$( echo $TEMPERATURE | jq .temperature )º|image=$( curl -s "$ICON_URL" | gm convert - -resize 18x18 - | base64 )"
echo ---
echo "Feels like: $( echo $TEMPERATURE | jq .feeltemperature )º"
echo "Precipitation: $( echo $TEMPERATURE | jq .precipitation ) mm"
echo "Humidity: $( echo $TEMPERATURE | jq .humidity )%"
echo "Air pressure: $( echo $TEMPERATURE | jq .airpressure ) hPa"
echo "Wind speed: $( echo $TEMPERATURE | jq .windspeed ) km/h"
echo "|image=$( curl -sL "https://api.buienradar.nl/image/1.0/RadarMapNL?w=215&h=155" | base64)"

echo ---
echo "☔️ Chance of rain:"
#curl -s "https://gpsgadget.buienradar.nl/data/raintext/?lat=$( echo $TEMPERATURE | jq .lat )&lon=$( echo $TEMPERATURE | jq .lon )" | tr "|" "-"
curl -s "https://gpsgadget.buienradar.nl/data/raintext/?lat=$( echo $TEMPERATURE | jq .lat )&lon=$( echo $TEMPERATURE | jq .lon )" | ~/.pyenv/shims/python -c '
import sys
import math
for line in sys.stdin:
  parts = line.strip().split("|")
  total = math.ceil(int(parts[0]) / 15)
  bars = "▕"
  for _ in range(total):
    bars = bars + "█"
  print(parts[1] + bars + "|font=Courier color=blue")
'
echo "Open details...|href=https://www.buienradar.nl/weer/Amsterdam/NL/2759794"
echo "Refresh...|refresh=true"
