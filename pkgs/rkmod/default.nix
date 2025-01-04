{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rkmod";
  version = "v0.1.0";

  src = fetchFromGitHub {
    owner = "edera-dev";
    repo = pname;
    rev = "61727a9cfed7e50b9e4353bd6630884dae42304b";
    hash = "sha256-h8XbScsVLaUT7F01NQqiMtQig/vQilIbua3sl1mbpj0=";
  };

  # useFetchCargoVendor = true;
  cargoHash = "sha256-Y86ztTIIxZ1t7AlyFhjUx+sJFwzzYKaVE2hCESl4mN4=";

  meta = with lib; {
    homepage = "https://github.com/edera-dev/rkmod";
    description = "libkmod in Rust";
    platforms = platforms.linux;
    license = with licenses; [ asl20 ];
  };
}
