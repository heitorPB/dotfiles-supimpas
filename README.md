# Dotfiles Supimpas

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
