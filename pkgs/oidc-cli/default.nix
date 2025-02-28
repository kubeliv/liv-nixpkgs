{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "oidc-cli";
  version = "v0.4.1";

  src = fetchFromGitHub {
    owner = "ctron";
    repo = pname;
    rev = version;
    hash = "sha256-RLs23CS5Xt7godAtHX6HnU8Rg/6XA47xAQ2bka0pmT4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-dnseDThukj5wNfigcbzkEJCBoGYLYfTOv8h07ZZtmbw=";

  meta = with lib; {
    homepage = "https://github.com/ctron/oidc-cli";
    description = "A command line tool to work with OIDC tokens";
    platforms = platforms.unix;
    license = with licenses; [ asl20 ];
  };
}
