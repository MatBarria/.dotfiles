#!/bin/bash

chosen=$(printf "Lock\nReboot\nShutdown" | rofi -dmenu -i -p "Power Menu" -no-show-icons)

case "$chosen" in
    "Lock") i3lock ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
esac
