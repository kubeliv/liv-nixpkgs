{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.liv ]; }; in
        {
          packages.artifakt-server = pkgs.artifakt-server;
	        packages.mango-os = pkgs.mango-os;
          packages.default = pkgs.artifakt-server;
        }
    ) // {
      overlays.liv = final: prev: {
        artifakt-server = final.callPackage ./artifakt-server.nix {};
        mango-os = final.callPackage ./mango-os.nix {};
      };
      overlays.default = self.overlays.liv;
    } // {
      nixosModules = {
        artifakt-server =
          { config, ... }: {
            imports = [
              ./artifakt-server-service.nix
            ];
          };
        mango-os =
          { config, ... }: {
            imports = [
              ./mango-os-service.nix
            ];
          };
      };
    };
}
