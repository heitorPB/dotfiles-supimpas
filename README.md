# dotfiles-supimpas

My Nix configuration files.

## To use

```bash
$ sudo nixos-rebuild switch --flake .
```

## Project Structure

- `hosts/`: configuration files for each machine and also shared configuration
  between them.
- `home-manager/`: user configurations

## TODO

Common:
- [ ] aliases
- [ ] bash thingies
- [ ] exports and shell functions
	- [X] colored man pages
	- [ ] geolocation
- [ ] git and config
- [ ] readline/inputrc
- [ ] tmux and config
- [ ] ssh
	- .ssh/config
- [ ] nvim
	- [x] default editor
	- [x] vim aliases?
	- [ ] plugins and config
- [ ] ps1/ps2
- [ ] gnupg
- [ ] sudo insults

Laptop:
- everything
- wm
- dark theme and fonts
- alacritty
- dunst
