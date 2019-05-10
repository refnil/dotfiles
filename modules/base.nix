# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let unstableTarball = builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/d34f44db4508cdcce96382cb80bd11fbe9c7d614.tar.gz";
      sha256 = "0mi032xs1jsak93wa7bqa6z2ingz91z0g2ncc2g9mb754mpxp6xb";
    };
in

{
  imports = [ ];

  fonts.fonts = [
    pkgs.corefonts

  ];
  
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable the OpenSSH daemon.
  services.openssh = {
  	enable = true;
	forwardX11 = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  system.autoUpgrade.enable = true;

  services.xserver = {
    enable = true;   
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };
    desktopManager.gnome3.enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  nixpkgs.config = {
    allowUnfree = true;
    useSandbox = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
}
