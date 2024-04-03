# Power saving services for my laptop
{ config, pkgs, inputs, ssot, machine, ... }:

{
  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = false; # Replaced by tlp
  services.tlp.enable = true;
  services.upower.enable = true;
}
