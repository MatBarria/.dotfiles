#!/bin/bash

# Font with Nerd Fonts icons required, e.g., "JetBrainsMono Nerd Font"
ICON_WEAK="󰤟"     # low signal
ICON_MEDIUM="󰤢"   # medium signal
ICON_STRONG="󰤥"   # stronger, but same icon
ICON_FULL="󰤨"     # full (you can customize further)

# Collect SSID and SIGNAL
mapfile -t networks < <(nmcli -t -f SSID,SIGNAL device wifi list | grep -v '^:' | grep -v '^$' | sort -u)

options=()

for net in "${networks[@]}"; do
    ssid="${net%%:*}"
    signal="${net##*:}"

    # Choose icon
    if [ "$signal" -ge 80 ]; then
        icon=$ICON_FULL
    elif [ "$signal" -ge 60 ]; then
        icon=$ICON_STRONG
    elif [ "$signal" -ge 40 ]; then
        icon=$ICON_MEDIUM
    else
        icon=$ICON_WEAK
    fi

    options+=("$icon  $ssid")
done

# Show Rofi menu
chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "WiFi Networks" -no-show-icons)

# Extract the SSID (remove icon and whitespace)
ssid=$(echo "$chosen" | cut -d' ' -f2-)

if [ -n "$ssid" ]; then
    password=$(rofi -dmenu -p "Enter WiFi password for $ssid" -no-show-icons)
    nmcli device wifi connect "$ssid" password "$password"
fi
