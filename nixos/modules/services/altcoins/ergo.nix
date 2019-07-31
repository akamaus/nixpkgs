{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ergo;

in {
  options = {
    services = {
      ergo = {
        enable = mkOption {
          default = false;
          description = "Start ergo full-node";
        };

        testnet = mkOption {
          type = types.bool;
          default = true;
          description = ''whether to use testnet instead of mainnet'';
        };

        loglevel = mkOption {
          type = types.types.enum [ "DEBUG" "INFO" "WARN" "ERROR" ];
          default = "INFO";
          description = ''verbosity level, INFO is quite noisy'';
        };

        configFile = mkOption {
          type = types.string;
          default = "ergo.cfg";
          description = ''
            Path to config file (should be protected from strangers)
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.ergo = {
      after = [ "network.target" ];
      description = "Ergo full-node daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ergo}/bin/ergo --mainnet -c ${cfg.configFile}";
        WorkingDirectory = config.users.extraUsers.ergo.home;
        Environment="JAVA_OPTS='-Dlogback.stdout.level=${cfg.loglevel}'";
        Restart = "on-success";
        User = "ergo";
        Group = "ergo";
      };
    };

    environment.systemPackages = [ pkgs.altcoins.ergo ];

    users.extraUsers.ergo = {
      group = "ergo";
      uid = config.ids.uids.ergo;
      home = "/var/lib/ergo";
      createHome = true;
      description = "ergo user";
    };

    users.extraGroups.ergo.gid = config.ids.gids.ergo;
  };
}
