{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.services.sage;
in {
    options.services.sage = {
    enable = mkEnableOption "sage service";

    path = mkOption {
      type = types.string;
    };

    httpPort = mkOption {
      type = types.int;
      default = 8080;
    };

    listenAddress = mkOption {
      type = types.string;
      default = "127.0.0.1";
    };

    userName = mkOption {
      type = types.string;
      default = "sage";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.httpPort ];
    systemd.services.sage = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = let ExecStart = pkgs.writeText "sage-service-exec-start" ''
          mkdir -p ${cfg.path}/home ${cfg.path}/jupyter
          chown sage ${cfg.path}/home ${cfg.path}/jupyter

          ${pkgs.sudo}/bin/sudo -H -u sage ${pkgs.sage}/bin/sage --notebook=jupyter --no-browser --ip=${cfg.listenAddress} --port=${toString cfg.httpPort} --notebook-dir=${cfg.path}/jupyter
         '';
      in "${pkgs.bash}/bin/bash ${ExecStart}";
    };

    users.extraUsers.sage = {
      isSystemUser = true;
      home = "${cfg.path}/home";
    };
  };
}
