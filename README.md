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
- [x] aliases
- [x] bash thingies
	- [x] ps1/ps2
- [x] readline/inputrc
- [ ] exports and shell functions
	- [x] colored man pages
	- [x] geolocation
	- [ ] misc
		- [ ] `mkd`
- [x] git and config
	- [x] g shell alias and completion
- [x] tmux and config
- [x] nvim
	- [x] default editor
	- [x] vim aliases?
	- [x] config
	- [x] plugins
		- [x] vimwiki/vimzettel
		- [x] tree-sitter and grammars
		- [x] lsp and language servers
- [x] gnupg
	- [x] use it in git
	- [x] forward key from laptop
- [x] sudo insults
	- [x] missing something, maybe the package needs to be rebuilt: an
	  overlay fixed it
- [x] NTP

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


Later:
- [abstract away](https://nixos.org/manual/nixos/stable/index.html#sec-module-abstractions)
  the geolocation attribute sets
