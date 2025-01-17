#!/bin/bash

# <bitbar.title>Load Average + Temperature</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Andre Gil</bitbar.author>
# <bitbar.author.github>gil</bitbar.author.github>
# <bitbar.desc>This plugin displays the current CPU load and CPU temperature without dependencies.</bitbar.desc>
#
# If temperature is always zero:
#   brew install osx-cpu-temp

load=$(top -l 2 | grep -E "^CPU" | tail -1 | awk '{print int($3+$5)}')

if [ -f /usr/local/bin/osx-cpu-temp ]; then
  temp=$(/usr/local/bin/osx-cpu-temp | awk '{print int($1)}')
elif [ -f /opt/homebrew/bin/osx-cpu-temp ]; then
  temp=$(/opt/homebrew/bin/osx-cpu-temp | awk '{print int($0)}')
else
  temp=$(sysctl machdep.xcpm.cpu_thermal_level | awk -F'[ ]' '{print $2}')
fi

echo ":rocket: $load% :fire: $tempº" #, $fan"

# This part was borrowed and adapted from:
# https://github.com/matryer/bitbar-plugins/blob/master/System/cpu-usage-kill.5s.sh
# <bitbar.author>Alex M.</bitbar.author>
# <bitbar.author.github>Aleksandern</bitbar.author.github>

echo "---"
ps c -Ao pcpu,command,pid -r | head -n 6 | awk 'NR>1'\
  | while read -r pcpu command pid ; do
    echo "$pcpu% $command $pid | bash='kill -9 ${pid//[!0-9]/} ; exit' terminal=true"
done
echo "---"
echo "Refresh | refresh=true terminal=false"
