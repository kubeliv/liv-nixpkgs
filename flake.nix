{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in
        rec {
          packages.artifakt-server = import ./artifakt-server.nix { inherit pkgs; };
          packages.default = packages.artifakt-server;
        }
    );
}
