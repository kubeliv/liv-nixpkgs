{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "redscript";
  version = "v0.5.27";

  src = fetchFromGitHub {
    owner = "jac3km4";
    repo = pname;
    rev = version;
    hash = "sha256-2MTwlNqHFY+FWygvMQW0yI3vwgruQYfqeBx9k5m09RA=";
  };

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-GhEQRYuuWb2Dxd8DnYTxhfrkzDprcqI8s7znmcaj/7s=";

  meta = with lib; {
    homepage = "https://github.com/jac3km4/redscript";
    description = "Compiler/decompiler toolkit for redscript";
    platforms = platforms.unix;
    license = with licenses; [ mit ];
  };
}
