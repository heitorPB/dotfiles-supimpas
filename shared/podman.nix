# Configuration for podman, using crun as OCI runtime (default)
# TODO: Update mywiki if this file is changed.
# Entries in impermanence:
#   - /var/lib/containers
#   - ~/.local/share/containers
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
      defaultNetwork.settings.dns_enabled = true;
    };

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
