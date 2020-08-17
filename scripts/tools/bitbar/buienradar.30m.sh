#!/bin/bash

# <bitbar.title>Buienradar.nl</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Andre Gil</bitbar.author>
# <bitbar.author.github>gil</bitbar.author.github>
# <bitbar.desc>Read Amsterdam weather data from Buienradar.nl API.</bitbar.desc>
# <bitbar.dependencies>jq,curl,gm</bitbar.dependencies>

TEMPERATURE=$( curl -s https://data.buienradar.nl/2.0/feed/json | /usr/local/bin/jq '.actual.stationmeasurements[] | select(.regio == "Amsterdam")' )
ICON_URL=$( echo $TEMPERATURE | /usr/local/bin/jq .iconurl | cut -d "\"" -f 2 )
echo "$( echo $TEMPERATURE | /usr/local/bin/jq .temperature )º|image=$( curl -s "$ICON_URL" | /usr/local/bin/gm convert - -resize 18x18 - | base64 )"
echo ---
echo "Feels like: $( echo $TEMPERATURE | /usr/local/bin/jq .feeltemperature )º"
echo "Precipitation: $( echo $TEMPERATURE | /usr/local/bin/jq .precipitation ) mm"
echo "Humidity: $( echo $TEMPERATURE | /usr/local/bin/jq .humidity )%"
echo "Air pressure: $( echo $TEMPERATURE | /usr/local/bin/jq .airpressure ) hPa"
echo "Wind speed: $( echo $TEMPERATURE | /usr/local/bin/jq .windspeed ) km/h"

echo ---
echo "☔️ Chance of rain:"
#curl -s "https://gpsgadget.buienradar.nl/data/raintext/?lat=$( echo $TEMPERATURE | /usr/local/bin/jq .lat )&lon=$( echo $TEMPERATURE | /usr/local/bin/jq .lon )" | tr "|" "-"
curl -s "https://gpsgadget.buienradar.nl/data/raintext/?lat=$( echo $TEMPERATURE | /usr/local/bin/jq .lat )&lon=$( echo $TEMPERATURE | /usr/local/bin/jq .lon )" | ~/.pyenv/shims/python -c '
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
echo "Refresh... | refresh=true"
