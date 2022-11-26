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
- [ ] aliases
- [ ] bash thingies
- [ ] exports and shell functions
	- [X] colored man pages
	- [ ] geolocation
- [x] git and config
- [ ] readline/inputrc
- [ ] tmux and config
- [ ] ssh
	- .ssh/config
- [ ] nvim
	- [x] default editor
	- [x] vim aliases?
	- [x] config
	- [ ] plugins
		- [ ] vimwiki/vimzettel
		- [ ] tree-sitter and grammars
		- [ ] lsp and language servers
- [ ] ps1/ps2
- [ ] gnupg
	- [ ] use it in git
- [ ] sudo insults

Laptop:
- everything
- wm
- dark theme and fonts
- alacritty
- dunst
