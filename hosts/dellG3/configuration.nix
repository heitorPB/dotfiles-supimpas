# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  hardware.cpu.intel.updateMicrocode = true;

  # required for zfs. From head -c 8 /etc/machine-d
  networking.hostId = "c026a34e";

  # Machine specific packages
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia

    # Some rice
    catppuccin-papirus-folders
    #papirus-icon-theme
  ];

  #boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    "acpi_osi=Linux-Dell-Video"
  ];

  # Nvidia drivers for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # TODO: this is still not working. I think.
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to
    # fail. Enable this if you have graphical corruption issues or
    # application crashes after waking up from sleep. This fixes it by saving
    # the entire VRAM memory to /tmp/ instead of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver). Support is
    # limited to the Turing and later architectures. Full list of supported
    # GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus Only
    # available from driver 515.43.04+ Currently alpha-quality/buggy, so
    # false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for
    # your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      # This makes the integrated card to all the job, can use nvidia card with
      # prime-run
      enable = lib.mkForce true;
      enableOffloadCmd = lib.mkForce true;
    };
    #sync.enable = lib.mkForce false;
    # Make sure to use the correct Bus ID values for your system!
    # Get from sudo lshw -c display
    intelBusId = "PCI:0:1:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  hardware.graphics.extraPackages = with pkgs; [ vaapiVdpau ];


  # Her user settings
  users.users.j = {
    uid = 1001;
    isNormalUser = true;
    # TODO: systemd-journal is some kind of bug: I shouldn't need to be in it (see man journalctl)
    extraGroups = [ "wheel" "systemd-journal" "networkmanager" ];
    hashedPassword = "$y$j9T$IGcSlNtiBJX07jKBjOXDn0$sTswUMqAzJOZiqWJxsfpPbo9rcz/vaoQkJ1yLMoGzI9";
  };

  # Let's keep all her data
  fileSystems."/home/j" =
    {
      device = "zroot/data/homes/j";
      fsType = "zfs";
    };


  services.xserver.enable = true;
  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
    };
    defaultSession = "plasma";
  };

  services.desktopManager.plasma6.enable = true;
  #environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #  plasma-browser-integration
  #  konsole
  #  oxygen
  #];

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
