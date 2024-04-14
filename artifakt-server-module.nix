{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.artifakt-server;
in
{
  options = {
    services.artifakt-server = {
      config-file = mkOption {
        type = types.path;
        description = lib.mdDoc "Path to config file.";
        default = "/etc/artifakt/config.yaml";
      };
    };
  };

  config = {
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
        "${pkgs.artifakt-server}/bin/artifakt-server --config ${cfg.config-file} --database /var/lib/artifakt/server.db";
      environment = { JAVA_HOME = pkgs.jdk17_headless; };
      serviceConfig = {
        User = "artifakt";
        Group = "artifakt";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
