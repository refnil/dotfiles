{ pkgs, options, ...}:
with pkgs;
let 
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) { config = { allowUnfree = true; }; };
  kalbasit-nur-packages = import (
    builtins.fetchTarball {
      url = "https://github.com/kalbasit/nur-packages/archive/e64b81d6e177809d2f8d9669373a9eb619972dea.tar.gz";
      sha256 = "0jz5hclsc0xd2w8nf56hy3acm65cmhzg8xla26qdsvkis9pw7s5x";
    }) { pkgs = pkgs; };
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
    kalbasit-nur-packages.nixify 
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
      tabstop = 8;
      shiftwidth = 4;
    };
    extraConfig = ''
      set softtabstop=0 smarttab 
      nnoremap <S-Tab> <<
      inoremap <S-Tab> <C-d>
    '';
    plugins = [
      #"vim-fish"
      "idris-vim"
      "vim-airline"
      "The_NERD_tree" # file system explorer
      "fugitive" "vim-gitgutter" # git 
      "ctrlp"
      "haskell-vim"
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
