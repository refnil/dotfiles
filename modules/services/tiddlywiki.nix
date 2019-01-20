{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.services.tiddlywiki;
in {
    options.services.tiddlywiki = {
    enable = mkEnableOption "tiddlywiki service";
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
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tiddlywiki = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = let ExecStart = pkgs.writeText "tiddlywiki_start" ''
           if [ -z "$(ls -A ${cfg.path})" ]; then
             ${pkgs.nodePackages.tiddlywiki}/bin/tiddlywiki ${cfg.path} --init server
           fi
           ${pkgs.nodePackages.tiddlywiki}/bin/tiddlywiki ${cfg.path} --server ${toString cfg.httpPort} $:/core/save/all text/plain text/html "" "" ${cfg.listenAddress}
         '';
      in "${pkgs.bash}/bin/bash ${ExecStart}";
    };
  };
}
