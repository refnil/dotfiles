{ config, pkgs, options, ... }:
{
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

  # Without any `nix.nixPath` entry:
  nix.nixPath =
    # Prepend default nixPath values.
    options.nix.nixPath.default ++ 
    # Append our nixpkgs-overlays.
    [ "nixpkgs-overlays=${./overlay-compat}" ]
  ;

  nixpkgs = {
    config = {
      allowUnfree = true;
      useSandbox = true;
    };
    overlays = [
      (import ./unstable.nix)
    ];
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;
}
