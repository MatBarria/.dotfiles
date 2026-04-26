#!/bin/bash

query=$(echo "" | rofi -dmenu -p "Search:")

[ -z "$query" ] && exit 0

xdg-open "https://www.google.de/search?q=$query" >/dev/null 2>&1 &

sleep 0.5

i3-msg '[class="firefox"] focus'
