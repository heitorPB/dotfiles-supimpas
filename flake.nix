{
  description = "Heitor's flaky systems.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: do I need nixos-hardware?

    # Downgrade gnupg to 2.2.27. TODO: remove later
    nixpkgs-gnupg.url = "github:nixos/nixpkgs/d88ad75767c638c013f5db40739386b1a5e12029";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      geolocation = import ./hosts/geolocation.nix;
    in
    {
      # Define a formatter for "nix fmt"
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = {
        desk03 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; location = geolocation.piracicaba; }; # Pass flake inputs to our config
          modules = [
            # HW and base configuration
            ./hosts/desk03/configuration.nix
            ./hosts/core.nix

            # Extra services for this host
            ./hosts/podman.nix

            # home-manager stuff
            home-manager.nixosModules.home-manager
            {
              home-manager.users.h = import ./home-manager/h.nix {
                gitKey = "heitorpbittencourt@gmail.com";
              };
            }
          ];
        };
      };

    };
}
