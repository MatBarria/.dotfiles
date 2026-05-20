#!/usr/bin/env bash

# 1. Terminate already running bar instances
# Try graceful shutdown first via IPC
polybar-msg cmd quit 2>/dev/null

# Fallback: wait until all Polybar processes are completely dead
while pgrep -u $UID -x polybar >/dev/null; do 
    sleep 0.1
done

# 2. Configure displays and DPI
HDMI="HDMI-A-0"
LAPTOP="eDP"

if xrandr | grep -q "$HDMI connected"; then
    # Monitor externo 4K
    xrandr \
        --output "$HDMI" --primary --mode 3840x2160 --rate 60 \
        --output "$LAPTOP" --auto --right-of "$HDMI"

    echo "Xft.dpi: 144" | xrdb -merge

    POLYBAR_CONFIG="$HOME/.config/polybar/config-4k.ini"
else
    # Solo laptop 1080p
    xrandr \
        --output "$LAPTOP" --primary --mode 1920x1080 \
        --output "$HDMI" --off

    echo "Xft.dpi: 96" | xrdb -merge

    POLYBAR_CONFIG="$HOME/.config/polybar/config-1080.ini"
fi

sleep 0.5

# 4. Launch bar with logging
echo "---" | tee -a /tmp/polybar.log

# Launch the bar using your specific config file, log output, and detach from script
polybar -c "$POLYBAR_CONFIG" example 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
