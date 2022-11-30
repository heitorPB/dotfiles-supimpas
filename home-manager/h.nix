{ gitKey ? null }:
{ config, inputs, lib, pkgs, ... }: with lib; {
  imports = [ ./nvim.nix ];

  # home.packages = with pkgs; [ steam ];

  # Configuration for git
  programs.git = {
    enable = true;
    userName = "Heitor Pascoal de Bittencourt";
    userEmail = "heitorpbittencourt@gmail.com";
    signing = mkIf (gitKey != null) {
      key = gitKey;
      signByDefault = true;
    };
    aliases = {
      # List aliases
      alias = "! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ / | grep -v ^'alias '";

      # Nice looking git log --graph
      l = "log --graph --decorate --pretty=format:'%C(blue)%d%Creset %C(yellow)%h%Creset %s, %C(bold green)%an%Creset, %C(green)%cd%Creset' --date=relative -n 20";
      graph = "log --graph --decorate --pretty=format:'%C(blue)%d%Creset %C(yellow)%h%Creset %s, %C(bold green)%an%Creset, %C(green)%cd%Creset' --date=relative --all";

      # Find commits by commit message ('log --grep') in "short mode"
      lg = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f";
      # Find commits by source code a.k.a 'find code'
      fc = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f";

      # View the current working tree status using the short format
      s = "status -s";

      # Commit staged changes
      c = "commit --verbose";
      # Commit all changes
      ca = "commit --all --verbose";

      # Show diff
      d = "diff --no-pager --patch-with-stat";

      # Change date of last commit to now
      now = "commit --ammend --date=now";

      # Show verbose output about tags, branches or remotes
      tags = "tag -l";
      branches = "branch -a";
      remotes = "remote -v";

      # List contributors with number of commits
      contributors = "shortlog --summary --numbered";

      # Remove branches that have already been merged with master a.k.a. ‘delete merged’
      dm = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";
    };
    extraConfig = {
      commit = { gpgsign = gitKey != null; };
      core = { editor = "nvim"; };
      diff = { renames = "copies"; };
      fetch = { prune = true; };
      help = { autocorrect = 1; };
      init = { defaultBranch = "main"; };
      merge = { log = 20; tool = "nvimdiff"; };
      pull = { ff = "only"; rebase = true; };
      rerere = { enabled = true; };
      tag = { gpgsign = gitKey != null; };
    };
  };

  # Write the Tmux configuration file directly. Not a big fan of having this global
  home.file.".tmux.conf".text = ''
    # Normalize TERM variable
    set -g default-terminal "screen-256color"

    # Full color range
    set-option -ga terminal-overrides ",*256col*:RGB,alacritty:RGB"

    # Rebind main key to C-a
    unbind C-b
    set -g prefix C-a
    bind b send-prefix
    bind C-b last-window

    # Force a reload of the config file with C-<prefix> r
    unbind r
    bind r source-file ~/.tmux.conf \; display-message "Config reloaded"

    # Enable clicking around
    set -g mouse on

    # Pane movement shortcuts - same as Vi
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
    bind -r H resize-pane -L 10
    bind -r J resize-pane -D 10
    bind -r K resize-pane -U 10
    bind -r L resize-pane -R 10

    # Use 24 hour clock
    setw -g clock-mode-style 24

    # Quick pane cycling
    # TODO what is this for?
    unbind ^A
    bind ^A select-pane -t :.+

    # Renumber windows when one is closed
    set -g renumber-windows on

    # Make splits open in the current dir
    unbind %
    bind % split-window -h -c "#{pane_current_path}"
    unbind \"
    bind \" split-window -v -c "#{pane_current_path}"

    # Reduce escape-time to be uniform with neovim
    # cf. https://github.com/neovim/neovim/issues/2035
    set-option -sg escape-time 10

    # Set focus-events for better nvim-tmux integration
    set-option -g focus-events on
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
