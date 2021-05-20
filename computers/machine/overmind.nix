# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let 
  sources = import ../..;
  # For keyboardio
  kaleidoscope_src = sources.kaleidoscope.outPath;
in
{
  imports =
    [ 
      ../hardware/overmind.nix

      ../common/base.nix

      ../../home-folders/refnil/user.nix
      ../../home-folders/mlapointe/user.nix

      ../../services/tiddlywiki

      ../services/sage.nix

      ../services/dns
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  boot.kernelModules = [
    "v4l2loopback" # create a new webcam from software
    "uinput" # controller on steam
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  
  networking.hostName = "overmind"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  # Enable the KDE Desktop Environment.
  #services.xserver.desktopManager.plasma5.enable = true;

  # Set group for sudoers
  users.extraUsers.refnil.extraGroups = [ "wheel" "dialout" "docker" "libvirtd" "networkmanager" ];

  services.refnil.tiddlywiki = {
    enable = true;
    path = "/data/tiddlywiki";
    listenAddress = "127.0.0.1";
    httpPort = 30001;
  };

  services.gitea = {
    enable = true;
    httpPort = 30004;
    rootUrl = "http://git.refnil.ca/";
    stateDir = "/data/gitea";
  };

  services.hydra = {
    enable = false;
    hydraURL = "localhost:30005";
    port = 30005;
    notificationSender = "none@localhost.local";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };

  networking.firewall.allowedTCPPorts = [ 
    # 443

    # 8010 # For Chromecast support on vlc https://github.com/NixOS/nixpkgs/pull/58588
    # 8080 

    #Steam link https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
    # 27036 27037 #27015

    # 24800 # Barrier
  ];

  networking.firewall.allowedUDPPorts = [ 
    # Civ 6 ports
    # 62056 62900 62901 34197

    #Steam link
    # 27031 27036 #27015
  ];

  # GSConnect 
  networking.firewall.allowedUDPPortRanges = [
    # { from = 1716; to = 1764; }
  ];

  networking.firewall.allowedTCPPortRanges = [
    # { from = 1716; to = 1764; }
  ];

  services.udev = {
    #extraRules = builtins.readFile "${kaleidoscope_src}/etc/99-kaleidoscope.rules";
  };

  hardware.steam-hardware.enable = true;
  hardware.xpadneo.enable = true;

  services.udev.packages = [
    pkgs.steamPackages.steam
  ];

  # Pour faire marcher diablo 3
  systemd.extraConfig = ''
    DefaultLimitNOFILE=524288
  '';

  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=524288
  '';

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  services.grafana = {
    enable = false;
    port = 30006;
  };

  services.nginx = 
  let
     makeHosts = name: proxy:
     {
       virtualHosts = {
         "${name}.refnil.ca" = {
            locations."/" = {
              proxyPass = "http://${name}";
              proxyWebsockets = true;
            };
         };
       };
       upstreams = {
         "${name}" = {
           servers = {
             "${proxy}" = {};
           };
         };
       };
       /*
       "${name}.refnil.ca" = {
         onlySSL = true;
         enableACME = true;
         inherit locations;
       };
       */
     };
     /*
     server {
    }
    */
    remove-default-server =  {
      virtualHosts = {
        "_" = {
          extraConfig = ''
            deny all;
            return 444;
          '';
        };
      };
    };
  in 
  {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    inherit (with builtins; foldl' lib.attrsets.recursiveUpdate {} [
      (makeHosts "wiki" "localhost:30001")
      (makeHosts "sage" "localhost:30002")
      #(makeHosts "chat" 30003)
      (makeHosts "git" "localhost:30004")
      #(makeHosts "hydra" 30005)
      remove-default-server
    ]) virtualHosts upstreams;
  };
}
