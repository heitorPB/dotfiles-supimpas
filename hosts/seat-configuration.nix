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
    wireless.iwd.enable = true;

    # Disable non-NetworkManager.
    useDHCP = false;
  };

  # XWayland keyboard layout.
  services.xserver.layout = "br";
  # Console keyboard layout.
  console.keyMap = "br-abnt2";
}
