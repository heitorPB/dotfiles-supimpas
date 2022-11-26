# Configurations and options for all hosts
{ pkgs, ... }:
{
  # TODO: import nix.nix here to clean up flakes.nix
  # nix = import ./nix.nix; # this does not work, why?

  # "enp3s0" instead of "eth0".
  networking.usePredictableInterfaceNames = true;

  # Set time zone.
  time.timeZone = "America/Sao_Paulo";

  # Internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "en_GB.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_TIME = "pt_BR.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  # Colored man pages
  environment.variables.MANPAGER = "less -R --use-color -Dd+r -Du+b";

  # home-manager settings
  home-manager.useGlobalPkgs = true;

  # Packages for all machines
  environment.systemPackages = with pkgs; [
    btop
    file
    rsync
    wget
    ripgrep
    nixos-option

    # Development and workflow
    git
    tmux
    neovim
    fzf
    silver-searcher
  ];

  # Neovim everywhere
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
  environment.variables.EDITOR = "nvim";
  environment.variables.SUDO_EDITOR = "nvim"; # Is this really needed?

  # My user in all hosts
  users.users.h = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxMuFUrQujzveHDbM8etG1A2rQhA8i2KwM0j2BiFx0K h@alien" ];
  };

}
