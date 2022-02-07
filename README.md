# dotfiles-supimpas

My supimpa dotfiles :)

## Branches

- `desktop` for my desktop
- `headless` for my server
- `master` for my laptop
- `gersemi` for my new laptop
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
    - [slstatus](https://tools.suckless.org/slstatus/) compiled in `~/projects/slstatus`
    - slock
    - dmenu
- [feh](https://feh.finalrewind.org)
- [fzf](https://github.com/junegunn/fzf/)
- git
- gnupg and pinentry
- [maim](https://github.com/naelstrof/maim)
- nvim
- OpenSSH's ssh-agent
- [Redshift](http://jonls.dk/redshift/)
- [Silver Surfer Searcher (ag)](https://github.com/ggreer/the_silver_searcher)
- tmux
- X11
- [xsel](http://www.vergenet.net/~conrad/software/xsel/)

### laptop specific

- mate-power-manager
- network-manager-applet
- nvidia-xrun >= 0.3.83


## Vim/nvim

Vim should be installed with the attribute `+clipboard`. On ArchLinux it is the
`gvim` package.

I'm experiencing with neovim. Vim might be removed in the future.

### Plugins

Clone the following plugins in
`~/.local/share/nvim/site/pack/PLUGGIN-NAME/start/PLUGIN`:
- [fzf](https://github.com/junegunn/fzf)
- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [vim-zettel](https://github.com/michal-h21/vim-zettel/)
- [vimwiki](https://github.com/vimwiki/vimwiki/)

Then restart neovim and run `:helptags ALL`.

## Themes/Fonts

Use `adapta-gtk-theme` theme and `noto-fonts`. Can be configured with
`lxappearance`.
