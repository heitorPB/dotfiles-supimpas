{ pkgs, lib, ... }:
let
  hasSeat = seat != null;
in
{
  wayland.windowManager.sway = lib.mkIf (hasSeat) {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
  };
}
