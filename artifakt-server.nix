{ lib, stdenv, fetchurl, unzip, jdk17_headless }:

stdenv.mkDerivation {
  pname = "artifakt-server";
  version = "0.1.0-2278";

  src = fetchurl {
    url = "https://git.lovelace.lgbt/liv/artifakt/-/jobs/2278/artifacts/raw/server/build/distributions/server.zip";
    sha256 = "sha256:cda20283d0040f04576e7575bdc84d0f83759419d4c1ca21f33197057882210f";
  };

  buildInputs = [ unzip jdk17_headless ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  JAVA_HOME = jdk17_headless;

  meta = with lib; {
    homepage = "https://git.lovelace.lgbt/liv/artifakt";
    description = "Artifakt Server";
    platforms = platforms.unix;
    license = with licenses; [ mit ];
  };
}
