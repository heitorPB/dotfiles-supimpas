# General Configuration for GUI systems
{ lib, pkgs, machine, ... }:

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

  # Former hardware.opengl
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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
  security = {
    # Optional and recommended to get near realtime, e.g. for PulseAudio audio
    rtkit.enable = true;

    # Allow any user from group "users" to request realtime
    pam.loginLimits = [
      { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
    ];
  };

  # Extra packages for machines with a seat
  environment.systemPackages = with pkgs; [
    # Generic HW related
    acpi # TODO should this be in core.nix instead?
    #glxinfo # Debug OpenGL, with `glxgears` and `glxinfo`
    #libva-utils # Debug VAAPI, with `vainfo`
    #opencl-info # Debug OpenCL, with `opencl-info`
    #vdpauinfo # Debug VDPAU, with `vdpauinfo`
    #vulkan-tools # Debug Vulkan, with `vulkaninfo`, `vkcube`

    alacritty # Terminal emulator

    bluez-tools # Bluetooth tools
    networkmanagerapplet # NetworkManager Systray - borked on Sway with Swaybar

    avizo # Neat pop-up notification for audio/brightness adjustments. See sway config
    brightnessctl # To change backligh (screen brightness), for avizo
    calibre # E-book reader/manager
    lxmenu-data # For lxqt apps' "Open with" dialogs
    lxqt.lxqt-menu-data # For pcmanfm-qt right click Application Menu
    lxqt.lxqt-sudo # GUI for sudo, for pcmanfm-qt
    #lxqt.pavucontrol-qt # GUI for audio control
    lxqt.pcmanfm-qt # Filesystem browser
    pamixer # PulseAudio Mixer, for avizo
    pavucontrol # GUI for audio control
    pinentry-qt # Pinentry for gnupg
    qbittorrent
    qpwgraph # Graph based GUI to connect Audio sinks and outputs
    xarchiver # Archiver to use with pcmanfm-qt

    firefox
    #firefox-bin # Could not get a cache hit :(
    google-chrome
    #chromium # Could not get a cache hit :(

    # Office
    gimp
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.pt_BR
    libreoffice-qt

    # My favorites :)
    anki # Flash cards!
    darktable # RAW image post-processor
    drive # Google drive CLI
    feh # Image viewer
    hledger # Double entry accounting tool
    keepassxc # Password manager
    mpv # Video/audio player. See my home config as well
    spotify # Sold my soul
    telegram-desktop # Old school communication system

    orca-slicer # 3D printing slicer

    # Wayland progrs
    grim # Screenshot for wayland # TODO: configure screenshot in Sway
    slurp # For selecting region of screen. Easier screenshotting: grim -s $(slurp)
    wdisplays # Equivalent to arandr
  ];

  # For USB automounting, on pcmanfm-qt
  services.gvfs.enable = true;

  # For dconf
  programs = {
    dconf.enable = true;

    gnupg.agent.pinentryPackage = lib.mkIf (machine.gpgPinentryPackage == "qt") (
      pkgs.pinentry-qt
    );
  };

  # Qt is cute
  qt = {
    enable = true;
  };

  # Port used by Spotify to connect to Chromecast
  networking.firewall.allowedUDPPorts = [ 5353 ];

  # Console/XWayland default keyboard layout.
  # TODO: move these to ssot
  services.xserver.xkb.layout = "br";
  services.xserver.xkb.model = "thinkpad";
  console.keyMap = "br-abnt2";

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
      #font-awesome_5
      font-awesome_6
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
