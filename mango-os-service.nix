{ config, pkgs, ... }: {

  users.users.mango = {
    isSystemUser = true;
    home = "/var/lib/mango";
    createHome = true;
    group = "mango";
  };

  users.groups.mango = {};

  systemd.services.mango = {
    enable = true;
    description = "Mango";
    script = "${pkgs.mango-os}/bin/start-mango";
    environment = {
      mango_paths_data = "/var/lib/mango";
      JAVA_HOME = pkgs.jdk17_headless;
    };
    serviceConfig = {
      User = "mango";
      Group = "mango";
      Type = "forking";
      WorkingDirectory = "${pkgs.mango-os}";
      EnvironmentFile = "/var/lib/mango/ma.env";
      PIDFile = "/var/lib/mango/ma.pid";
      SuccessExitStatus = "0 SIGINT SIGTERM 130 143";
      Restart = "always";
      NoNewPrivileges = "true";
      LimitNOFILE = "1048576";
    };
    wantedBy = [ "multi-user.target" ];
  };

}
