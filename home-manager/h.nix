{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # ./nvim.nix
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  programs.git = {
    enable = true;
    userName = "bla";
    userEmail = "bla@gmail.com";
    aliases = {
      st = "status";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
