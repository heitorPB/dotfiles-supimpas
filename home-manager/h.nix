{ config, inputs, lib, pkgs, machine, ... }: with lib;
let
  hasSeat = machine.seat != null;
in
{
  imports = [
    ./nvim.nix
    ./starship.nix
    ./xdg.nix
    ./wm-theme.nix
  ];

  # home.packages = with pkgs; [ steam ];

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
    # TODO move ip addresses to SSOT
    # TODO add addresses to resolv.conf
    matchBlocks = {
      "github.com gist.github.com" = {
        hostname = "ssh.github.com";
        user = "git";
        identityFile = machine.identityFile;
      };


      "alien" = {
        hostname = "192.168.1.12";
        user = "h";
        identityFile = machine.identityFile;
      };
      "desk03" = {
        hostname = "192.168.1.70";
        user = "h";
        identityFile = machine.identityFile;
      };
      "gersemi" = {
        hostname = "192.168.1.11";
        user = "h";
        identityFile = machine.identityFile;
      };
      "pfsense" = {
        hostname = "192.168.1.1";
        user = "admin";
        identityFile = machine.identityFile;
      };
    };
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
    signing = mkIf (machine.gitKey != null) {
      key = machine.gitKey;
      signByDefault = true;
      # TODO usse ssh key?
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
      commit = { gpgsign = machine.gitKey != null; };
      core = { editor = "nvim"; };
      diff = { renames = "copies"; };
      fetch = { prune = true; };
      help = { autocorrect = 1; };
      init = { defaultBranch = "main"; };
      merge = { log = 20; tool = "nvimdiff"; conflictStyle = "diff3"; };
      pull = { ff = "only"; rebase = true; };
      rerere = { enabled = true; };
      tag = { gpgsign = machine.gitKey != null; };
    };
  };

  # Export podman socket for rootless mode
  home.sessionVariables = {
    # DOCKER_HOST is needed for docker-compose commands to use my user's socket
    # TODO don't hardcode this, get user id from ssot?
    DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
  };

  # Yeah, I use Bash
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
    '';
    profileExtra = ''
      # Create a new directory and enter it
      function mkd()
      {
      	mkdir --parents "$@" && cd "$_";
      }
    '';
    shellAliases = {
      g = "git";
      # Image viewer: displays filename, tinted to improve readability, verbose, full screen.
      feh = "feh --auto-rotate --draw-filename --draw-tinted -V -F";
      feh-exif = "feh --auto-rotate --draw-filename --draw-exif --draw-tinted -V -F";

      # Separate browsers for work
      pasteur-chrome = "google-chrome-stable --user-data-dir=$HOME/.config/pasteur-chrome/";
    };
    shellOptions = [ "nocaseglob" ]; # Case insensitive interactive ops
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

  programs.alacritty = mkIf (hasSeat) {
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
  # TODO: use https://github.com/catppuccin ?
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
  home.packages = with pkgs; lists.optionals hasSeat [
    swaynotificationcenter # Won't work unless here
  ];
  wayland.windowManager.sway = mkIf (hasSeat) {
    enable = true;
    config = rec {
      modifier = "Mod4"; # A.K.A useless windows key.
      terminal = "alacritty";
      startup = [
        # List of programs to start with Sway
        # Notification daemon
        # https://github.com/catppuccin/swaync
        { command = "${pkgs.swaynotificationcenter}/bin/swaync"; }

        # Volume and Display-brightness OSD
        { command = "${pkgs.avizo}/bin/avizo-service"; }

        ## NetWorkManager Applet: useless, does not work with swaybar :clown-face:
        #{ command = "nm-applet --indicator"; always = true; }
      ];

      defaultWorkspace = "workspace number 1";

      # Setup monitors. Get their names with `swaymsg -t get_outputs`
      output = {
        "*" = {
          # Generic output
          max_render_time = "1";
          # In 60Hz display, "adaptive_sync" makes electron apps laggy
          adaptive_sync = "off";
        };
        "Samsung Electric Company LC49G95T H4ZRA00081" = {
          # Samsung G9 ultra wide
          adaptive_sync = "on";
          mode = "5120x1440@119.999Hz";
        };
        "${machine.seat.displayId}" = with machine.seat; {
          # Machine's monitor
          position = "0,0";
          mode = "${toString displayWidth}x${toString displayHeight}@${toString displayRefresh}Hz";
        };
      };

      fonts = {
        names = [ "Fira Sans Mono" "monospace" ];
        size = 8.0;
      };

      window = {
        titlebar = false;
        hideEdgeBorders = "both"; # Hide window borders adjacent to screen edges

        commands = [
          # Set some programs as floating
          { criteria = { app_id = "firefox"; title = "Picture-in-Picture"; }; command = "floating enable; sticky enable"; }

          # Don't lock my screen if there is anything fullscreen, I may be gaiming/watching
          { criteria = { shell = ".*"; }; command = "inhibit_idle fullscreen"; }
        ];
      };

      floating.criteria = [
        { app_id = "anki"; }
        { app_id = "klavaro"; }
        { app_id = "org.keepassxc.KeePassXC"; }
        { app_id = "pavucontrol-qt"; }
      ];

      keybindings = mkOptionDefault ({
        # The missing workspace
        "${modifier}+0" = "workspace 0";
        "${modifier}+Shift+0" = "move container to workspace 0";

        # Audio controls
        "XF86AudioRaiseVolume" = "exec ${pkgs.avizo}/bin/volumectl -d -u up";
        "XF86AudioLowerVolume" = "exec ${pkgs.avizo}/bin/volumectl -d -u down";
        "XF86AudioMute" = "exec ${pkgs.avizo}/bin/volumectl -d toggle-mute";
        "XF86AudioMicMute" = "exec ${pkgs.avizo}/bin/volumectl -d -m toggle-mute";

        # Display backlight controls
        "XF86MonBrightnessUp" = "exec ${pkgs.avizo}/bin/lightctl -d up";
        "XF86MonBrightnessDown" = "exec ${pkgs.avizo}/bin/lightctl -d down";
      });


      bars = [{
        fonts = {
          #names = [ "Font Awesome 5 Free" ];
          names = [ "FiraCode Sans Mono" ];
          size = 12.0;
        };
        #trayOutput = "*";
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-main.toml";
        colors = {
          # From https://github.com/catppuccin/i3
          background = "#1e1e2e";
          separator = "#89b4fa";
          statusline = "#cdd6f4";
          focusedWorkspace = { background = "#1e1e2e"; border = "#1e1e2e"; text = "#a6e3a1"; };
          activeWorkspace = { background = "#1e1e2e"; border = "#1e1e2e"; text = "#89b4fa"; };
          inactiveWorkspace = { background = "#1e1e2e"; border = "#1e1e2e"; text = "#45475a"; };
          urgentWorkspace = { background = "#1e1e2e"; border = "#fab387"; text = "#a6e3a1"; }; # My only customization
        };
      }];

      input = {
        # Keyboard settings. TODO: make it configurable
        "*" = {
          xkb_layout = "br";
          #xkb_variant = "abnt2";
          xkb_model = "thinkpad";
        };
        "10730:258:Kinesis_Advantage2_Keyboard" = {
          xkb_layout = "us(alt-intl)";
          xkb_model = "kinesis";
        };
        # TODO: add touchpad if it exists
      };
    };
  };

  # TODO: move this to i3status.nix
  programs.i3status-rust = mkIf (hasSeat) {
    enable = true;
    bars = {
      main = {
        settings = {
          theme.theme = "ctp-mocha"; # Catppuccin FTW!
          icons.icons = "awesome5";
        };
        blocks = [
          #{
          #  block = "toggle";
          #  format = " $icon";
          #  command_state = "${nmcli} radio wifi | ${grep} '^d'";
          #  command_on = "${nmcli} radio wifi off";
          #  command_off = "${nmcli} radio wifi on";
          #  interval = 5;
          #}
          {
            # Hardcode wlan0 to show wireless network only if it exists.
            # The `missing_format` below takes care of not showing anything if
            # there's no wlan0 device.
            # TODO: move this to ssot
            block = "net";
            device = "wlan0";
            format = "$icon   $ssid ($signal_strength.eng(w:4))";
            missing_format = "";
            interval = 5;
          }
          {
            # Net up/down speed
            block = "net";
            device = machine.mainNetworkInterface;
            format = "^icon_net_down  $speed_down.eng(w:4,prefix:K)  ^icon_net_up  $speed_up.eng(w:4,prefix:K)";
            format_alt = " $ip  $ipv6";
            missing_format = "";
            interval = 5;
          }
          {
            block = "cpu";
            interval = 2;
            format = "$icon  $utilization.eng(w:4) ($frequency.eng(w:3))";
          }
        ] ++ (lists.optional (machine.cpuSensor != null)
          {
            block = "temperature";
            format = "$icon $max";
            good = 40;
            idle = 50; # Above this temp, bg gets blue
            info = 65; # Above this temp, bg gets yellow
            warning = 80; # Above this temp, bg gets red
            chip = machine.cpuSensor;
            interval = 5;
          }
        ) ++ (lists.optional (machine.amdGpu != null)
          {
            # GPU utilization
            # NOTE: if this block crashes, check card number in /sys/class/drm/
            #       and update ssot if needed
            block = "amd_gpu";
            device = machine.amdGpu;
            # TODO define format without trailing space
            format = "$icon  $utilization.eng(w:4)";
            format_alt = "$icon $vram_used.eng(w:3,u:B,p:Mi)/$vram_total.eng(w:1,u:B,p:Gi)";
            interval = 2;
          }
        ) ++ [
          {
            # Screen brightness
            block = "backlight";
            format = "$icon $brightness.eng(w:4)";
            invert_icons = true; # Needed due to dark theme
            minimum = 1;
            cycle = [ 25 50 75 100 ];
          }
          #{
          #  # i3status-rs is buggy with gammastep :(
          #  # https://github.com/greshake/i3status-rust/issues/1397
          #  block = "hueshift"; # Screen temperature
          #  step = 50;
          #  click_temp = 4000;
          #}
        ] ++ (lists.optional (machine.gpuSensor != null)
          {
            block = "temperature";
            format = "$icon $max";
            good = 40;
            idle = 50; # Above this temp, bg gets blue
            info = 65; # Above this temp, bg gets yellow
            warning = 80; # Above this temp, bg gets red
            chip = machine.gpuSensor;
            interval = 5;
          }
        ) ++ [
          {
            block = "memory";
            interval = 2;
            format = "$icon  $mem_used.eng(w:3,u:B,p:Gi)/$mem_total.eng(w:2,u:B,p:Gi) ($mem_used_percents.eng(w:4))";
            format_alt = "$icon_swap $swap_used.eng(w:2,u:B,p:Gi)/$swap_total.eng(w:2,u:B,p:Gi) ($swap_used_percents.eng(w:1))";
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
        ] ++ (map
          (sensor: {
            block = "temperature";
            format = "$icon $max";
            chip = sensor;
            interval = 3;
            idle = 37;
            info = 41;
            warning = 44;
          })
          machine.nvmeSensors
        ) ++ [
          {
            # Output volume
            block = "sound";
            format = "$icon $output_name {$volume.eng(w:4)|}";
            headphones_indicator = true;
            mappings = { # Turn weird output_names into human readable ones
              "bluez_output.78_2B_64_14_F3_96.1" = ""; # Bose NC700, bluetooth out
              "alsa_output.pci-0000_07_00.6.analog-stereo" = ""; # L14's analog stereo out
            };
          }
          {
            # Microphone
            block = "sound";
            format = "$icon $output_name {$volume.eng(w:4)|}";
            device_kind = "source"; # Microphone is a source
            mappings = {
              "bluez_input.78:2B:64:14:F3:96" = ""; # Bose NC700, bluetooth mic
              "alsa_input.pci-0000_07_00.6.analog-stereo" = ""; # L14's analog stereo in
              "alsa_input.usb-046d_Logitech_BRIO_C8F19D30-03.analog-stereo" = ""; # Webcam
            };
          }
          {
            # TODO make this block only if hasBattery, use ssot
            block = "battery";
            format = "$icon $percentage";
            interval = 5;
            device = machine.battery;
          }
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
  services.gammastep = mkIf (hasSeat) {
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

  programs.mpv = mkIf hasSeat {
    enable = true;
    # For watching animes in 60fps
    config = {
      # Temporary & lossless screenshots
      screenshot-format = "png";
      screenshot-directory = "/tmp";
      # for Pipewire (Let's pray for MPV native solution)
      #ao = "openal";
      # I don't usually plug my PC in a home-theater
      audio-channels = "stereo";

      # GPU & Wayland
      hwdec = "vaapi";
      vo = "gpu";
      gpu-context = "waylandvk";
      gpu-api = "vulkan";

    };
    bindings = {
      # Subtitle scalers
      "P" = "add sub-scale +0.1";
      "Ctrl+p" = "add sub-scale -0.1";

      # Window helpers
      "Alt+3" = "set window-scale 0.5";
      "Alt+4" = "cycle border";
    };
  };


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
