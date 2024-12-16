{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.liv ];
        };
      in {
        packages.liv-nix-scripts = pkgs.liv-nix-scripts;
        packages.mango-os = pkgs.mango-os;
        packages.redscript = pkgs.redscript;
      }) // {
        overlays.liv = final: prev: {
          liv-nix-scripts = final.callPackage ./pkgs/liv-nix-scripts { };
          mango-os = final.callPackage ./pkgs/mango-os { };
          redscript = final.callPackage ./pkgs/redscript { };
        };
        overlays.default = self.overlays.liv;

        nixosModules = {
          mango-os = { config, ... }: { imports = [ ./modules/mango-os ]; };
        };
      };
}
