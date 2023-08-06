{ config, pkgs, ... }: {

  systemd.services.artifakt-server = {
    enable = true;
    description = "Artifakt server";
    script = "${pkgs.artifakt-server}/bin/artifakt-server";
    path = with pkgs; [
      jdk17_headless
    ];
    environment = {
      JAVA_HOME = pkgs.jdk17_headless;
    };
    wantedBy = [ "multi-user.target" ];
  };

}
