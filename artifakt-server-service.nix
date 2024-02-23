{ config, pkgs, ... }: {

  users.users.artifakt = {
    isSystemUser = true;
    home = "/var/lib/artifakt";
    createHome = true;
    group = "artifakt";
  };

  users.groups.artifakt = { };

  systemd.services.artifakt-server = {
    enable = true;
    description = "Artifakt server";
    script =
      "${pkgs.artifakt-server}/bin/artifakt-server --config /etc/artifakt/server.yaml --database /var/lib/artifakt/server.db";
    environment = { JAVA_HOME = pkgs.jdk17_headless; };
    serviceConfig = {
      User = "artifakt";
      Group = "artifakt";
    };
    wantedBy = [ "multi-user.target" ];
  };

}
