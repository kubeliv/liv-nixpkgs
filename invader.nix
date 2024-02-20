{ lib, stdenv, fetchFromGitHub, cargo, cmake, corrosion, flac, freetype, libarchive, libsamplerate, libtiff, libvorbis, python3, qt6, rustc, SDL2, zlib }:

stdenv.mkDerivation rec {
  pname = "invader";
  version = "0.53.4";

  src = fetchFromGitHub {
    owner = "SnowyMouse";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-DeQXYtQq8SD17MYCO4+x/0BMfTAR4f571hY2jGIEHtc=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ cargo cmake corrosion python3 rustc ];
  buildInputs = [ flac freetype libarchive libsamplerate libtiff libvorbis qt6.qtbase SDL2 zlib ];

  cmakeFlags = [
  ];

  meta = with lib; {
    homepage = "https://invader.opencarnage.net";
    description = "Free toolkit for Halo: Combat Evolved for creating maps and assets";
    platforms = platforms.all;
  };
}
