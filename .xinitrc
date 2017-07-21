#!/bin/bash

set -xe

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
output=$(xrandr | awk 'NR > 2 && $2 ~ /^connected/ { print $1 }')
xrandr --output LVDS1 --auto --output ${output:-"HDMI1"} --auto --right-of LVDS1
xautolock -time 10 -locker slock &
exec dwm
