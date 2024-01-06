# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ssot, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Microcode updates.
  hardware.cpu.intel.updateMicrocode = true;

  networking = {
    # required for zfs. From head -c 8 /etc/machine-id
    hostId = "fe1f23b8";
    hostName = ssot.desktop.hostname;
    interfaces.enp3s0.wakeOnLan.enable = true;
    nameservers = [ "192.168.1.1" "2804:431:cfcf:a985:3af7:cdff:fec1:c006" ];
  };

  # Machine specific packages
  environment.systemPackages = with pkgs; [
    openvpn
    # Helper for OpenVpn <-> Systemd/Resolved
    update-systemd-resolved
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
