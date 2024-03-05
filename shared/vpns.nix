# Configure desk03 as a nix remote builder
{ config, pkgs, inputs, lib, machine, ... }:
{
  #overlays = [
  #  (final: prev: {
  #    awsvpnclient = awsvpnclient.packages.${system}.awsvpnclient;
  #  })
  #];
  nixpkgs.overlays = [
    (final: prev: {
      awsvpnclient = inputs.awsvpnclient.packages."x86_64-linux".awsvpnclient;
    })
  ];

  environment.systemPackages = with pkgs; [
    openvpn
    # Helper for OpenVpn <-> Systemd/Resolved
    update-systemd-resolved

    wireguard-tools # TODO make this conditional
  ] ++ (lib.lists.optional (machine.seat != null)
    # Nice plugin for NetworkManager, but only if not headless
    networkmanager-openvpn
  )
  ++ (lib.lists.optional (machine.seat == 2 )
    # AWS custom/proprietary vpn client
    awsvpnclient
  );

  # Need to link to libexec to have update-systemd-resolved
  environment.pathsToLink = [ "/libexec" ];
}
