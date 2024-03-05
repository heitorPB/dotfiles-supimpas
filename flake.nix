{
  description = "Heitor's flaky systems.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    # For ZFS impermanence.
    # TODO: remove this and just do it manualy to clean up dependencies
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # TODO: do I need nixos-hardware?

    # Downgrade gnupg to 2.2.27. TODO: remove later
    nixpkgs-gnupg.url = "github:nixos/nixpkgs/d88ad75767c638c013f5db40739386b1a5e12029";

    update-systemd-resolved.url = "github:jonathanio/update-systemd-resolved";
    update-systemd-resolved.inputs.nixpkgs.follows = "nixpkgs"; # optional
    #awsvpnclient.url = "github:ymatsiuk/awsvpnclient";
    #awsvpnclient.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, impermanence, chaotic, ... }@inputs:
    let
      ssot = import ./shared/ssot.nix inputs;
    in
    {
      # Define a formatter for "nix fmt"
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = {
        "${ssot.desktop.hostname}" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # Pass these stuff as inputs to the configuration files
          specialArgs = {
            inherit ssot;
            inherit inputs;
            machine = ssot.desktop;
          };
          modules = [
            # HW and base configuration
            ./hosts/desk03/configuration.nix
            ./hosts/core.nix

            # Extra services for this host
            ./shared/vpns.nix
            ./shared/podman.nix
            ./shared/nomad.nix
            #./shared/docker.nix

            # home-manager stuff
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { machine = ssot.desktop; };
              home-manager.users.h = import ./home-manager/h.nix;
            }
          ];
        };

        "${ssot.thinkpadL14.hostname}" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # Pass these stuff as inputs to the configuration files
          specialArgs = {
            inherit ssot;
            inherit inputs;
            machine = ssot.thinkpadL14;
          };
          modules = [
            # HW and base configuration
            ./hosts/thinkpadL14/configuration.nix
            ./hosts/core.nix
            ./hosts/seat-configuration.nix

            ./shared/vpns.nix

            # Use desktop as remove builder
            ./shared/nix-buildMachines-desk03.nix

            ./shared/power-saving-laptop.nix

            # ZFS on impermanence from Chaotic
            chaotic.nixosModules.default
            impermanence.nixosModules.impermanence
            ./shared/impermanence-system.nix

            # home-manager stuff
            home-manager.nixosModules.home-manager
            {
              # TODO: how to inherit this?
              home-manager.extraSpecialArgs = { machine = ssot.thinkpadL14; };
              home-manager.users.h = import ./home-manager/h.nix;
            }
          ];
        };
      };
    };
}
