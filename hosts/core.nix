# Configurations and options for all systems but Nix, see nix.nix for that.
{
  # TODO import nix.nix here, to clean up flake.nix

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

  # Packages for all machines TODO

  # Neovim everywhere
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.variables.EDITOR = "nvim";
  environment.variables.SUDO_EDITOR = "nvim"; # Is this really needed?
}
