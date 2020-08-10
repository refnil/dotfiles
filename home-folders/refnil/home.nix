{ pkgs, config,  ...}:
with pkgs;
let 
  sources = import ../..;

  unstable = import sources.nixos-unstable { config = { allowUnfree = true; }; };

  nur = import sources.nur { pkgs = unstable; };

  niv = import sources.niv {};
in
{
  imports = [ 
    ./home-bootstrap.nix 
    ./vim.nix
  ];

  programs.home-manager.path = lib.mkForce (toString sources.home-manager);

  home.packages = [
    git
    gitAndTools.git-annex
    lsof
    unzip
    ripgrep
    evince 
    keepass
    xdotool
    libreoffice
    calibre
    killall
    fd

    bat # "Better" cat
    bup
    python3Full
    python36Packages.glances
    mosh
    tmate
    pass
    tomb
    remmina

    gparted

    vlc
    mr
    taskell

    # Nix stuff
    nix-top # Explore running nix build
    nox # pull request review for nixos

    # Software to help with direnv
    nur.repos.kalbasit.nixify 
    niv.niv

    # Gaming
    unstable.steam
    unstable.discord
    vassal
    #unstable.lutris

    # Gnome 
    gnome3.gnome-tweak-tool
    gnomeExtensions.sound-output-device-chooser
  ];

  #programs.pywal.enable = true;

  programs.fish = {
      enable = true;
  };

  programs.command-not-found.enable = true;
  programs.direnv = {
      enable = true;
      enableFishIntegration = true;
  };

  programs.feh.enable = true;
  programs.git = {
      enable = true;
      userName = "Martin Lavoie";
      userEmail = "broemartino@gmail.com";
  };
  programs.tmux = {
    enable = true;
    extraConfig = (builtins.readFile ./submodules/tmuxrc/tmux.conf);
    plugins = with tmuxPlugins; [
      vim-tmux-navigator
      gruvbox
    ];
  };
  programs.htop.enable = true;
  programs.man.enable = true;

  programs.ssh.enable = true;
  programs.termite = {
    enable = true;
    clickableUrl = true;
    mouseAutohide = true;
    colorsExtra = builtins.readFile "${sources.gruvbox-contrib.outPath}/termite/gruvbox-dark";
  };

  programs.firefox = {

    enable = true;
    extensions = with nur.repos.rycee.firefox-addons; [
      ublock-origin
      https-everywhere
      #decentraleyes
      link-cleaner
      #octotree
      privacy-badger
    ];
  };


  systemd.user.startServices = true;
  services.lorri.enable = true;

  xdg.mimeApps = {
    enable = false;
    defaultApplications = {
      "application/x-keepass" = "keepass.desktop";
    };
  };

  home.file = with builtins;
  let 
    rcpath = ./rcfiles;
    dir = builtins.readDir rcpath;
    dirNames = attrNames dir;
    fileToHomeSet = { filename, filetype }: if (filetype == "regular" || filetype == "symlink") then { ".${filename}" = { source = rcpath + "/${filename}"; }; } else {};

    mergeSets = foldl' (l: r: l // r) {};
    rcfilesAutoSet = mergeSets (map (name: fileToHomeSet {filename = name; filetype = getAttr name dir;}) dirNames);
  in rcfilesAutoSet // {
  };
} 
