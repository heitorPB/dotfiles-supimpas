{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # For nix develop
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            stdenv.cc.cc
            zlib # For NumPy
          ];

          shellHook = ''
            export PIP_NO_BINARY="ruff"

            # for PyTorch
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib

            # for Numpy
            export LD_LIBRARY_PATH=${pkgs.zlib}/lib:$LD_LIBRARY_PATH

            # Use Docker instead of Podman
            export DOCKER_HOST=unix:///run/docker.sock
          '';

          nativeBuildInputs = with pkgs; [
            (python312.withPackages (p: with p; [
              pip
              python-lsp-server
            ]))

            rustc
            cargo
          ];
        };
      });
}
