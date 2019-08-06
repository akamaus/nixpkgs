{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ergo-gpu-miner;

in {
  options = {
    services = {
      ergo-gpu-miner = {
        enable = mkOption {
          default = false;
          description = "Start ergo autokylos miner";
        };

        configFile = mkOption {
          type = types.string;
          default = "settings.json";
          description = ''
            Path to config file (should be protected from strangers)
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.ergo-gpu-miner = {
      after = [ "ergo.service" ];
      description = "Ergo full-node daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ergo-autolykos-gpu-miner}/bin/ergo-autolykos-gpu-miner ${cfg.configFile}";
        Environment="LD_LIBRARY_PATH=/run/opengl-driver/lib";
        WorkingDirectory = config.users.extraUsers.ergo.home;
        Restart = "on-success";
        User = "ergo";
        Group = "ergo";
      };
    };

    environment.systemPackages = [ pkgs.ergo-autolykos-gpu-miner ];
  };
}
