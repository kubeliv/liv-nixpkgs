{ lib, config, pkgs, ... }:

# Some content borrowed from
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/misc/apache-kafka.nix

with lib;

let
  cfg = config.services.mango-os;

  mkPropertyString = let
    render = {
      bool = boolToString;
      int = toString;
      list = concatMapStringsSep "," mkPropertyString;
      string = id;
    };
  in v: render.${builtins.typeOf v} v;

  stringlySettings =
    mapAttrs (_: mkPropertyString) (filterAttrs (_: v: v != null) cfg.settings);

  settingsFormat = pkgs.formats.javaProperties { };
  generator = settingsFormat.generate;
in {
  options = {
    services.mango-os = {
      enable = mkEnableOption (lib.mdDoc "mango-os");
      settings = mkOption {
        description =
          lib.mdDoc "Mango configuration that isn't built up with Nix.";
        type = types.submodule {
          freeformType = settingsFormat.type;

          options = {
            "properties.reloading" = mkOption {
              type = types.bool;
              description = lib.mdDoc
                "Redundant option for NixOS because the properties file is read only.";
              default = false;
            };
            "installation.immutable" = mkOption {
              type = types.bool;
              description = lib.mdDoc
                "Make the installation immutable - this will disable upgrades.";
              default = true;
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
            "db.h2.filesystem" = mkOption {
              type = types.str;
              description = lib.mdDoc "H2 database filesystem to use.";
              default = "file";
            };
            "db.h2.shutdownCompact" = mkOption {
              type = types.bool;
              description =
                lib.mdDoc "Whether to compact the H2 database on shutdown.";
              default = false;
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
            "convert.db.type" = mkOption {
              type = types.str;
              description = lib.mdDoc "Type of database to convert from.";
              default = "";
            };
            "convert.db.url" = mkOption {
              type = types.str;
              description = lib.mdDoc "URL of database to convert from.";
              default = "";
            };
            "convert.db.username" = mkOption {
              type = types.str;
              description = lib.mdDoc "Username of database to convert from.";
              default = "";
            };
            "convert.db.password" = mkOption {
              type = types.str;
              description = lib.mdDoc "Password of database to convert from.";
              default = "";
            };
            "db.nosql.enabled" = mkOption {
              type = types.bool;
              description = lib.mdDoc "Enable the NoSQL database.";
              default = true;
            };
            "db.nosql.location" = mkOption {
              type = types.str;
              description = lib.mdDoc
                "Base path where NoSQL data will be stored, relative to data path.";
              default = "databases";
            };
            "db.nosql.pointValueStoreName" = mkOption {
              type = types.str;
              description =
                lib.mdDoc "Directory name of the point value store.";
              default = "mangoTSDB";
            };
            "db.nosql.maxOpenFiles" = mkOption {
              type = types.ints.unsigned;
              description =
                lib.mdDoc "Number of files allowed to be open at one time.";
              default = 500;
            };
            "store.url" = mkOption {
              type = types.str;
              description = lib.mdDoc "URL for Mango Store.";
              default = "https://store.mango-os.com";
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
            "rest.enabled" = mkOption {
              type = types.bool;
              description = lib.mdDoc "Enable the Mango REST API";
              default = true;
            };
            "sessionCookie.useGuid" = mkOption {
              type = types.bool;
              description = lib.mdDoc "Use GUID for session cookie.";
              default = true;
            };
            "sessionCookie.name" = mkOption {
              type = types.str;
              description = lib.mdDoc "";
              default = "";
            };
            "sessionCookie.domain" = mkOption {
              type = types.str;
              description = lib.mdDoc "";
              default = "";
            };
            "sessionCookie.persistent" = mkOption {
              type = types.bool;
              description = lib.mdDoc "";
              default = true;
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.mango-os.settings = { };

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
        TimeoutStopSec = "600";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
