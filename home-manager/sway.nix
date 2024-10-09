{ pkgs, lib, machine, ... }: with lib;
let
  hasSeat = machine.seat != null;
in
{
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

        # External monitors need to be manually set up here
        "Samsung Electric Company LC49G95T H4ZRA00081" = {
          # Samsung G9 ultra wide
          adaptive_sync = "on"; # TODO move this SSOT
          mode = "5120x1440@119.999Hz";
        };

        # Machine specific monitor
        "${machine.seat.displayId}" = with machine.seat; {
          # Machine's monitor
          position = "0,0";
          adaptive_sync = "on"; # TODO move this SSOT
          mode = "${toString displayWidth}x${toString displayHeight}@${toString displayRefresh}Hz";
        };
      };

      fonts = {
        names = [ "Fira Sans Mono" "monospace" ];
        size = 10.0;
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
        { app_id = ".blueman-manager-wrapped"; }
        { app_id = "anki"; }
        { app_id = "org.keepassxc.KeePassXC"; }
        { title = "Volume Control"; } # For pavucontrol
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
        # Keyboard settings. Check xkeyboard-config(7) for layouts, models and
        # variants
        "*" = {
          xkb_layout = "br";
          #xkb_variant = "abnt2";
          xkb_model = "thinkpad";
        };

        "10730:258:Kinesis_Advantage2_Keyboard" = {
          xkb_layout = "us(alt-intl)";
          xkb_model = "kinesis";
        };

        # G3 and L14 laptop Keyboard have the same identifier :(
        "1:1:AT_Translated_Set_2_keyboard" = {
          #xkb_layout = "us(alt-intl)";
          xkb_layout = "br(thinkpad)";
        };
      };
    };
  };
}
