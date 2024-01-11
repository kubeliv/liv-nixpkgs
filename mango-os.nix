{ lib, stdenv, fetchurl, unzip, jdk17_headless, curl, jq, makeWrapper }:

stdenv.mkDerivation {
  pname = "mango-os";
  version = "5.1.0";

  src = fetchurl {
    url = "https://store.mango-os.com/downloads/fullCores/enterprise-m2m2-core-5.1.0.zip";
    sha256 = "sha256:c415c0d449844882865a9d27b7fa0d4f6b23eea29ddb2023ee3904ac05334119";
  };

  buildInputs = [ unzip jdk17_headless curl jq makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    unzip $src -d $out
    pushd $out
    MA_GUID=2-cd8269e6-8d57-429b-b314-8b7f2b998662 mango_paths_data=tmp-data java -jar ./boot/ma-bootstrap.jar &
    pid=$!
    success=false
    while [ "$success" == "false" ]; do
      if [ "$(curl http://localhost:8080/status | jq '.stateValue')" == "200" ]; then success="true"; fi
      sleep 1
    done
    kill $pid
    rm -r tmp-data
    popd
    mv $out/bin/start-mango.sh $out/bin/start-mango
    wrapProgram $out/bin/start-mango --prefix PATH : ${lib.makeBinPath [ jdk17_headless ]}
  '';

  meta = with lib; {
    homepage = "https://mango-os.com";
    description = "Mango OS (enterprise edition)";
    platforms = platforms.unix;
  };
}
