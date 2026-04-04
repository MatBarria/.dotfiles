#!/bin/bash

ICON_WEAK="󰤟"
ICON_MEDIUM="󰤢"
ICON_STRONG="󰤥"
ICON_FULL="󰤨"

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

mapfile -t networks < <(
    nmcli --terse --fields SSID,SIGNAL,SECURITY device wifi list --rescan no | \
    awk -F: 'NF && $1 != ""' | \
    sort -t: -k2,2nr | \
    awk -F: '!seen[$1]++'
)

for net in "${networks[@]}"; do
    ssid=${net%%:*}
    rest=${net#*:}
    signal=${rest%%:*}
    security=${rest#*:}

    if [ "$signal" -ge 80 ]; then
        icon="$ICON_FULL"
    elif [ "$signal" -ge 60 ]; then
        icon="$ICON_STRONG"
    elif [ "$signal" -ge 40 ]; then
        icon="$ICON_MEDIUM"
    else
        icon="$ICON_WEAK"
    fi

    if [ -n "$security" ]; then
        label="$icon  $ssid  [secured]"
    else
        label="$icon  $ssid  [open]"
    fi

    printf '%s\t%s\t%s\n' "$label" "$ssid" "$security" >> "$tmpfile"
done

chosen=$(cut -f1 "$tmpfile" | rofi -dmenu -i -p "WiFi")

[ -z "$chosen" ] && exit

line=$(grep -F -m1 "$chosen" "$tmpfile")
ssid=$(printf '%s\n' "$line" | cut -f2)

# First try without password: works for open or saved networks
if nmcli device wifi connect "$ssid" >/dev/null 2>&1; then
    exit
fi

# If that fails, ask for password
password=$(rofi -dmenu -password -p "Password for $ssid")
[ -z "$password" ] && exit

nmcli device wifi connect "$ssid" password "$password"
