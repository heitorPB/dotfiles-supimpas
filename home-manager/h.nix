{ gitKey ? null /* GPG key to use */
, seat ? null /* Do we have wayland? */
}:
{ config, inputs, lib, pkgs, ssot, machine, ... }: with lib; {
  imports = [
    ./nvim.nix
    ./starship.nix
  ];

  # home.packages = with pkgs; [ steam ];

  # Configuration for gpg and its agent
  programs.gpg = {
    enable = true;
    publicKeys = [
      { source = ./heitor.asc; trust = 5; }
    ];
  };
  home.file.".gnupg/gpg-agent.conf".text = ''
    no-autostart
  '';

  # Configuration for SSH client
  programs.ssh = {
    enable = true;
    compression = true;
    # Periodic ping to keep the connection alive
    serverAliveInterval = 240;
    # Only use the keys informed for each host
    extraConfig = "IdentitiesOnly yes";
    # Include all extra configuration in ~/.ssh/config.d/*
    includes = [ "config.d/*" ];
  };

  # Direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };

  # Configuration for git
  programs.git = {
    enable = true;
    userName = "Heitor Pascoal de Bittencourt";
    userEmail = "heitorpbittencourt@gmail.com";
    signing = mkIf (gitKey != null) {
      key = gitKey;
      signByDefault = true;
    };
    ignores = [
      # Direnv stuff
      ".direnv/"
    ];
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
      now = "commit --amend --date=now";

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
      merge = { log = 20; tool = "nvimdiff"; conflictStyle = "diff3"; };
      pull = { ff = "only"; rebase = true; };
      rerere = { enabled = true; };
      tag = { gpgsign = gitKey != null; };
    };
  };
  # My git alias:
  programs.bash.shellAliases.g = "git";

  # Export podman socket for rootless mode
  home.sessionVariables = {
    # DOCKER_HOST is needed for docker-compose commands to use my user's socket
    # TODO don't hardcode this, get user id from ssot?
    DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
  };

  # Yeah, I use Bash
  programs.bash = {
    enable = true;
    shellOptions = [ "nocaseglob" ];
    profileExtra = ''
      # Create a new directory and enter it
      function mkd()
      {
      	mkdir --parents "$@" && cd "$_";
      }
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
    '';
  };

  programs.alacritty = mkIf (seat != null) {
    enable = true;
    settings = mkOptionDefault {
      font = {
        normal = {
          family = "Borg Sans Mono";
        };
        size = 11.0;
      };

      #window.opacity = 0.9;

      #shell = {
      #  program = "${fish}";
      #  args = [ "--login" ];
      #};

      colors = {
        primary = {
          background = "#161821";
          foreground = "#d2d4de";
        };
        normal = {
          black = "#161821";
          red = "#e27878";
          green = "#b4be82";
          yellow = "#e2a478";
          blue = "#84a0c6";
          magenta = "#a093c7";
          cyan = "#89b8c2";
          white = "#c6c8d1";
        };
        bright = {
          black = "#6b7089";
          red = "#e98989";
          green = "#c0ca8e";
          yellow = "#e9b189";
          blue = "#91acd1";
          magenta = "#ada0d3";
          cyan = "#95c4ce";
          white = "#d2d4de";
        };
      };
    };
  };

  # TODO: move this to a tmux.nix
  # Write the Tmux configuration file directly. Not a big fan of having this global
  home.file.".tmux.conf".text = ''
    # Normalize TERM variable
    set -g default-terminal "screen-256color"

    # Full color range
    set-option -ga terminal-overrides ",*256col*:Tc,alacritty:Tc"

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

  # TODO: move this to a sway.nix
  wayland.windowManager.sway = mkIf (seat != null) {
    enable = true;
    config = rec {
      modifier = "Mod4"; # A.K.A useless windows key.
      terminal = "alacritty";
      startup = [
        # NetWorkManager Applet on start: useless, does not work with swaybar :clown-face:
        { command = "nm-applet --indicator"; always = true; }
      ];

      bars = [{
        fonts = {
          names = [ "Font Awesome 5 Free" ];
          size = 12.0;
        };
        #trayOutput = "*";
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-main.toml";
        colors = {
          separator = "#666666";
          background = "#222222dd";
          statusline = "#dddddd";
          focusedWorkspace = { background = "#0088CC"; border = "#0088CC"; text = "#ffffff"; };
          activeWorkspace = { background = "#333333"; border = "#333333"; text = "#ffffff"; };
          inactiveWorkspace = { background = "#333333"; border = "#333333"; text = "#888888"; };
          urgentWorkspace = { background = "#2f343a"; border = "#900000"; text = "#ffffff"; };
        };
      }];

      input = {
        # Keyboard settings. TODO: make it configurable
        "*" = { xkb_layout = "br"; xkb_variant = "abnt2"; xkb_model = "thinkpad"; };
        # TODO: add touchpad if it exists
      };
    };
  };

  # TODO: move this to i3status.nix
  programs.i3status-rust = mkIf (seat != null) {
    enable = true;
    bars = {
      main = {
        settings = {
          theme.theme = "solarized-dark";
          icons.icons = "awesome5";
        };
        blocks = [
          {
            block = "cpu";
            interval = 2;
            format = "$icon $utilization ($frequency.eng(w:1))";
            # TODO: add CPU/GPU temperature
          }
          {
            block = "memory";
            interval = 2;
            format = "$icon $mem_used/$mem_total ($mem_used_percents.eng(w:1))";
            format_alt = "$icon_swap $swap_used.eng(w:3,u:B,p:Mi)/$swap_total.eng(w:3,u:B,p:Mi) ($swap_used_percents.eng(w:1))";
            warning_mem = 75;
            critical_mem = 90;
          }
          {
            block = "disk_space";
            interval = 20;
            format = "$icon $available";
            path = "/";
            warning = 20.0;
            alert = 10.0;
          }
          { block = "sound"; }
          {
            block = "sound";
            device_kind = "source"; # Microphone is a source
          }
          {
            block = "battery";
            interval = 5;
          }
          #{
          #  # i3status-rs is buggy with gammastep :(
          #  # https://github.com/greshake/i3status-rust/issues/1397
          #  block = "hueshift"; # Screen temperature
          #  step = 50;
          #  click_temp = 4000;
          #}
          {
            block = "time";
            interval = 1;
            format = "$icon $timestamp.datetime(f:'%a %b %d %H:%M:%S %:::z')";
          }
        ];
      };
    };
  };

  # Screen temperature
  services.gammastep = mkIf (seat != null) {
    enable = true;
    provider = "manual";
    temperature.day = 5500;
    temperature.night = 4500;
    latitude = machine.location.latitude;
    longitude = machine.location.longitude;
    settings = {
      general = {
        adjustment-method = "wayland";
        brightness-night = 0.8;
        gamma-night = 0.9;
        location-provider = "manual";
      };
    };
  };

  # TODO: add my btop config here, only if has seat?

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
