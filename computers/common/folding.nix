{ pkgs, libs, config, ...}:
let sources = import ../..;
    unstable = toString sources.nixos-unstable;
    foldingathome = "${unstable}/nixos/modules/services/computing/foldingathome/client.nix";
in
{
  disabledModules = [ "services/misc/folding-at-home.nix" ];
  imports = [ 
    foldingathome 
    ./unstable.nix
  ];

  services.foldingathome = {
    enable = true;
    package = pkgs.unstable.fahclient;
    user = "refnil";
  };
  environment.systemPackages = with pkgs.unstable; [ fahviewer fahcontrol ];
}
