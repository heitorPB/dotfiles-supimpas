#!/bin/bash

setxkbmap br &

# to reduce mouse sensitivity
#xset m 1/2 1 &

conky -c ~/.config/conky/conkyrc &
 
xrdb -merge ~/.config/UrxvtColors &

eval $(ssh-agent)

export LIBVA_DRIVER_NAME=vdpau

nm-applet &

while [ 1 ]; do xsetroot -name "$(date "+%a %b %H:%M:%S %Z %F")"; sleep 30; done &
exec ~/projects/dwm/dwm
