{
  inputs = { flake-utils.url = "github:numtide/flake-utils"; };

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
      }) // {
        overlays.liv = final: prev: {
          liv-nix-scripts = final.callPackage ./pkgs/liv-nix-scripts { };
          mango-os = final.callPackage ./pkgs/mango-os { };
        };
        overlays.default = self.overlays.liv;

        nixosModules = {
          mango-os = { config, ... }: { imports = [ ./modules/mango-os ]; };
        };
      };
}
