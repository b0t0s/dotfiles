#!/usr/bin/env bash
# ~/.config/polybar/scripts/fancontrol.sh
# - With --status: only display current fan speed
# - Without args: toggle between 100% and 50%, then display updated speed

get_speed() {
  nbfc status 2>/dev/null \
    | awk '/Target Fan Speed/ { gsub(/.*:[ \t]*/, ""); sub(/\..*/, ""); print; exit }'
}

# If called with --status, print speed only
if [ "$1" = "--status" ]; then
  speed=$(get_speed)
  [ -z "$speed" ] && speed="--"
  echo " ${speed}%"
  exit 0
fi

# No args: toggle speed
speed=$(get_speed)
# Toggle logic: if >90, set to 50; else set to 100
if [ "$speed" -gt 90 ]; then
  nbfc set -s 50
else
  nbfc set -s 100
fi

new_speed=$(get_speed)
[ -z "$new_speed" ] && new_speed="--"
echo " ${new_speed}%"

