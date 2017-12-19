{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mldonkey;

in {
  options = {
    services = {
      mldonkey = {
        enable = mkOption {
          default = false;
          description = "Start the mldonkey daemon";
        };

        openFilesLimit = mkOption {
          default = 4096;
          description = ''
            Number of files to allow mlnet to open.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.mldonkey = {
      after = [ "network.target" ];
      description = "mldonkey p2p daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mldonkey}/bin/mldonkey";
        Restart = "on-success";
        User = "mldonkey";
        Group = "mldonkey";
        LimitNOFILE = cfg.openFilesLimit;
      };
    };

    environment.systemPackages = [ pkgs.mldonkey ];

    users.extraUsers.mldonkey = {
      group = "mldonkey";
      uid = config.ids.uids.mldonkey;
      home = "/var/lib/mldonkey";
      createHome = true;
      description = "mldonkey user";
    };

    users.extraGroups.mldonkey.gid = config.ids.gids.mldonkey;
  };
}
