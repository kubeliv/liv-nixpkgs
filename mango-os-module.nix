{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.mango-os;

  # Borrowed from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/misc/apache-kafka.nix
  mkPropertyString = let
    render = {
      bool = boolToString;
      int = toString;
      list = concatMapStringsSep "," mkPropertyString;
      string = id;
    };
  in
    v: render.${builtins.typeOf v} v;

  stringlySettings = mapAttrs (_: mkPropertyString)
    (filterAttrs (_: v:  v != null) cfg.settings);

  generator = (pkgs.formats.javaProperties {}).generate;
in
{
  options = {
    services.mango-os = {
      enable = mkEnableOption (lib.mdDoc "mango-os");
      settings = {
        "properties.reloading" = mkOption {
          type = types.bool;
          description = lib.mdDoc "Redundant option for NixOS because the properties file is read only.";
          default = false;
        };
        "web.port" = mkOption {
          type = types.port;
          description = lib.mdDoc "Port for the HTTP server to listen on.";
          default = 8080;
        };
        "web.host" = mkOption {
          type = types.str;
          description = lib.mdDoc "Host for the HTTP server to listen on.";
          default = "localhost";
        };
        "web.openBrowserOnStartup" = mkOption {
          type = types.bool;
          description = lib.mdDoc "Open browser on Mango start.";
          default = false;
        };
        "db.type" = mkOption {
          type = types.enum [ "h2" "mysql" "postgres" ];
          description = lib.mdDoc "Type of database used to host Mango.";
          default = "h2";
        };
        "db.url" = mkOption {
          type = types.str;
          description = lib.mdDoc "URL of database, in JDBC URL form.";
          default = "jdbc:h2:databases/mah2";
        };
        "db.username" = mkOption {
          type = types.str;
          description = lib.mdDoc "Username of database to log in to.";
          default = "";
        };
        "db.pool.maxActive" = mkOption {
          type = types.ints.unsigned;
          description = lib.mdDoc "Maximum active database connections.";
          default = 100;
        };
        "db.pool.maxIdle" = mkOption {
          type = types.ints.unsigned;
          description = lib.mdDoc "Maximum idle database connections.";
          default = 10;
        };
        "db.nosql.enabled" = mkOption {
          type = types.bool;
          description = lib.mdDoc "Enable the NoSQL database.";
          default = true;
        };
        "db.nosql.location" = mkOption {
          type = types.str;
          description = lib.mdDoc "Base path where NoSQL data will be stored, relative to data path.";
          default = "databases";
        };
        "db.nosql.pointValueStoreName" = mkOption {
          type = types.str;
          description = lib.mdDoc "Directory name of the point value store.";
          default = "mangoTSDB";
        };
        "db.nosql.maxOpenFiles" = mkOption {
          type = types.ints.unsigned;
          description = lib.mdDoc "Number of files allowed to be open at one time.";
          default = 500;
        };
        "ssl.on" = mkOption {
          type = types.bool;
          description = lib.mdDoc "Enable HTTPS server.";
          default = true;
        };
        "ssl.port" = mkOption {
          type = types.port;
          description = lib.mdDoc "Port for the HTTPS server to listen on.";
          default = 8443;
        };
        "store.url" = mkOption {
          type = types.str;
          description = lib.mdDoc "URL for Mango Store.";
          default = "https://store.mango-os.com";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.mango = {
      isSystemUser = true;
      home = "/var/lib/mango";
      createHome = true;
      group = "mango";
    };

    users.groups.mango = { };

    systemd.services.mango = {
      enable = true;
      description = "Mango";
      script = "${pkgs.mango-os}/bin/start-mango";
      environment = {
        mango_paths_data = "/var/lib/mango";
        mango_config = generator "mango.properties" stringlySettings;
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
  };
}
