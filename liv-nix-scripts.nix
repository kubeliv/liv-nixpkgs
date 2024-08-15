{ lib, stdenv, fetchFromGitHub, bash }:

stdenv.mkDerivation rec {
  pname = "liv-nix-scripts";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kubeliv";
    repo = "nix-scripts";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-q+UYcmmA5FtkRDDwuFgqZNRVSaS3uA3y5lR+mAvS6u8=";
  };

  buildInputs = [ bash ];

  installPhase = ''
    install -Dm755 nix-remote-profile $out/bin/nix-remote-profile
  '';

  meta = with lib; {
    homepage = "https://github.com/kubeliv/nix-scripts";
    description = "Liv's Nix scripts";
    platforms = platforms.unix;
    license = with licenses; [ mit ];
  };
}
