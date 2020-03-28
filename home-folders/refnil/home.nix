{ pkgs, options, ...}:
with pkgs;
let 
  sources = import ../..;

  unstable-path = sources.nixos-unstable.outPath;
  unstable = import unstable-path { config = { allowUnfree = true; }; };

  nur-path = sources.nur.outPath;
  nur = import nur-path { pkgs = unstable; };

  niv-path = sources.niv.outPath;
  niv = import niv-path {};

in
{
  imports = [ ./home-bootstrap.nix ];

  programs.home-manager.path = lib.mkForce sources.home-manager.outPath; 

  home.packages = [
    git
    gitAndTools.git-annex
    lsof
    tmux
    unzip
    ripgrep
    evince 
    keepass
    xdotool
    libreoffice
    calibre

    bat # "Better" cat
    bup
    python3Full
    python36Packages.glances
    mosh
    tmate
    pass
    tomb

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
  programs.htop.enable = true;
  programs.man.enable = true;

  programs.ssh.enable = true;
  programs.termite.enable = true;

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

  programs.vim = {
    enable = true;
    settings = {
      relativenumber = true;
      number = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
    };
    extraConfig = ''
      let mapleader = ','

      set softtabstop=0 smarttab 
      nnoremap <S-Tab> <<
      inoremap <S-Tab> <C-d>

      " From haskell-vim readme
      syntax on
      filetype plugin indent on

      " NERDTree
      map <leader>nn :NERDTreeToggle<cr>
      map <leader>nb :NERDTreeFromBookmark 
      map <leader>nf :NERDTreeFind<cr>

      " ctrlp-vim
      let g:ctrlp_map = '<c-f>'

      set background=dark
    '';
    plugins = with vimPlugins; [
      # vim-fish
      idris-vim
      vim-airline
      The_NERD_tree # file system explorer
      fugitive 
      vim-gitgutter # git 
      ctrlp-vim
      haskell-vim
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

  home.file = with builtins;
  let 
    rcpath = ./rcfiles;
    dir = builtins.readDir rcpath;
    dirNames = attrNames dir;
    fileToHomeSet = { filename, filetype }: if (filetype == "regular" || filetype == "symlink") then { ".${filename}" = { source = rcpath + "/${filename}"; }; } else {};

    mergeSets = foldl' (l: r: l // r) {};
    rcfilesAutoSet = mergeSets (map (name: fileToHomeSet {filename = name; filetype = getAttr name dir;}) dirNames);
  in rcfilesAutoSet // {
    ".tmux.conf".source = ./submodules/tmuxrc/tmux.conf;
  };
} 
