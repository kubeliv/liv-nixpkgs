{ config, pkgs, ... }: {

  users.users.artifakt = {
    isSystemUser = true;
    home = "/var/lib/artifakt";
    createHome = true;
  };

  systemd.services.artifakt-server = {
    enable = true;
    description = "Artifakt server";
    script = "${pkgs.artifakt-server}/bin/artifakt-server";
    environment = {
      JAVA_HOME = pkgs.jdk17_headless;
    };
    serviceConfig = {
      User = "artifakt";
      Group = "artifakt";
    };
    wantedBy = [ "multi-user.target" ];
  };

}
