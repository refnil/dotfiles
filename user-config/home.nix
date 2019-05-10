{ pkgs, options, ...}:
with pkgs;
let 
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) { config = { allowUnfree = true; }; };
in
{
  imports = [ ./home-bootstrap.nix ];

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
    pass
    tomb
    qutebrowser
    firefox
    #brave
    palemoon
    nox # pull request review for nixos
  ];

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
      stdlib = builtins.readFile ./rcfiles/direnvrc;
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
      enable = false;
      latitude = "45.5";
      longitude = "73.5";
  };

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

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file = {
    ".pythonrc".source = ./rcfiles/pythonrc;
    ".tmux.conf".source = ./tmuxrc/tmux.conf;
  };
} 
