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
      d = "!git --no-pager diff --patch-with-stat";

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
  # My git alias:
  programs.bash.shellAliases.g = "git";

  # Yeah, I use Bash
  programs.bash = {
    enable = true;
    shellOptions = [ "nocaseglob" ];
    profileExtra = (builtins.readFile ./ps1.sh) + ''
      # Autocomplete g alias
      if [ -f "${pkgs.git}/share/bash-completion/completions/git" ]; then
              . "${pkgs.git}/share/bash-completion/completions/git" && __git_complete g __git_main
      fi
    '';
  };

  # Some magical Readline configuration
  programs.readline = {
    enable = true;
    extraConfig = ''
      # Use VI style
      set editing-mode vi

      # Moving between words with Ctrl+Left and Ctrl+Right
      "\e[1;5D": backward-word
      "\e[1;5C": forward-word

      # Fix a weird bug. See ArchWiki about Readline
      $if mode=vi
      set keymap vi-command
      # these are for vi-command mode
      "\e[A": history-search-backward
      "\e[B": history-search-forward
      set keymap vi-insert
      # these are for vi-insert mode
      "\e[A": history-search-backward
      "\e[B": history-search-forward
      $endif

      # Make Tab autocomplete regardless of filename case
      set completion-ignore-case on

      # List all matches in case multiple possible completions are possible
      set show-all-if-ambiguous on

      # Immediately add a trailing slash when autocompleting symlinks to directories
      set mark-symlinked-directories on

      # Use the text that has already been typed as the prefix for searching through
      # commands (i.e. more intelligent Up/Down behavior)
      "\e[B": history-search-forward
      "\e[A": history-search-backward

      # Do not autocomplete hidden files unless the pattern explicitly begins with a dot
      set match-hidden-files off

      # Show all autocomplete results at once
      set page-completions off

      # If there are more than 200 possible completions for a word, ask to show them all
      set completion-query-items 200

      # Show extra file information when completing, like `ls -F` does
      set visible-stats on

      # Be more intelligent when autocompleting by also looking at the text after
      # the cursor. For example, when the current line is "cd ~/src/mozil", and
      # the cursor is on the "z", pressing Tab will not autocomplete it to "cd
      # ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
      # Readline used by Bash 4.)
      set skip-completed-text on

      # Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
      set input-meta on
      set output-meta on
      set convert-meta off

      # Use Alt/Meta + Delete to delete the preceding word
      "\e[3;3~": kill-word
    '';
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
