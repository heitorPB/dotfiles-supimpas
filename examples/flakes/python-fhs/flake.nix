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
        devShell = (pkgs.buildFHSUserEnv {
         name = "poetry-env";
         targetPkgs = pkgs:
           [
             (pkgs.python312.withPackages (p: with p; [
               uv
               python-lsp-server
             ]))

             pkgs.zlib # for NumPy
           ];
         runScript = "bash";
       }).env;

      });
}
