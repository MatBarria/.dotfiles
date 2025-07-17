#!/bin/bash

# Check if HDMI-A-0 is connected
if xrandr | grep "HDMI-A-0 connected"; then
  # Enable it and place it to the right of eDP
  xrandr --output HDMI-A-0 --auto --right-of eDP
fi
