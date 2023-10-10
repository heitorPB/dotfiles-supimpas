{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    #storageDriver = "zfs";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
