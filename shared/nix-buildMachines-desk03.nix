# Configure desk03 as a nix remote builder
{ config, pkgs, inputs, ssot, machine, ... }:

{
  nix.distributedBuilds = true; # Required to use the builders

  nix.buildMachines = [
    {
      # ssot.desktop.hostname
      hostName = "192.168.1.70"; # TODO: this sucks. Make it better. VPN?
      sshUser = "h";
      protocol = "ssh"; # TODO: evaluate ssh-ng instead
      sshKey = "/home/h/.ssh/id_ed25519.${machine.hostname}";
      systems = [ "x86_64-linux" ];
      maxJobs = 16;
      speedFactor = 4;
      supportedFeatures = [ "big-parallel" ];
    }
  ];
}
