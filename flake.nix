{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in
        {
          packages.artifakt-server = pkgs.callPackage ./artifakt-server.nix {};
          packages.default = self.packages.${system}.artifakt-server;

          nixpkgs.overlays = (final: prev: rec {
            artifakt-server = self.packages.${system}.artifakt-server;
          });
        }
    );
}
