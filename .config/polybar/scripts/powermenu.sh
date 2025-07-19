#!/bin/bash

chosen=$(printf " Lock\n Reboot\n Shutdown" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
    " Lock") i3lock ;;
    " Reboot") systemctl reboot ;;
    " Shutdown") systemctl poweroff ;;
esac
