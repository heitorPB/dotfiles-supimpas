{
  description = "Flake for Terraform and Packer development";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
      in
      {
        # For nix develop
        devShell = pkgs.mkShell {
          shellHook = ''
            export AWS_PROFILE="foo"
          '';

          nativeBuildInputs = with pkgs; [
            terraform
            terraform-lsp
            packer
          ];
        };
      });
}
