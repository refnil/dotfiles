{ config, pkgs, ... }:
{
  programs.fish.enable = true;
  users.users.refnil = {
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [
      ./pub_keys/id_overmind.pub
      ./pub_keys/id_cerebrate.pub
      ./pub_keys/id_saladin.pub
      ./pub_keys/id_aiur.pub
      ./pub_keys/id_phone.pub
    ];
  };
}
