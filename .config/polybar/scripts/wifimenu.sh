#!/bin/bash

chosen=$(nmcli -t -f SSID device wifi list | grep -v '^$' | sort -u | rofi -dmenu -i -p "WiFi Networks")

if [ -n "$chosen" ]; then
    password=$(rofi -dmenu -p "Enter WiFi password for $chosen")
    nmcli device wifi connect "$chosen" password "$password"
fi
