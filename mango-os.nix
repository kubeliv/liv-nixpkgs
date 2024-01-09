{ lib, stdenv, fetchurl, unzip, jdk17_headless, makeWrapper }:

stdenv.mkDerivation {
  pname = "mango-os";
  version = "5.1.0";

  src = fetchurl {
    url = "https://store.mango-os.com/downloads/fullCores/enterprise-m2m2-core-5.1.0.zip";
    sha256 = "sha256:c415c0d449844882865a9d27b7fa0d4f6b23eea29ddb2023ee3904ac05334119";
  };

  buildInputs = [ unzip jdk17_headless makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    unzip $src -d $out
    mv $out/bin/start-mango.sh $out/bin/start-mango
    wrapProgram $out/bin/start-mango --prefix PATH : ${lib.makeBinPath [ jdk17_headless ]}
  '';

  meta = with lib; {
    homepage = "https://mango-os.com";
    description = "Mango OS (enterprise edition)";
    platforms = platforms.unix;
  };
}
