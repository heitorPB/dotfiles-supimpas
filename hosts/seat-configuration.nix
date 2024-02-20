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

  # Bluetooth.
  hardware.bluetooth = {
    enable = true;
  };
  services.blueman.enable = true;

  # GPU
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # XDG-Portal (for dialogs & screensharing).
  xdg.portal = {
    wlr.enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];

    config.common.default = "*";
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    # Allow only users in the audio group to have access
    systemWide = false;
  };
  hardware.pulseaudio.enable = false;
  # Optional and recommended to get near realtime, e.g. for PulseAudio audio
  security.rtkit.enable = true;

  # Extra packages for machines with a seat
  environment.systemPackages = with pkgs; [
    # Generic HW related
    glxinfo # Debug OpenGL

    alacritty # Terminal emulator

    bluez-tools # Bluetooth tools
    networkmanagerapplet # NetworkManager Systray

    lxqt.pavucontrol-qt # GUI for audio control
    qpwgraph # Graph based GUI to connect Audio sinks and outputs

    firefox-bin # Could not get a cache hit :(
  ];

  # Fonts.
  fonts = {
    enableDefaultPackages = true; # Fonts you expect every distro to have.
    packages = with pkgs; [
      borg-sans-mono
      cantarell-fonts
      droid-sans-mono-nerdfont
      #fira
      #fira-code
      #fira-code-symbols
      fira-code-nerdfont
      #font-awesome_4
      font-awesome_5
      noto-fonts
      noto-fonts-cjk
      noto-fonts-color-emoji
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
