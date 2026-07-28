# Configuration for podman, using crun as OCI runtime (default)
# TODO: Update mywiki if this file is changed.
{
  config,
  pkgs,
  ...
}: let
  dockerEnabled = config.virtualisation.docker.enable;
in {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = !dockerEnabled; # For docker aliases
      dockerSocket.enable = !dockerEnabled;
      extraPackages = [pkgs.zfs];
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

    containers.registries.settings = {
      unqualified-search-registries = ["docker.io" "quay.io"];
      registry = [
        {
          location = "docker.io";
        }
        {
          location = "quay.io";
        }
        {
          location = "localhost";
          insecure = true;
        }
        {
          location = "localhost:5000";
          insecure = true;
        }
        {
          location = "10.4.22.36";
          insecure = true;
        }
      ];
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
