{ config, pkgs, ... }:
let 
  home-manager-src = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "3f4563018010e2ad180d99d9cd876187e2905cee";
    ref = "master";
    #sha256 = "11nq06d131y4wmf3drm0yk502d2xc6n5qy82cg88rb9nqd2lj41k";
  };

  home-manager = pkgs.home-manager.overrideAttrs (oldAttrs:
  {
    src = home-manager-src;
  }
  );
in
{
  /*
  imports = [
    "${home-manager-src}/nixos"
  ];

  home-manager = {
    verbose = true;
    useUserPackages = true;
    users.refnil = import ../../home-folders/refnil/home.nix;
  };
  */

  programs.fish.enable = true;
  users.users.refnil = {
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [
      ./pub_keys/id_overmind.pub
      ./pub_keys/id_cerebrate.pub
      ./pub_keys/id_saladin.pub
      ./pub_keys/id_aiur.pub
    ];
  };
}
