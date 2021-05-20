{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.services.sage;
in {
    options.services.sage = {
    enable = mkEnableOption "sage service";

    path = mkOption {
      type = types.str;
    };

    httpPort = mkOption {
      type = types.int;
      default = 8080;
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
    };

    baseURL = mkOption {
      type = types.str;
      default = "";
    };

    userName = mkOption {
      type = types.str;
      default = "sage";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sage;
    };

    hostname = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.httpPort ];
    systemd.services.sage = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.User = "sage";
      preStart = ''
          mkdir -p ${cfg.path}/jupyter
      '';
      script = let 
        confFile = pkgs.writeText "jupyter-conf.py" ''
          ${optionalString (cfg.baseURL != "")
          "c.NotebookApp.base_url = ${cfg.baseURL}"
          }
          ${optionalString (cfg.hostname != "")
          "c.NotebookApp.local_hostnames = ['localhost', '${cfg.hostname}']"
          }
        '';
      in ''
          ${cfg.package}/bin/sage --notebook=jupyter --no-browser --ip=${cfg.listenAddress} --port=${toString cfg.httpPort} --notebook-dir=${cfg.path}/jupyter  --config=${confFile}
      '';
    };

    users.extraUsers.sage = {
      isSystemUser = true;
      useDefaultShell = true;
      home = "${cfg.path}";
      createHome = true;
    };
  };
}
