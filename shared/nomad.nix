# Configuration for Nomad
{ lib, config, pkgs, ... }:
let
  # This causes an infinite recursion :(
  #dockerEnabled = config.virtualisation.docker.enable;
  dockerEnabled = false;
in
{
  services.nomad = {
    enable = true;
    package = pkgs.nomad_1_7;

    # Add extra plugins to Nomad's plugin directory.
    extraSettingsPlugins = [ pkgs.nomad-driver-podman ];
    # Add Docker driver
    enableDocker = dockerEnabled;

    # Nomad as Root to access Docker/Podman sockets.
    dropPrivileges = false;

    # Nomad configuration, as Nix attribute set.
    settings = {
      client.enabled = true;
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
      plugin = [{
        nomad-driver-podman = {
          config = { };
        };
      }];
    };
  };

  # I Don't want Nomad starting when the system boots
  systemd.services.nomad.wantedBy = lib.mkForce [ ];

  # Handy packages
  environment.systemPackages = with pkgs; [
    nomad-driver-podman # Podman driver plugin
    cni-plugins # Networking plugins, needed for bridge. Migh not be needed?

    damon # TUI for Nomad
  ];
}
