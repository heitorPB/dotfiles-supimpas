# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Using impermanence, no need to setup / here
  # fileSystems."/" =
  #   { device = "zroot/ROOT/empty";
  #     fsType = "zfs";
  #   };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" "umask=0077"];
    };

  fileSystems."/nix" =
    {
      device = "zroot/ROOT/nix";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/var/persistent" =
    {
      device = "zroot/data/persistent";
      fsType = "zfs";
      neededForBoot = true;
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/SWAP"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
