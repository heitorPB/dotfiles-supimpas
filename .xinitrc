#!/bin/bash

setxkbmap fi,br &

# to reduce mouse sensitivity
#xset m 1/2 1 &

conky -c ~/.config/conky/conkyrc &
 
xrdb -merge ~/.config/Xresources

eval $(ssh-agent)

export LIBVA_DRIVER_NAME=vdpau

# network manager systray thing
nm-applet &

# power management for laptop:
mate-power-manager &

# to make dunst work
systemctl --user import-environment DISPLAY

# redshift systray thing for nice color temperature black magic
redshift-gtk -l $CURRENT_GEO &

while [ 1 ]; do xsetroot -name "$(date "+%a %b %H:%M:%S %Z %F")"; sleep 30; done &
exec ~/projects/dwm-6.1/dwm
