# dotfiles-supimpas

My supimpa dotfiles :)

## Branches

- `desktop` for my desktop
- `master` for my laptop
- `raspberrypi` for my Raspberry Pi

## Installation

Checkout the branch you need and run the bootstrap script:

```bash
sh bootstrap.sh
```

**NOTE**: launch `vim` and run `:PluginInstall` the first time.

## Dependencies

Some packages that my dotfiles need or create alias or configure:

- [bash-completion](https://github.com/scop/bash-completion)
- [feh](https://feh.finalrewind.org)
- vim
  - [vundle](https://github.com/VundleVim/Vundle.vim)


## Vim

Vim should be installed with the attribute `+clipboard`. On ArchLinux it is the
`gvim` package. Also, you should install Vundle manually.
