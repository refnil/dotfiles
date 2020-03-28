{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.refnil.networking.wireguard;
in {
  options.refnil.networking.wireguard = {
    enable = mkEnableOption "wireguard networking";

    interfaceName = mkOption {
      type = types.str;
      default = "wg0";
    };

    port = mkOption {
      type = types.int;
      default = 51820;
    };

    ip = mkOption {
      type = types.str;
    };

    peers = mkOption {
      type = types.list;
      default = [];
    };

    privateKeyFile = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      nat = {
        enable = true;
        externalInterface = "eth0";
        internalInterfacse = [ cfg.interfaceName ];
      };
      firewall.allowedTCPPorts = [ cfg.port];

      wireguard = {
        "${cfg.interfaceName}" = {
          ips = [cfg.ip];
          listenPort = cfg.port;
          peers = cfg.peers;
        };
      };
    };
  };
}
