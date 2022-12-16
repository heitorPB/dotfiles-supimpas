# Configuration for podman
{ config, pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      extraPackages = [ pkgs.zfs ];
    };

    # Rootless podman on ZFS
    containers.storage.settings = {
      storage = {
        driver = "zfs";
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
    };
  };

  # Disable NixOs Containers (conflicts with virtualisation.containers)
  boot.enableContainers = false;

  # Disable firewall, so other machines can access the containers
  networking.firewall.enable = false;

  # Handy packages
  environment.systemPackages = with pkgs; [
    podman
    podman-compose
    podman-tui
  ];
}
