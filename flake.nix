{
  description = "Heitor's flaky systems.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # Basically only for ZFS impermanence

    # TODO: do I need nixos-hardware?

    # Downgrade orca-slicer to 2.3.1 - https://github.com/OrcaSlicer/OrcaSlicer/issues/13137
    nixpkgs-orca.url = "github:nixos/nixpkgs/62efab0dada7d38f14f7147bdd6c350780e9af10";

    update-systemd-resolved.url = "github:jonathanio/update-systemd-resolved";
    update-systemd-resolved.inputs.nixpkgs.follows = "nixpkgs"; # optional
  };

  outputs = {
    nixpkgs,
    home-manager,
    impermanence,
    chaotic,
    nixpkgs-orca,
    ...
  } @ inputs: let
    ssot = import ./shared/ssot.nix inputs;
  in {
    # Define a formatter for "nix fmt"
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

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
          ./shared/podman.nix

          # home-manager stuff
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {machine = ssot.desktop;};
            home-manager.users.h = import ./home-manager/h.nix;
          }
        ];
      };

      "${ssot.nas.hostname}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Pass these stuff as inputs to the configuration files
        specialArgs = {
          inherit ssot;
          inherit inputs;
          machine = ssot.nas;
        };
        modules = [
          # HW and base configuration
          ./hosts/nas/configuration.nix
          ./hosts/core.nix

          # Extra services for this host
          ./shared/tailscale.nix

          # ZFS on impermanence from Chaotic
          chaotic.nixosModules.default
          impermanence.nixosModules.impermanence
          ./shared/impermanence-system.nix

          # home-manager stuff
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {machine = ssot.nas;};
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

          ./shared/power-saving-laptop.nix

          # Extra services for this host
          ./shared/openvpn.nix
          ./shared/podman.nix
          ./shared/docker.nix
          ./shared/k3s.nix
          ./shared/tailscale.nix

          # ZFS on impermanence from Chaotic
          chaotic.nixosModules.default
          impermanence.nixosModules.impermanence
          ./shared/impermanence-system.nix

          # home-manager stuff
          home-manager.nixosModules.home-manager
          {
            # TODO: how to inherit this?
            home-manager.extraSpecialArgs = {machine = ssot.thinkpadL14;};
            home-manager.users.h = {
              imports = [
                ./home-manager/h.nix
              ];
            };
          }
        ];
      };

      "${ssot.dellG3.hostname}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Pass these stuff as inputs to the configuration files
        specialArgs = {
          inherit ssot;
          inherit inputs;
          machine = ssot.dellG3; # TODO: use something like let machineName = dellG3; ?
        };
        modules = [
          # HW and base configuration
          ./hosts/dellG3/configuration.nix
          ./hosts/core.nix
          ./hosts/seat-configuration.nix

          ./shared/power-saving-laptop.nix

          # Extra services for this host
          ./shared/podman.nix
          ./shared/docker.nix
          ./shared/tailscale.nix
          ./shared/openvpn.nix

          # ZFS on impermanence from Chaotic
          chaotic.nixosModules.default
          impermanence.nixosModules.impermanence
          ./shared/impermanence-system.nix

          # home-manager stuff
          home-manager.nixosModules.home-manager
          {
            # TODO: how to inherit this?
            home-manager.extraSpecialArgs = {machine = ssot.dellG3;};
            home-manager.users.h = {
              imports = [
                ./home-manager/h.nix
              ];
            };
          }
        ];
      };
    };
  };
}
