{
  description = "Heitor's flaky systems.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: do I need nixos-hardware?
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # Defines a formatter for "nix fmt"
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosConfigurations = {
      desk03 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./hosts/desk03/configuration.nix
          ./hosts/core.nix

          # home-manager stuff
          home-manager.nixosModules.home-manager
          {
            home-manager.users.h = import ./home-manager/h.nix {
              #gitKey = "heitorpbittencourt@gmail.com";
            };
          }
        ];
      };
    };

  };
}
