{ config, inputs, lib, pkgs, machine, ... }: with lib;
let
  hasSeat = machine.seat != null;
in
{
  imports = [
    ./git.nix
    ./nvim.nix
    ./starship.nix
    ./sway.nix
    ./tmux.nix
    ./gtk-qt.nix
    ./xdg.nix
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
      "gitlab.com" = {
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
      "g3" = {
        hostname = "192.168.1.11";
        user = "h";
        identityFile = machine.identityFile;
      };
      "l14" = {
        hostname = "192.168.1.69";
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
      # Set up bash shell completion for my cool `g = git` alias
      . ${pkgs.git}/share/git/contrib/completion/git-completion.bash
      __git_complete g __git_main
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
        size = 12.0;
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


  # TODO: move this to i3status.nix
  programs.i3status-rust = mkIf (hasSeat) {
    enable = true;
    bars = {
      main = {
        settings = {
          theme.theme = "ctp-mocha"; # Catppuccin FTW!
          icons.icons = "awesome6";
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
            block = "docker";
            interval = 5;
            format = "$icon  $running.eng(w:2)/$total.eng(w:2)";
            socket_path = "/var/run/user/1000/podman/podman.sock";
          }
          {
            # Hardcode tun0 to show vpn network only if it exists.
            # The `missing_format` below takes care of not showing anything if
            # there's no tun0 device.
            block = "net";
            device = "tun";
            format = "$icon  $device  $ip  $ipv6 ";
            missing_format = "";
            interval = 30;
          }
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
            format = "$icon   $utilization.eng(w:4)";
            format_alt = "$icon   $vram_used.eng(w:3,u:B,p:Mi)/$vram_total.eng(w:1,u:B,p:Gi)";
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
            # TODO: format_alt: https://github.com/greshake/i3status-rust/pull/2041
            headphones_indicator = true;
            mappings = {
              # Turn weird output_names into human readable ones
              "alsa_output.pci-0000_07_00.6.analog-stereo" = " "; # L14's analog stereo out
              "bluez_output.78_2B_64_14_F3_96.1" = ""; # Bose NC700, bluetooth out
              "bluez_output.04_CB_88_6F_C2_70.1" = " speaker"; # JBL Go 2 speaker, bluetooth out
            };
          }
          {
            # Microphone
            block = "sound";
            format = "$icon $output_name {$volume.eng(w:4)|}";
            device_kind = "source"; # Microphone is a source
            mappings = {
              "alsa_input.pci-0000_07_00.6.analog-stereo" = " "; # L14's analog stereo in
              "alsa_input.usb-046d_Logitech_BRIO_C8F19D30-03.analog-stereo" = "  Brio"; # Brio Webcam in
              "bluez_input.78:2B:64:14:F3:96" = ""; # Bose NC700, bluetooth mic
              "bluez_input.04:CB:88:6F:C2:70" = " JBL borked"; # JBL Go 2 speaker provides a broken source
            };
          }
          {
            # TODO make this block only if hasBattery, use ssot
            block = "battery";
            format = "$icon   $percentage";
            not_charging_format = "$icon   $percentage";
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

  # TODO: add my btop config here; and add catppuccinNix to it

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
