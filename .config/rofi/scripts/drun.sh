#!/usr/bin/env bash

if xrandr | grep -q "HDMI-A-0 connected"; then
    rofi -show drun -show-icons -config "$HOME/.config/rofi/config-4k.rasi"
else
    rofi -show drun -show-icons -config "$HOME/.config/rofi/config.rasi"
fi
