{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.liv ]; }; in
        {
          packages.artifakt-server = pkgs.artifakt-server;
          packages.default = pkgs.artifakt-server;
        }
    ) // {
      overlays.liv = final: prev: {
        artifakt-server = final.callPackage ./artifakt-server.nix {};
      };
      overlays.default = self.overlays.liv;
    } // {
      nixosModule = let
          artifakt-server = (import ./artifakt-server-service.nix { inherit nixpkgs; }); in
        { config, ... }: {
          imports = [
            ./artifakt-server-service.nix
          ];
        };
    };
}
