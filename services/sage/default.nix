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
    systemd.services.sage = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.userName;
        Nice = 15;
      };
      preStart = ''
          mkdir -p ${cfg.path}/jupyter
      '';
      script = ''
          ${cfg.package}/bin/sage --notebook=jupyter --no-browser \
            --NotebookApp.authenticate_prometheus=False \
            --NotebookApp.local_hostnames=localhost \
            --ip=${cfg.listenAddress} --port=${toString cfg.httpPort} --notebook-dir=${cfg.path}/jupyter \
            ${optionalString (cfg.baseURL != "") "--NotebookApp.base_url=${cfg.baseURL}"} \
            ${optionalString (cfg.hostname != "") "--NotebookApp.local_hostnames=${cfg.hostname}"} \
      '';
    };

    users.extraUsers."${cfg.userName}" = {
      isSystemUser = true;
      useDefaultShell = true;
      home = "${cfg.path}";
      createHome = true;
    };
  };
}
