# Global configuration for Nix itself.
{ config, pkgs, inputs, ... }:

{
  nix = {
    settings = {
      # enable newer commands and flakes
      experimental-features = [ "nix-command" "flakes" ];

      # automatically removes older builds
      auto-optimise-store = true;

      # use all CPUs for building
      max-jobs = "auto";

      # Add extra caches
      substituters = [
        # github:nix-community/*
        "https://nix-community.cachix.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Use systems's Flakes for everything instead of downloading/updating.
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
