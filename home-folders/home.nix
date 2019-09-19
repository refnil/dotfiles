{ pkgs, options, ...}:
with pkgs;
let 
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) { config = { allowUnfree = true; }; };
  nur = import (builtins.fetchTarball {
    # Get the revision by choosing a version from https://github.com/nix-community/NUR/commits/master
    url = "https://github.com/nix-community/NUR/archive/488e99b6a5cb639b10ba0d82ec9788dfe2a57d5d.tar.gz";
    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
    sha256 = "1mnavmx93wpqjrgzpk4bkb67hlks532kya18j5li7va26v8lpqkz";
  }) { pkgs = unstable; };
  niv-repo = import (fetchTarball https://github.com/nmattia/niv/tarball/master) {};
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
    #brave
    #palemoon
    nox # pull request review for nixos
    nur.repos.kalbasit.nixify 
    unstable.vlc
    niv-repo.niv
    unstable.lutris
    discord
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

  programs.firefox = {

    enable = true;
    extensions = with nur.repos.rycee.firefox-addons; [
      ublock-origin
      https-everywhere
      decentraleyes
      link-cleaner
      octotree
      privacy-badger
    ];
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
