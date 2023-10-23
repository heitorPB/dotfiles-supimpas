{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    #storageDriver = "zfs";
    autoPrune.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker # TUI for docker
  ];
}
