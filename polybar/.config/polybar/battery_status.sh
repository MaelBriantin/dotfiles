#!/bin/bash

BATTERY_CAPACITY="/sys/class/power_supply/BAT0/capacity"
BATTERY_STATUS="/sys/class/power_supply/BAT0/status"

BATTERY=$(cat $BATTERY_CAPACITY)
STATUS=$(cat $BATTERY_STATUS)

color_normal="#cba6f7" 
color_low="#f38ba8"

blink_interval=1
low_battery=20

if [ "$STATUS" == "Charging" ]; then
    echo "%{F${color_normal}}BAT%{F-} $BATTERY% 󱐥"
elif [ "$STATUS" == "Discharging" ]; then
    if [ $BATTERY -le $low_battery ]; then
        echo "%{F${color_low}}BAT%{F-} $BATTERY%"
    else
        echo "%{F${color_normal}}BAT%{F-} $BATTERY%"
    fi
else
    echo "%{F${color_normal}}BAT%{F-} $BATTERY%"
fi

