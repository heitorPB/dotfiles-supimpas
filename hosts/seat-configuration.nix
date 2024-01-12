# General Configuration for GUI systems
{ lib, pkgs, ssot, ... }: with ssot;

{
  # Network (NetworkManager).
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      dns = "systemd-resolved";
    };

    # Disable non-NetworkManager.
    useDHCP = false;
  };

  # GPU
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # XDG-Portal (for dialogs & screensharing).
  xdg.portal.wlr.enable = true;

  # Packages for machines with a seat
  environment.systemPackages = with pkgs; [
    alacritty # Terminal emulator

    networkmanagerapplet # NetworkManager Systray

    firefox-bin # Could not get a cache miss :(
  ];
}
