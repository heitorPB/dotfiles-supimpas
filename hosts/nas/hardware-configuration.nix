{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # Using impermanence, no need to setup / here
  # fileSystems."/" =
  #   { device = "zroot/ROOT/empty";
  #     fsType = "zfs";
  #   };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "zroot/ROOT/nix";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/var/persistent" = {
    device = "zroot/data/persistent";
    fsType = "zfs";
    neededForBoot = true;
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  hardware.cpu.intel.updateMicrocode = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
