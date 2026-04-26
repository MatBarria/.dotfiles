
#!/bin/bash

query=$(echo "" | rofi -dmenu -p "Search in youtube:")

[ -z "$query" ] && exit 0

xdg-open "https://www.youtube.com/results?search_query==$query" >/dev/null 2>&1 &

sleep 0.5

i3-msg '[class="firefox"] focus'
