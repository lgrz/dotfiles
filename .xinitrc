#!/bin/bash

set -e

# key repeat rate [delay, repeat/second]
xset r rate 200 100
# apply modmap settings
xmodmap .Xmodmap

[ -f "$HOME/.Xresources" ] && xrdb -merge ~/.Xresources

while xsetroot -name "`date +%H:%M` `acpi -b | awk -F'[:,%]' '{printf "%s%%", $3} $2 ~ /Charging/ { print " +"}'` `uptime | sed 's/.*,//'`"
do
	sleep 15
done &
xterm &
xrandr --output LVDS1 --auto --output HDMI1 --auto --right-of LVDS1
exec dwm
