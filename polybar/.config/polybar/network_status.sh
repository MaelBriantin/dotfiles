#!/bin/bash

get_wifi_info() {
    local signal_info=$(iwconfig wlan0 | grep 'Link Quality')
    local signal_strength=$(echo $signal_info | awk '{print $2}' | awk -F'=' '{print $2}')
    local ssid=$(iwgetid -r)

    if [ -z "$signal_strength" ]; then
        echo "unknown 0"
    else
        echo "$ssid $signal_strength"
    fi
}

get_speeds() {
    local interface=$1

    local rx1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    local tx1=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    sleep 1
    local rx2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    local tx2=$(cat /sys/class/net/$interface/statistics/tx_bytes)

    local rx_bytes=$((rx2 - rx1))
    local tx_bytes=$((tx2 - tx1))

    local rx_kbps=$((rx_bytes / 1024))
    local tx_kbps=$((tx_bytes / 1024))

    echo "$rx_kbps $tx_kbps"
}

ETH_STATUS=$(cat /sys/class/net/eno1/operstate)
WIFI_STATUS=$(cat /sys/class/net/wlan0/operstate)

color_title="#89b4FA"  # Sky
color_signal="#b4befe"

if [ "$ETH_STATUS" == "up" ]; then
    read downspeed upspeed <<< $(get_speeds eno1)
    echo "%{F${color_title}}ETH%{F-} %{F${color_signal}}󰇚%{F-} ${downspeed}KB/s %{F${color_signal}}󰕒%{F-} ${upspeed}KB/s"
elif [ "$WIFI_STATUS" == "up" ]; then
    read downspeed upspeed <<< $(get_speeds wlan0)
    read ssid signal_strength <<< $(get_wifi_info)
    echo "%{F${color_title}}WIFI%{F-} %{F${color_signal}}$ssid%{F-} ${signal_strength} %{F${color_signal}}󰇚%{F-} ${downspeed}KB/s %{F${color_signal}}󰕒%{F-} ${upspeed}KB/s"
else
    echo "%{F${color_title}}WIFI%{F-} disconnected"
fi

