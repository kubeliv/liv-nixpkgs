{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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
        packages.oidc-cli = pkgs.oidc-cli;
        packages.redscript = pkgs.redscript;
        packages.rkmod = pkgs.rkmod;
      }) // {
        overlays.liv = final: prev: {
          liv-nix-scripts = final.callPackage ./pkgs/liv-nix-scripts { };
          mango-os = final.callPackage ./pkgs/mango-os { };
          oidc-cli = final.callPackage ./pkgs/oidc-cli { };
          redscript = final.callPackage ./pkgs/redscript { };
          rkmod = final.callPackage ./pkgs/rkmod { };
        };
        overlays.default = self.overlays.liv;

        nixosModules = {
          mango-os = { config, ... }: { imports = [ ./modules/mango-os ]; };
        };
      };
}
