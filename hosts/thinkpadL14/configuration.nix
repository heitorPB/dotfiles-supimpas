# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  # Microcode updates.
  hardware.cpu.amd.updateMicrocode = true;

  # required for zfs. From head -c 8 /etc/machine-id
  networking.hostId = "5a824f81";

  # Machine specific packages
  environment.systemPackages = with pkgs; [
    radeontop # Like htop, but for AMD GPUs
    nvtopPackages.amd # nvtop for AMD GPUs
  ];

  # Load amdgpu at stage 1
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    "acpi_backlight=native"

    # AMD CPU scaling
    # https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
    # https://wiki.archlinux.org/title/CPU_frequency_scaling#amd_pstate
    # On recent AMD CPUs this can be more energy efficient.
    "amd_pstate=guided"

    # Load amdgpu at stage 1
    "amdgpu"

    # With BIOS version 1.12 and the IOMMU enabled, the amdgpu driver
    # either crashes or is not able to attach to the GPU depending on
    # the kernel version. I've seen no issues with the IOMMU disabled.
    #
    # BIOS version 1.13 fixes the IOMMU issues, but we leave the IOMMU
    # in software mode to avoid a sad experience for those people that drew
    # the short straw when they bought their laptop.
    #
    # Do not set iommu=off, because this will cause the SD-Card reader
    # driver to kernel panic.
    "iommu=soft"
  ];

  # AMD GPU
  hardware.graphics = {
    # See also seat-configuration.nix for other OpenGL settings

    extraPackages = with pkgs; [
      # VA-API and VDPAU
      vaapiVdpau

      # AMD ROCm OpenCL runtime
      rocmPackages.clr
      rocmPackages.clr.icd

      # AMDVLK drivers can be used in addition to the Mesa RADV drivers.
      amdvlk
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    "VDPAU_DRIVER" = "radeonsi";
    "LIBVA_DRIVER_NAME" = "radeonsi";
  };
  # Most software has the HIP libraries hard-coded. Workaround:
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

  # USB4 / Thunderbolt
  services.hardware.bolt.enable = true;


  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

