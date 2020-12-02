{ pkgs, config, ... }:
let working_sage_src = pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "c0bd938e5ca4b5c2f789c3d937c9ce344e5cf7ae";
      sha256 = "1yw44xfjkxg0pqkzrawq8n9brjph9y0dr9pydl3lhjll492c856c";
    };
    working_sage_nixpkgs = import working_sage_src { inherit (config.nixpkgs) config; };
    sage = working_sage_nixpkgs.sage;
in {
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
    package = sage;
  };
}
