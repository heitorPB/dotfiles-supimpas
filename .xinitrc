#!/bin/bash

# us unternational keyboard, to be able to add accents to letters
setxkbmap us -variant alt-intl

# to reduce mouse sensitivity
#xset m 1/2 1 &

conky -c ~/.config/conky/conkyrc &

eval $(ssh-agent)

#export LIBVA_DRIVER_NAME=vdpau
export LIBVA_DRIVER_NAME=nvidia
export VDPAU_DRIVER=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# network manager systray thing
nm-applet &

# audio sys tray
volumeicon &

# power management for laptop:
mate-power-manager &

# bluetooth applet
blueman-applet &

# to make dunst work
systemctl --user import-environment DISPLAY

# redshift systray thing for nice color temperature black magic
redshift-gtk -l $CURRENT_GEO &

# slstatus
~/projects/slstatus/slstatus &

while true; do
	~/projects/dwm/dwm
done
