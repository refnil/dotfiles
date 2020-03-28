{ pkgs, libs, config, ...}:
let sources = import ../..;
    unstable = sources.nixos-unstable.outPath;
    foldingathome = "${unstable}/nixos/modules/services/computing/foldingathome/client.nix";
in
{

  disabledModules = [ "services/misc/folding-at-home.nix" ];
  imports = [ foldingathome ];

  services.foldingathome = {
    enable = true;
    package = pkgs.unstable.fahclient;
    user = "refnil";
  };
  environment.systemPackages = with pkgs.unstable; [ fahviewer fahcontrol ];
}
