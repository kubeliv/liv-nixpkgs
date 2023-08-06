{ config, pkgs, ... }: {

  systemd.services.artifakt-server = {
    enable = true;
    description = "Artifakt server";
    script = "${pkgs.artifakt-server}/bin/artifakt-server";
    wantedBy = [ "multi-user.target" ];
  };

}
