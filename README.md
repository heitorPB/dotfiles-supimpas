# dotfiles-supimpas

My Nix configuration files.

## To use

```bash
$ sudo nixos-rebuild switch --flake .
```

## Project Structure

- `hosts/`: configuration files for each machine and also shared configuration
  between them.

## TODO

Common:
- ssh
	- .ssh/config
- nvim
	- default editor
	- vim aliases?
	- plugins and config
- git and config
- tmux and config
- aliases and shell functions
- ps1/ps2
- gnupg
- sudo insults
- colored man pages

Laptop:
- everything
- wm
- dark theme
