{ pkgs, options, ...}:
with pkgs;
let 
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) { config = { allowUnfree = true; }; };
in
{
  imports = [ ./home-bootstrap.nix ];

  #nixpkgs.config.allowUnfree = true;
  #nixpkgs.overlays = [ import ./unstable-overlay.nix ];

  home.packages = [
    git
    tmux
    unzip
    ripgrep
    evince 
    keepass
    xdotool
    libreoffice
    calibre
    unstable.steam
    bat # "Better" cat
    nix-top # Explore running nix build
    bup
    python3Full
    python36Packages.glances
    mosh
    tmate
    qutebrowser
  ];

  #xsession.enable = true;
  xsession.windowManager.i3 = {
      enable = true;
      config = rec { 
          modifier = "Mod4";
          keybindings = lib.mkOptionDefault {
            "${modifier}+Return" = "exec termite";
            "${modifier}+Shift+e" = "exec xfce4-session-logout";
          };
          startup = [
	    #{ command = "systemctl --user restart polybar"; always = true; notification = false; }
            { command = ''xsetroot -solid "#000000"''; always = true; }
            { command = ''setxkbmap -model pc104 -layout us,ca -option grp:alt_shift_toggle''; always = true; }
            { command = ''wal -R''; always = true; }
          ];
          /*
	  gaps = {
	  	inner = 8;
		outer = 3;
	  };
      */
	  #bars = [];
      };
      #extraConfig = builtins.readFile "${colorScheme base16.templates.i3}/themes/base16-circus.config";
  };

  #programs.pywal.enable = true;

  programs.fish = {
      enable = true;
      shellAliases = {
        "wall" = "wal -i ~/test/Wallpapers/GanstaAnimals";
      };
  };

  programs.command-not-found.enable = true;
  programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      stdlib = builtins.readFile ./direnvrc;
  };

  programs.feh.enable = true;
  programs.git = {
      enable = true;
      userName = "Martin Lavoie";
      userEmail = "broemartino@gmail.com";
  };
  programs.htop.enable = true;
  programs.man.enable = true;

  programs.ssh.enable = true;
  programs.termite.enable = true;

  programs.neovim = {
      enable = false;
      viAlias = true;
      vimAlias = true;
  };

  programs.vim = {
    enable = true;
    settings = {
      relativenumber = true;
      number = true;
      expandtab = true;
      tabstop = 4;
    };
    plugins = [
      #"vim-fish"
      "idris-vim"
      "vim-airline"
      "The_NERD_tree" # file system explorer
      "fugitive" "vim-gitgutter" # git 
      "ctrlp"
    ];
  };

  services.redshift = {
      enable = true;
      latitude = "45.5";
      longitude = "73.5";
  };

  services.network-manager-applet.enable = true;

  services.screen-locker = {
      enable = true;
      inactiveInterval = 5;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
  };

  services.polybar = {
  	enable = false;
	config = https://raw.githubusercontent.com/jaagr/dots/master/.local/etc/themer/themes/space/polybar;
	script = ''
	  polybar bar/top &
	'';
  };

  home.file = {
    #".config/nvim/init.vim".source = ./vimrc;
    ".pythonrc".source = ./pythonrc;
    ".tmux.conf".source = ./tmuxrc/tmux.conf;

    ".config/fish/functions".source = ./fish/functions;
  };
} 
