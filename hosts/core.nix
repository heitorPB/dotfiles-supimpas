# Configurations and options for all hosts
{ pkgs, ... }:
{
  # Import nix.nix here to clean up flakes.nix
  imports = [ ./nix.nix ];

  # "enp3s0" instead of "eth0".
  networking.usePredictableInterfaceNames = true;

  # Use Systemd timesyncd for NTP
  services.timesyncd.enable = true;

  # Set time zone.
  time.timeZone = "America/Sao_Paulo";

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
  nixpkgs.overlays =
    let
      thisConfigsOverlay = final: prev: {
        # Default sudo is too vanilla
        sudo = prev.sudo.override { withInsults = true; };
      };
    in
      [ thisConfigsOverlay ];

  security.sudo.extraConfig = ''
    # Fix wrong password messages
    Defaults insults
  '';

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
    #ls = "ls --color=auto"; # this is not needed, --color=tty is the default
    l = "ls -lahF";
    ls1 = "ls -1";
  };

  # home-manager settings
  home-manager.useGlobalPkgs = true;

  # Packages for all machines
  environment.systemPackages = with pkgs; [
    btop
    file
    rsync
    wget
    ripgrep # fancier grep(1)
    lfs # fancier df(1)
    nixos-option # query nixos configuration

    # Development and workflow
    git
    tmux
    neovim
    fzf
    silver-searcher

    rnix-lsp # Nix LSp
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
    uid = 1001;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxMuFUrQujzveHDbM8etG1A2rQhA8i2KwM0j2BiFx0K h@alien" ];
  };
}
