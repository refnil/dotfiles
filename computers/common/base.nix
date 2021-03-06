{ config, pkgs, options, ... }:
{
  imports = [
    ./unstable.nix
  ];

  fonts.fonts = [
    pkgs.corefonts
  ];
  
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Enable the OpenSSH daemon.
  services.openssh = {
  	enable = true;
    forwardX11 = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    opengl = { 
      extraPackages = with pkgs; [ libva ];
      driSupport32Bit = true;
    };
  };

  services.xserver = {
    enable = true;   
    autorun = true;
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
  system.stateVersion = "20.09"; # Did you read the comment?

  nix.useSandbox = true;
  nixpkgs = {
    pkgs = import (import ../..).nixos-stable {
      inherit (config.nixpkgs) config;
    };
    config = {
      allowUnfree = true;
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;

  documentation.doc.enable=false;
  documentation.info.enable = false;

  programs.bcc.enable = true;
}

