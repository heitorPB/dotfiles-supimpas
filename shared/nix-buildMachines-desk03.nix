# Global configuration for Nix itself.
{ config, pkgs, inputs, ssot, machine, ... }:

{
  nix.buildMachines = [
    {
      # ssot.desktop.hostname
      hostName = "192.168.1.70"; # TODO: this sucks. Make it better. VPN?
      sshUser = "h";
      protocol = "ssh"; # TODO: evaluate ssh-ng instead
      sshKey = "~/.ssh/id_ed25519.${machine.hostname}";
      systems = [ "x86_64-linux" ];
      maxJobs = 16;
      supportedFeatures = [ "big-parallel" ];
    }
  ];
}
