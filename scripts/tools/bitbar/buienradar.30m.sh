#!/bin/bash

# <bitbar.title>Buienradar.nl</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Andre Gil</bitbar.author>
# <bitbar.author.github>gil</bitbar.author.github>
# <bitbar.desc>Read Amsterdam weather data from Buienradar.nl API.</bitbar.desc>
# <bitbar.dependencies>jq,curl</bitbar.dependencies>

TEMPERATURE=$( curl -s https://data.buienradar.nl/2.0/feed/json | /usr/local/bin/jq '.actual.stationmeasurements[] | select(.regio == "Amsterdam")' )
echo "🌤  $( echo $TEMPERATURE | /usr/local/bin/jq .temperature )º"
echo ---
echo "Feels like: $( echo $TEMPERATURE | /usr/local/bin/jq .feeltemperature )º"
echo "Precipitation: $( echo $TEMPERATURE | /usr/local/bin/jq .precipitation ) mm"
echo "Humidity: $( echo $TEMPERATURE | /usr/local/bin/jq .humidity )%"
echo "Air pressure: $( echo $TEMPERATURE | /usr/local/bin/jq .airpressure ) hPa"
echo "Wind speed: $( echo $TEMPERATURE | /usr/local/bin/jq .windspeed ) km/h"

echo ---
echo "☔️ Chance of rain:"
curl -s "https://gpsgadget.buienradar.nl/data/raintext/?lat=$( echo $TEMPERATURE | /usr/local/bin/jq .lat )&lon=$( echo $TEMPERATURE | /usr/local/bin/jq .lon )" | tr "|" "-"  
