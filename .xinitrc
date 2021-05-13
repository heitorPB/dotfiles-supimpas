#!/bin/bash

#setxkbmap us,fi,br &

# to reduce mouse sensitivity
#xset m 1/2 1 &

conky -c ~/.config/conky/conkyrc &

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

# slstatus
~/projects/slstatus/slstatus &

while true; do
	~/projects/dwm/dwm
done
