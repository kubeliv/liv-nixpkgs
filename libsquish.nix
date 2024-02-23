{ lib, stdenv, fetchurl, cmake, gcc, gccStdenv }:

gccStdenv.mkDerivation rec {
  pname = "libsquish";
  version = "1.15";

  src = fetchurl {
    url =
      "https://downloads.sourceforge.net/project/libsquish/libsquish-${version}.tgz";
    sha256 = "sha256-YoeW7rpgiGYYOmHQgNRpZ8ndpnI7wKPsUjJMhdIUcmk=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ cmake gcc ];

  cmakeFlags =
    [ "-DBUILD_SQUISH_WITH_OPENMP=false" "-DBUILD_SQUISH_WITH_SSE2=false" ];

  meta = with lib; {
    homepage = "";
    description = "";
    platforms = platforms.unix;
  };
}
