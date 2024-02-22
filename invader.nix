{ lib, stdenv, fetchFromGitHub, cacert, cargo, cmake, corrosion, darwin, flac
, gcc, gccStdenv, freetype, libarchive, libsamplerate, libsquish, libtiff
, libvorbis, python3, qt6, rustc, SDL2, zlib }:

gccStdenv.mkDerivation rec {
  pname = "invader";
  version = "0.53.4";

  src = fetchFromGitHub {
    owner = "SnowyMouse";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-DeQXYtQq8SD17MYCO4+x/0BMfTAR4f571hY2jGIEHtc=";
  };

  patches = [ ./invader-climits-fix.patch ];

  preConfigure = ''
    export CARGO_HOME=$(mktemp -d cargo-home.XXX)
  '';

  dontWrapQtApps = true;

  nativeBuildInputs = [ cacert cargo cmake corrosion gcc python3 rustc ];
  buildInputs = [
    flac
    freetype
    libarchive
    libsamplerate
    libsquish
    libtiff
    libvorbis
    qt6.qtbase
    SDL2
    zlib
  ] ++ lib.optional stdenv.isDarwin
    (with darwin.apple_sdk_11_0.frameworks; [ AppKit ]);

  cmakeFlags = [ ];

  meta = with lib; {
    homepage = "https://invader.opencarnage.net";
    description =
      "Free toolkit for Halo: Combat Evolved for creating maps and assets";
    platforms = platforms.all;
  };
}
