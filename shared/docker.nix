# Also added my user to the `docker` group hosts/core.nix
# Entries added to impermanence-system.nix:
#   - /var/lib/docker
{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    #storageDriver = "zfs";
    autoPrune.enable = false;

    daemon.settings = {
      # Adjust network size
      # https://www.reddit.com/r/selfhosted/comments/1az6mqa/psa_adjust_your_docker_defaultaddresspool_size/
      # Each new Docker subnet will be a /24 (254 usable addresses) starting
      # from a base subnet.
      # See here for the default:
      # https://docs.docker.com/engine/daemon/ipv6/#dynamic-ipv6-subnet-allocation
      default-address-pools = [
        {
          base = "172.17.0.0/12";
          size = 24;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
  ];
}
