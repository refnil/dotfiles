{ config, pkgs, options, ... }:
let sources = import ../..;
in {
  imports = [
    ./unstable.nix
  ];

  fonts.fonts = [
    pkgs.corefonts
  ];
  
  # Set your time zone.
  time.timeZone = "America/Halifax";

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
    desktopManager.gnome.enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?

  nix = {
    # package = pkgs.nixUnstable;
    useSandbox = true;
    gc = {
      automatic = false;
      options = "--delete-older-than 30d";
    };
    autoOptimiseStore = true;
    nixPath = [
      "nixpkgs=${sources.nixos-stable.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
    # add flake in options if you want
    # extraOptions = ''
      # experimental-features = nix-command
    # '';
  };
  nixpkgs = {
    pkgs = import sources.nixos-stable {
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

  # programs.bcc.enable = true; # kernel tracing and manipulation programs

  # Binary Cache for Haskell.nix
  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.binaryCaches = [
    "https://hydra.iohk.io"
  ];
}
