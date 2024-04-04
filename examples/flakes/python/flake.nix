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
      rec {
        # For nix develop
        devShell = pkgs.mkShell {
          shellHook = ''
            export PIP_NO_BINARY="ruff"
            export PIP_NO_BINARY="uv"
          '';

          nativeBuildInputs = with pkgs; [
            (python311.withPackages (p: with p; [
              python-lsp-server
              python-lsp-ruff
            ]))

            rustc
            cargo
          ];
        };
      });
}
