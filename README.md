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
- [ ] cpufreq
- [ ] thermal stuff (sensors/management)

Laptop:
- everything
- [ ] audio - pipewire, pavucontrol-qt
- [ ] graphics
	- [ ] wm - sway? Wayland?
	- [ ] dunst?
	- [ ] color temeprature controller - redshift on X
	- [ ] dark theme and fonts
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
