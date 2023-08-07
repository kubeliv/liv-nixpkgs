{ lib, stdenv, fetchurl, unzip, jdk17_headless, makeWrapper }:

stdenv.mkDerivation {
  pname = "artifakt-server";
  version = "0.1.0";
  exes = [
    "artifakt-server"
  ];

  src = fetchurl {
    url = "https://git.lovelace.lgbt/liv/artifakt/uploads/598ee8aa3e852c44b8ff622cb573c5ad/server.zip";
    sha256 = "sha256:0ccb91c321f3bf0661c36449b4138a66fc98dad8a23fc60644c35a180bbd7f6e";
  };

  buildInputs = [ unzip jdk17_headless makeWrapper ];

  installPhase = ''
    mkdir -p $out
    mkdir -p $out/bin
    cp -r lib $out/
    cp bin/server $out/bin/artifakt-server
    wrapProgram $out/bin/artifakt-server --prefix PATH : ${lib.makeBinPath [ jdk17_headless ]}
  '';

  meta = with lib; {
    homepage = "https://git.lovelace.lgbt/liv/artifakt";
    description = "Artifakt Server";
    platforms = platforms.unix;
    license = with licenses; [ mit ];
  };
}
