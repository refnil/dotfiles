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
    entr
    lsof
    unzip
    ripgrep
    evince 
    unstable.keepassxc
    xdotool
    libreoffice
    calibre
    killall
    fd # Alternative to find
    barrier # Share keyboard and mouse via the network

    bat # "Better" cat
    (python3.withPackages (ps: with ps; [flake8 autopep8]))
    mosh

    peek # Gif recorder
    asciinema

    gparted

    vlc
    mr

    # Nix stuff
    nix-top # Explore running nix build
    nox # pull request review for nixos
    nix-index

    # Software to help with direnv
    niv.niv

    # Gaming
    unstable.steam
    unstable.steam-run
    unstable.discord

    # Gnome 
    gnome.gnome-tweak-tool
    gnomeExtensions.vitals
    gnomeExtensions.vertical-overview
    gnomeExtensions.audio-output-switcher
    gnomeExtensions.random-wallpaper

    obs-studio
    obs-v4l2sink
  ];

  programs.fish = {
      enable = true;
  };

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
    shortcut = "a";
    sensibleOnTop = true;
    keyMode = "vi";
    historyLimit = 10000;
    escapeTime = 1;
    clock24 = true;
    baseIndex = 1;
    terminal = "screen-256color";
    newSession = true;
    extraConfig = ''
      # Splitting panes.
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # New windows
      bind c new-window -c "#{pane_current_path}"

      # Moving between panes.
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Pane resizing.
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Moveing between windows.
      # Provided you've mapped your `CAPS LOCK` key to the `CTRL` key,
      # you can now move between panes without moving your hands off the home row.
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # Enable mouse mode
      set -g mouse on
    '';
    plugins = with tmuxPlugins; [
      vim-tmux-navigator
      gruvbox
    ];
  };
  programs.htop.enable = true;
  programs.man.enable = true;

  programs.ssh.enable = true;
  programs.nix-index.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "Hasklig";
      package = hasklig;
    };
    settings = {
      enable_audio_bell = false;
      update_check_interval = 0;
      clipboard_control = "write-clipboard write-primary no-append";
      # show single underline when hovering the mouse over URL
      url_style = "single";
      open_url_modifiers = "ctrl";
      # Hide mouse on keypress
      mouse_hide_wait = -1;
    };
    extraConfig =
    let theme = fetchurl {
           url = "https://raw.githubusercontent.com/dexpota/kitty-themes/fca3335489bdbab4cce150cb440d3559ff5400e2/themes/gruvbox_dark.conf";
           sha256 = "1il8jbq7xkdqz789jc1b0hxcdg5d5h1hl5x2m6rgmy4yg55p7cws";
          };
    in ''
      include ${theme}
    '';
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
        basic.id = 1;
      };
  };

  systemd.user.startServices = true;
  services.lorri.enable = true;

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

  xdg.configFile."obs-studio/plugins".source = "${config.home.path}/share/obs/obs-plugins";
} 
