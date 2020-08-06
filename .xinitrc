#!/bin/bash

set -xe

. /etc/X11/Xsession.d/20dbus_xdg-runtime

# key repeat rate [delay, repeat/second]
xset r rate 200 100
# apply modmap settings
xmodmap .Xmodmap

[ -f "$HOME/.Xresources" ] && xrdb -merge ~/.Xresources

status() {
  date=$(date "+%a, %d %b  %H:%M")
  battery=$(acpi -b | awk -F'[:,%]' '{printf "%s%%", $3} $2 ~ /Charging/ { print " +"}')
  load_avg=$(uptime | sed 's/.*,//')
  volume=$(pactl list sinks | grep -E '^\s+Volume:' | awk '{print $5}')
  mute=$(pactl list sinks | grep 'Mute' | awk '{print $2}')
  if [ "$mute" = "yes" ]; then
      volume="mute"
  fi
}

status
while xsetroot -name "$battery  $volume $load_avg  $date "
do
	sleep 15
    status
done &

xterm &
output=$(xrandr | awk 'NR > 2 && $2 ~ /^connected/ { print $1 }')
xrandr --output LVDS-1 --auto --output ${output:-"HDMI-1"} --auto --right-of LVDS-1
xautolock -time 10 -locker slock -detectsleep -notify 60 -notifier "notify-send -t 120 -- 'screen lock (60)'" &
xss-lock slock &
exec dwm
