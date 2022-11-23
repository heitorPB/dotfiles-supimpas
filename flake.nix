{
  description = "Heitor's flaky systems.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }@inputs: {
    # Defines a formatter for "nix fmt"
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosConfigurations = {
      desk03 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./hosts/desk03/configuration.nix
          ./hosts/nix.nix
        ];
      };
    };
  };
}
