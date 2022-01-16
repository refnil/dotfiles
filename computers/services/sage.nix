{ pkgs, config, ... }:
{
  imports = [
    ../../services/sage
  ];

  services.sage = {
    enable = true;
    path = "/data/sage";
    httpPort = 30002;
    package = pkgs.unstable.sage;
    hostname = "sage.refnil.ca";
  };
}
