# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ];
  
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

    displayManager.sddm.enable = true;
    #videoDrivers = [ "nvidia" ];
    desktopManager = {
      plasma5.enable = true;
    };

    windowManager.i3.enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

  nixpkgs.config.allowUnfree = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
}
