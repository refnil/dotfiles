# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.users.mlapointe= {
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      ./mlapointe_pub_keys/aiur.pub
    ];
  };

}
