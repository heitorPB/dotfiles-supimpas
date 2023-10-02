# Configuration for podman, using crun as OCI runtime (default)
# TODO: Update mywiki if this file is changed.
{ config, pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true; # For docker alias
      dockerSocket.enable = true;
      extraPackages = [ pkgs.zfs ];
      defaultNetwork.settings.dns_enabled = true;
    };

    # Rootfull Podman on ZFS
    # Rootless does not use ZFS :(
    containers.storage.settings = {
      storage = {
        driver = "zfs";
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
      storage.options.zfs = {
        fsname = "zroot/containers";
        mountopt = "nodev";
      };
    };

    # Change log-driver from journald to k8s-file (alias for json)
    #containers.containersConf.settings = {
    #  containers = {
    #    log_driver = "k8s-file";
    #    events_logger = "file";
    #  };
    #};
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
