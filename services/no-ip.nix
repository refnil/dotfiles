{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.services.no-ip;
in {
    options.services.no-ip = {
    enable = mkEnableOption "no-ip ddns service";

    config-file = mkOption {
      type = types.string;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.no-ip;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.no-ip = {
      wantedBy = [ "multi-user.target" ];
      scripts = ''
        ${cfg.package + /bin/bash} -C ${cfg.config-file}
      '';
      serviceConfig = {
        User = "no-ip";
      };
    };

    users.extraUsers.no-ip = {
      description = "No-ip ddns service user";
      createHome = false;
    };
  };
}
