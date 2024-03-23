{ lib, stdenv, fetchurl, unzip, jdk17_headless, curl, jq, gawk, makeWrapper }:

stdenv.mkDerivation {
  pname = "mango-os";
  version = "5.1.1";

  src = fetchurl {
    url =
      "https://store.mango-os.com/downloads/fullCores/enterprise-m2m2-core-5.1.1.zip";
    sha256 =
      "sha256:5f7f98db3d61213f1bf4fdf7266d7abbb3ba4d173aa443fda0ad660ef3ab0b97";
  };

  buildInputs = [ unzip jdk17_headless curl jq gawk makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    port=16998
    nport=16999
    mkdir -p $out
    unzip $src -d $out
    pushd $out
    mkdir tmp-data
    echo "web.port=$port" > tmp-data/mango.properties
    echo "ssl.port=$nport" >> tmp-data/mango.properties
    MA_GUID=2-cd8269e6-8d57-429b-b314-8b7f2b998662 mango_paths_data=tmp-data java -jar ./boot/ma-bootstrap.jar &
    pid=$!
    success=false
    while [ "$success" == "false" ]; do
      if [ "$(curl -s http://localhost:$port/status | jq '.stateValue')" == "200" ]; then success="true"; fi
      sleep 1
    done
    kill $pid
    sleep 3
    rm -r tmp-data
    popd
    rm $out/bin/{mango.cmd,mango.service,mango.xml,README.md,certbot-deploy.sh,install-mango.sh}
    mv $out/bin/start-mango.sh $out/bin/start-mango
    mv $out/bin/stop-mango.sh $out/bin/stop-mango
    wrapProgram $out/bin/start-mango --set mango_paths_home $out --prefix PATH : ${
      lib.makeBinPath [ jdk17_headless gawk ]
    }
    wrapProgram $out/bin/stop-mango --set mango_paths_home $out --prefix PATH : ${
      lib.makeBinPath [ jdk17_headless gawk ]
    }
  '';

  meta = with lib; {
    homepage = "https://mango-os.com";
    description = "Mango OS (enterprise edition)";
    platforms = platforms.unix;
  };
}
