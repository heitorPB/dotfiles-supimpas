# dotfiles-supimpas

My Nix configuration files.

## To use

To apply the system configuration as well as user settings:

```bash
$ sudo nixos-rebuild switch --flake .
```

## Project Structure

- `hosts/`: configuration files for each machine and also shared configuration
  between them.
- `home-manager/`: user configurations

## Thanks

The Nix bits from this repo were inspired on:
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/)
- [PedroHLC/system-setup](https://github.com/PedroHLC/system-setup/)

## TODO

Common:
- [ ] encrypt secrets
	- [ ] .ssh/config.d/*

Laptop:
- everything
- [ ] cpufreq
    - [ ] downclock to max of 3GHz
    - [ ] use TLP
- [ ] thermal stuff (sensors/management)
- [ ] graphics
	- [ ] wm - sway? Wayland? i3?
	- [ ] dunst?
	- [ ] color temperature controller - redshift on X
	- [ ] dark theme and fonts
- [ ] audio - pipewire, pavucontrol-qt
- [ ] alacritty
- [ ] ssh
	- [ ] .ssh/config
- [ ] aliases
	- feh and feh-exif
	- screenshot
- [ ] etc


Later:
- [abstract away](https://nixos.org/manual/nixos/stable/index.html#sec-module-abstractions)
  the geolocation attribute sets
- [ ] impermanence
