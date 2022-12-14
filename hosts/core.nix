# Configurations and options for all hosts
{ inputs, pkgs, location, ... }:
{
  # Import nix.nix here to clean up flakes.nix
  imports = [ ./nix.nix ];

  # "enp3s0" instead of "eth0".
  networking.usePredictableInterfaceNames = true;

  # Use Systemd timesyncd for NTP
  services.timesyncd.enable = true;

  # Set time zone
  time.timeZone = location.timezone;
  environment.variables.CURRENT_CITY = location.city + ", " + location.country ;
  environment.variables.CURRENT_GEO = location.latitude + ":" + location.longitude;

  # Internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "en_GB.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];
    extraLocaleSettings = { LC_TIME = "pt_BR.UTF-8"; };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  # Override some packages' settings/sources
  # Downgrade gnupg to 2.2.27. TODO: remove later
  nixpkgs.overlays = [ (final: prev: { gnupg = inputs.nixpkgs-gnupg.legacyPackages.${final.system}.gnupg; }) ];

  # Fix wrong sudo password messages
  security.sudo = {
    package = pkgs.sudo.override { withInsults = true; };
    extraConfig = ''
      Defaults insults
    '';
  };

  # Colored man pages
  environment.variables.MANPAGER = "less -R --use-color -Dd+r -Du+b";

  environment.shellAliases = {
    # I am lazy
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    p = "cd ~/projects/";

    # Colors everywhere
    grep = "grep --color=auto";
    ip = "ip -color=auto";
    diff = "diff --color=auto";

    # My own ls's
    #ls = "ls --color=auto"; # This is not needed, --color=tty is the default
    l = "ls -lahF";
    ls1 = "ls -1";
  };

  # home-manager settings
  home-manager.useGlobalPkgs = true;

  # Packages for all machines
  environment.systemPackages = with pkgs; [
    btop # Fancier top(1)
    file
    kmon # Kernel monitoring
    lfs # Fancier df(1)
    nixos-option # Query nixos configuration
    pciutils # For lspci(8)
    ripgrep # Fancier grep(1)
    rsync
    wget

    # Development and workflow
    git
    jq
    tmux
    # THE editor and its plugins
    neovim
    fzf
    silver-searcher
    rnix-lsp # Nix LSP
  ];

  # Neovim everywhere
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
  environment.variables.EDITOR = "nvim";
  environment.variables.SUDO_EDITOR = "nvim"; # For sudo -e

  # My user in all hosts
  users.users.h = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxMuFUrQujzveHDbM8etG1A2rQhA8i2KwM0j2BiFx0K h@alien" ];
  };

  # Configure GnuPG agent
  programs.gnupg.agent = {
    enable = true;
    enableExtraSocket = true;
    enableSSHSupport = true; # Make GPG through SSH work
    pinentryFlavor = "curses"; # Options: "curses", "tty", "gtk2", "qt"
  };
}
