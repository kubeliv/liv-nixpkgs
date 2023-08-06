{ config, pkgs, ... }: {

  systemd.services.artifakt-server = {
    enable = true;
    description = "Artifakt server";
    script = "${pkgs.artifakt-server}/bin/server";
    wantedBy = [ "multi-user.target" ];
  };

}
