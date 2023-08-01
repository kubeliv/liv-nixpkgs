{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.aarch64-darwin.artifakt-server =
      let pkgs = import nixpkgs {
        system = "aarch64-darwin";
      };
      in pkgs.stdenv.mkDerivation {
        name = "artifakt-server";
        src = pkgs.fetchzip {
          url = "https://git.lovelace.lgbt/liv/artifakt/-/jobs/2278/artifacts/raw/server/build/distributions/server.zip";
          sha256 = "sha256-wF0Z+/vu02u2BzQoTUIDV+zAC9qaJ87nzQxa6CEvT3Y=";
        };
	buildInputs = [ pkgs.jdk17_headless ];

	installPhase = ''
	  mkdir -p $out
	  cp -r * $out
	'';
      };

    defaultPackage.aarch64-darwin = self.packages.aarch64-darwin.artifakt-server;
  };
}
