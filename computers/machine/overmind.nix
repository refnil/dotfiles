# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let 
  sources = import ../..;
  # For keyboardio
  kaleidoscope_src = sources.kaleidoscope.outPath;

  no-ip = pkgs.callPackage ../../packages/no-ip {};
in
{
  imports =
    [ 
      ../hardware/overmind.nix

      ../common/base.nix
      # ../common/vfio.nix

      ../../home-folders/refnil/user.nix
      ../../home-folders/mlapointe/user.nix

      ../../services/tiddlywiki
      ../../services/sage
      ../../services/no-ip
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
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
  users.extraUsers.refnil.extraGroups = [ "wheel" "dialout" "docker" "libvirtd" ];

  services.refnil.tiddlywiki = {
    enable = true;
    path = "/data/tiddlywiki";
    pathPrefix = "/wiki";
    listenAddress = "127.0.0.1";
    httpPort = 30001;
  };

  services.sage = {
    enable = true;
    path = "/data/sage";
    listenAddress = "0.0.0.0";
    baseURL = "sage";
    httpPort = 30002;
    package = pkgs.unstable.sage;
  };

  services.gitea = {
    enable = true;
    httpPort = 30004;
    rootUrl = "http://%(DOMAIN)s:%(HTTP_PORT)s/";
    stateDir = "/data/gitea";
  };

  services.mattermost = {
    enable = true;
    statePath = "/data/mattermost";
    siteUrl = "http://localhost:30003";
    listenAddress = ":30003";
  };

  services.hydra = {
    enable = false;
    hydraURL = "localhost:30005";
    port = 30005;
    notificationSender = "none@localhost.local";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };

  services.nextcloud = {
    enable = false;
    hostName = "localhost";
    home = "/data/nextcloud";
    nginx.enable = true;
    config = {
      adminpassFile = "/data/nextcloud/password";
    };
  };

  /*
  services.factorio = {
     enable = false;
     stateDir = "/data/factorio";
     game-name = "factorio";
     lan = true;
     autosave-interval = 5;
  };
  */

  services.no-ip = {
    enable = true;

    config-file = "/data/no-ip/no-ip.conf";
    package = no-ip;
  };

  networking.firewall.allowedTCPPorts = [ 
    443

    8010 # For Chromecast support on vlc https://github.com/NixOS/nixpkgs/pull/58588
    8080 

    # Babybuddy
    30008

    #Steam link https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
    27036 27037 #27015
  ];

  networking.firewall.allowedUDPPorts = [ 
    # Civ 6 ports
    62056 62900 62901 34197

    #Steam link
    27031 27036 #27015
  ];

  systemd.services.babybuddy = {
    wantedBy = ["multi-user.target"];
    requires = ["docker.service"];
    script = ''
      ${pkgs.docker-compose}/bin/docker-compose -f /home/refnil/workbench/babybuddy/docker-compose.yml up
    '';
    serviceConfig.User = "refnil";
  };


  services.udev = {
    extraRules = builtins.readFile "${kaleidoscope_src}/etc/99-kaleidoscope.rules";
  };

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
    enable = true;
    port = 30006;
  };

  /*
  // https://unix.stackexchange.com/questions/421325/wake-on-lan-via-ssh
  services.wakeonlan.interfaces = [
    {
      interface = "enp3s0";
      method = "unicast";
    }
  ];
  */

  services.nginx = 
  let
     makeHosts = name: port: 
     let
       upstreamName = "localhost:${toString port}";
       backendURL = "http://${upstreamName}/";
       upstreamURL = "http://${name}/";

       proxyURL  = "http://localhost:${toString port}/${name}/";
     in
     {
       virtualHosts = {
         "${name}.localhost" = {
           locations."/" = {
             return = "301 http://localhost/${name}/";
           };
         };
         "localhost" = {
           locations."/${name}/" = {
             proxyPass = proxyURL;
             proxyWebsockets = true;
           };
         };
       };
       upstreams = {
         "${name}" = {
           servers = {
             "${upstreamName}" = {};
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
  in 
  {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    inherit (with builtins; foldl' lib.attrsets.recursiveUpdate {} [
      (makeHosts "wiki" 30001)
      (makeHosts "sage" 30002)
      (makeHosts "chat" 30003)
      (makeHosts "git" 30004)
      #(makeHosts "hydra" 30005)
    ]) virtualHosts upstreams;
  };
}
