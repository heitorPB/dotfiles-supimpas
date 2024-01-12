# General Configuration for GUI systems
{ lib, pkgs, ssot, ... }: with ssot;

{
  # Network (NetworkManager).
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      dns = "systemd-resolved";
    };

    # Disable non-NetworkManager.
    useDHCP = false;
  };

  # GPU
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # XDG-Portal (for dialogs & screensharing).
  xdg.portal.wlr.enable = true;

  # Packages for machines with a seat
  environment.systemPackages = with pkgs; [
    alacritty # Terminal emulator

    networkmanagerapplet # NetworkManager Systray

    firefox-bin # Could not get a cache hit :(
  ];

  # Fonts.
  fonts = {
    #enableDefaultPackages = true; # Fonts you expect every distro to have. TODO: this is broken as of now :(
    packages = with pkgs; [
      #borg-sans-mono
      cantarell-fonts
      droid-sans-mono-nerdfont
      fira
      fira-code
      fira-code-symbols
      #font-awesome_4
      font-awesome_5
      noto-fonts
      noto-fonts-cjk
      #open-fonts
      roboto
      #ubuntu_font_family
    ];
    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Fira Code" ];
      };
    };
  };
}
