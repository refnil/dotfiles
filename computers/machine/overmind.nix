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

  # boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
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

  virtualisation.oci-containers.containers =
  # https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html
  let extraOptions = [
        # "--security-opt=no-new-privileges"
        # "--cap-drop all"
        # "--icc=false"
        # "--ulimit nofile=3000"
        # "--ulimit nproc=10"
      ];
  in {
    "heimdall" = {
      image = "linuxserver/heimdall";
      imageFile = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/heimdall";
        imageDigest = "sha256:2f03ab908ca635fbc38800fa7efa8b91f2795f95b83f7344521e01e349b8159f";
        sha256 = "1yad5yh9m59zd0ssjbpfm7qxisbk4r6gk3ik41s3kr3x2a9niys5";
        os = "linux";
        arch = "amd64";
      };
      volumes = [ "/data/heimdall:/config" ];
      ports = [ "30009:80" ];
      # inherit extraOptions;
    };
    "mealie" = {
      image = "hkotel/mealie";
      imageFile = pkgs.dockerTools.pullImage {
        imageName = "hkotel/mealie";
        imageDigest = "sha256:b7d576b0bb19112d10d16a0538b9685fe7bcd13df89ede559c476a23567e3da8";
        sha256 = "1z2b32irap8q586w9k8gxp9ky1nvyb2j8gzsl2f87r2y9zxp3smj";
        os = "linux";
        arch = "amd64";
      };
      environment = {
        db_type = "sqlite";
      };
      volumes = [ "/data/mealie/:/app/data/" ];
      ports = [ "30010:80"];
      # inherit extraOptions;
    };
  };

  users.extraUsers = {
    # Set group for sudoers
    refnil.extraGroups = [ "wheel" "dialout" "docker" "libvirtd" "networkmanager" ];

    dockremap = {
      isSystemUser = true;
      uid = 10000;
      group = "dockremap";
      subUidRanges = [
        { startUid = 100000; count = 65536; }
      ];
      subGidRanges = [
        { startGid = 100000; count = 65536; }
      ];
    };
  };
  users.groups.dockremap.gid = 10000;

  networking.firewall.allowedTCPPorts = [ 
    80
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

  virtualisation.docker = {
    enable = true;
    extraOptions = "--userns-remap=default";
  };
  virtualisation.libvirtd.enable = true;

  services.prometheus = {
    enable = true;
    exporters = {
      nginx.enable = true;
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
    };

    scrapeConfigs = [{
      job_name = "prometheus";
      scrape_interval = "5s";
      static_configs = [{
        targets = [
          "localhost:9090" # prometheus
          "localhost:9100" # node exporter
          "localhost:9113" # nginx
          "localhost:30002" # jupyter notebook
        ];
      }];
    }];
  };

  services.grafana = {
    enable = true;
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
     };
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
    statusPage = true;

    inherit (with builtins; foldl' lib.attrsets.recursiveUpdate {} [
      (makeHosts "wiki" "localhost:30001")
      (makeHosts "sage" "localhost:30002")
      #(makeHosts "chat" 30003)
      (makeHosts "git" "localhost:30004")
      #(makeHosts "hydra" 30005)
      (makeHosts "hub" "localhost:30009")
      (makeHosts "grafana" "localhost:30006")
      (makeHosts "meal" "localhost:30010")
      remove-default-server
    ]) virtualHosts upstreams;
  };
}
