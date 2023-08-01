{ lib, stdenv, nixpkgs, unzip, jdk17_headless }:

import <nixpkgs>

stdenv.mkDerivation rec {
  pname = "artifakt-server";
  version = "0.1.0-2278";

  src = nixpkgs.fetchurl {
    url = "https://git.lovelace.lgbt/liv/artifakt/-/jobs/2278/artifacts/raw/server/build/distributions/server.zip";
    sha256 = "sha256:cda20283d0040f04576e7575bdc84d0f83759419d4c1ca21f33197057882210f";
  };

  buildInputs = [ jdk17_headless ];

  meta = with lib; {
    homepage = "https://git.lovelace.lgbt/liv/artifakt";
    description = "Artifakt Server";
    #platforms = platforms.unix;
    #license = with licenses; [ mit ];
  };
}
