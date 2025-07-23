#!/bin/bash

# Check if HDMI-A-0 is connected
if xrandr | grep "HDMI-A-0 connected"; then
      xrandr --output HDMI-A-0 --primary --auto --output eDP --auto --right-of HDMI-A-0
fi
