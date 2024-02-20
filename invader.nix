{ lib, stdenv, fetchFromGitHub, cargo, cmake, corrosion, python3, qt6, rustc, SDL2, zlib }:

stdenv.mkDerivation rec {
  pname = "invader";
  version = "0.53.4";

  src = fetchFromGitHub {
    owner = "SnowyMouse";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-NXOXp97izS31hYtqgX/56nRH5LaeKlZlTedAWdIoN1I=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ cargo cmake corrosion python3 rustc ];
  buildInputs = [ qt6.qtbase SDL2 zlib ];

  meta = with lib; {
    homepage = "https://invader.opencarnage.net";
    description = "Free toolkit for Halo: Combat Evolved for creating maps and assets";
    platforms = platforms.all;
  };
}
