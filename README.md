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

## Dependencies

Some packages that my dotfiles need or create alias or configure:

- [bash-completion](https://github.com/scop/bash-completion)
- [conky](https://github.com/brndnmtthws/conky)
- [dwm](https://dwm.suckless.org/) compiled in `~/projects/dwm/`
- [feh](https://feh.finalrewind.org)
- git
- gnupg and pinentry
- [maim](https://github.com/naelstrof/maim)
- nvim
- OpenSSH's ssh-agent
- [Redshift](http://jonls.dk/redshift/)
- [slstatus](https://tools.suckless.org/slstatus/) compiled in
  `~/projects/slstatus`
- tmux
- vim
- X11
- [xsel](http://www.vergenet.net/~conrad/software/xsel/)

### laptop specific

- mate-power-manager
- network-manager-applet


## Vim/nvim

Vim should be installed with the attribute `+clipboard`. On ArchLinux it is the
`gvim` package.

I'm experiencing with neovim. Vim might be removed in the future.


## Themes/Fonts

Use Adapta-Nokto theme and noto-fonts. Can be configured with
mate-appearance-settings and or lxappearance.
