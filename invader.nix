{ lib, stdenv, fetchFromGitHub, cacert, cargo, cmake, corrosion, darwin, flac
, freetype, libarchive, libsamplerate, libsquish, libtiff, libvorbis, python3
, qt6, rustc, SDL2, zlib }:

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

  patches = [ ./invader-fixes.patch ];

  preConfigure = ''
    export CARGO_HOME=$(mktemp -d cargo-home.XXX)
  '';

  dontWrapQtApps = true;

  nativeBuildInputs = [ cacert cargo cmake corrosion python3 rustc ];
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
    (with darwin.apple_sdk.frameworks; [ AppKit ]);

  cmakeFlags = [
    "-DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/"
  ];

  meta = with lib; {
    homepage = "https://invader.opencarnage.net";
    description =
      "Free toolkit for Halo: Combat Evolved for creating maps and assets";
    platforms = platforms.all;
  };
}
