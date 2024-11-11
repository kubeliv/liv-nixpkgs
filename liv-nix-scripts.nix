{ lib, stdenv, fetchurl, bash }:

stdenv.mkDerivation rec {
  pname = "liv-nix-scripts";
  version = "0.1.0";

  src = fetchurl {
    url =
      "https://git.lovelace.lgbt/liv/nix-scripts/-/archive/v${version}/nix-scripts-v${version}.tar.gz";
    sha256 = "sha256:02hmswdiqkn9q1rdq9rfd5pdl7b6za34c4z210nwrdl6n2ppx05r";
  };

  buildInputs = [ bash ];

  installPhase = ''
    install -Dm755 nix-remote-profile $out/bin/nix-remote-profile
  '';

  meta = with lib; {
    homepage = "https://git.lovelace.lgbt/liv/nix-scripts";
    description = "Liv's Nix scripts";
    platforms = platforms.unix;
    license = with licenses; [ mit ];
  };
}
