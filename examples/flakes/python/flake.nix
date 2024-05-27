{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # For nix develop
        devShell = pkgs.mkShell {
          shellHook = ''
            export PIP_NO_BINARY="ruff"
          '';

          packages = with pkgs; [
            (python311.withPackages (p: with p; [
              pip
              python-lsp-server
              python-lsp-ruff
            ]))

            rustc
            cargo
          ];
        };
      });
}
