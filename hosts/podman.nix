# Configuration for podman, using crun as OCI runtime (default)
# TODO: Update mywiki if this file is changed.
{ config, pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      extraPackages = [ pkgs.zfs ];
      defaultNetwork.dnsname.enable = true;
    };

    # Rootless podman on ZFS
    containers.storage.settings = {
      storage = {
        driver = "zfs";
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
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
