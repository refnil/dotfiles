# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  programs.fish.enable = true;
  users.users.refnil = {
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [
      ./refnil_pub_keys/id_overmind.pub
    ];
  };

}
