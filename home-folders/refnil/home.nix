{ pkgs, config,  ...}:
with pkgs;
let 
  sources = import ../..;

  unstable = import sources.nixos-unstable { config = { allowUnfree = true; }; };

  nur = import sources.nur { pkgs = unstable; };

  niv = import sources.niv {};
  extra-firefox-addons = import ./firefox-addons;
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
    unstable.keepassxc
    xdotool
    libreoffice
    calibre
    killall
    fd
    barrier # Share keyboard and mouse via the network

    bat # "Better" cat
    bup
    python3Full
    glances
    mosh
    tmate
    pass
    tomb
    remmina

    peek # Gif recorder

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
    unstable.steam-run
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
    sensibleOnTop = true;
    plugins = with tmuxPlugins; [
      vim-tmux-navigator
      gruvbox
      /*
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
        '';
      }
      */
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
      decentraleyes
      link-cleaner
      octotree
      privacy-badger
      multi-account-containers
      facebook-container
      i-dont-care-about-cookies
      terms-of-service-didnt-read
      keepassxc-browser
    ]  ++ extra-firefox-addons;
    profiles = 
      let 
        defaultProfile = {
          settings = {
            "app.update.auto" = false;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "signon.rememberSignons" = false;
            "browser.startup.page" = 3;
            "app.shield.optoutstudies.enabled" = false;
            "identity.fxaccounts.enabled" = false;

            # From https://www.privacytools.io/browsers/
            "privacy.firstparty.isolate" = true;
            #"privacy.resistFingerprinting" = true; # Break some website with custom font or video
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "privacy.trackingprotection.cryptomining.enabled" = true;
            "privacy.trackingprotection.enabled" = true;

            "browser.send_pings" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;
            "dom.event.clipboardevents.enabled" = false;
            "media.navigator.enabled" = false; # Camera and microphone status
            "network.cookie.cookieBehavior" = 1;
            "network.http.referer.XOriginPolicy" = 2;
            "network.http.referer.XOriginTrimmingPolicy" = 2;
            "browser.sessionstore.privacy_level" = 2;
            "beacon.enabled" = false;

            "network.dns.disablePrefetch" = true;
            "network.dns.disablePrefetchFromHTTPS" = true;
            "network.predictor.enabled" = false;
            "network.predictor.enable-prefetch" = false;
            "network.prefetch-next" = false;

            "network.IDN_show_punycode" = true;
          };
          userChrome = ''
            /* hides the native tabs */
            #TabsToolbar {
              visibility: collapse;
            }
          '';
        };
      in 
      {
        home = defaultProfile // {
          id = 0;
        };
      };
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
    ".tmate.conf".text = config.home.file.".tmux.conf".text;
  };
} 
