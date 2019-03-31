# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ../hardware/overmind.nix
      ../base.nix
      # ../vfio.nix

      ../user/refnil.nix
      ../user/mlapointe.nix

      ../services/tiddlywiki.nix
      ../services/sage.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "overmind"; # Define your hostname.

  # Enable the X11 windowing system.
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  # Enable the KDE Desktop Environment.
  #services.xserver.desktopManager.plasma5.enable = true;

  # Set group for sudoers
  users.extraUsers.refnil.extraGroups = [ "wheel" ];

  services.tiddlywiki = {
    enable = true;
    path = "/data/tiddlywiki";
    listenAddress = "0.0.0.0";
    httpPort = 30001;
  };

  services.sage = {
    enable = true;
    path = "/data/sage";
    listenAddress = "0.0.0.0";
    httpPort = 30002;
    package = pkgs.unstable.sage;
  };

  services.gitea = {
    enable = true;
    httpPort = 30004;
    stateDir = "/data/gitea";
  };

  services.mattermost = {
    enable = true;
    statePath = "/data/mattermost";
    siteUrl = "http://localhost:30003";
    listenAddress = ":30003";
  };

  services.hydra = {
    enable = true;
    hydraURL = "localhost:30005";
    port = 30005;
    notificationSender = "none@localhost.local";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };

  services.factorio = {
     enable = false;
     stateDir = "/data/factorio";
     game-name = "factorio";
     lan = true;
     autosave-interval = 5;
  };

  networking.firewall.allowedTCPPorts = [ 
    8080 

    #Steam link https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
    27036 27037 #27015
  ];

  networking.firewall.allowedUDPPorts = [ 
    # Civ 6 ports
    62056 62900 62901 34197

    #Steam link
    27031 27036 #27015
  ];
}
