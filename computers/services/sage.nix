{ pkgs, ... }:
{
  imports = [
    ../common/unstable.nix
    ../../services/sage
  ];

  services.sage = {
    enable = true;
    path = "/data/sage";
    listenAddress = "0.0.0.0";
    baseURL = "sage";
    httpPort = 30002;
    package = pkgs.sage;
  };
}
