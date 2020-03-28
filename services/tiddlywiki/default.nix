{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.services.refnil.tiddlywiki;
in {
    options.services.refnil.tiddlywiki = {
    enable = mkEnableOption "tiddlywiki service";

    path = mkOption {
      type = types.str;
    };

    pathPrefix = mkOption {
      type = types.str;
      default = "";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nodePackages.tiddlywiki;
    };

    httpPort = mkOption {
      type = types.int;
      default = 8080;
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.httpPort ];
    systemd.services.tiddlywiki = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.User = "tiddlywiki";
      preStart = ''
        if [ -z "$(ls -A ${cfg.path})" ]; then
          ${cfg.package}/bin/tiddlywiki ${cfg.path} --init server
        fi
      '';
      script = ''
        ${cfg.package}/bin/tiddlywiki ${cfg.path} --server ${toString cfg.httpPort} $:/core/save/all text/plain text/html "" "" ${cfg.listenAddress} "${cfg.pathPrefix}"
      '';
    };
    users.extraUsers.tiddlywiki = {
      isSystemUser = true;
      createHome = true;
      home = cfg.path;
    };
  };
}
