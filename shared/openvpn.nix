# Setup OpenVPN
{
  pkgs,
  lib,
  machine,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      openvpn
      # Helper for OpenVpn <-> Systemd/Resolved
      update-systemd-resolved
    ]
    ++ (
      lib.lists.optional (machine.seat != null)
      # Nice plugin for NetworkManager, but only if not headless
      networkmanager-openvpn
    );

  # Need to link to libexec to have update-systemd-resolved
  environment.pathsToLink = ["/libexec"];
}
