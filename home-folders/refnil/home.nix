{ pkgs, options, config,  ...}:
with pkgs;
let 
  sources = import ../..;

  unstable = import sources.nixos-unstable { config = { allowUnfree = true; }; };

  nur = import sources.nur { pkgs = unstable; };

  niv = import sources.niv {};
in
{
  imports = [ ./home-bootstrap.nix ];

  programs.home-manager.path = lib.mkForce (toString sources.home-manager);

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
    killall

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
      let g:ctrlp_cmd = 'CtrlPBuffer'
      let g:ctrlp_user_command = 'rg --files'

      set background=dark
    '';
    plugins = with vimPlugins; [
      vim-airline
      The_NERD_tree # file system explorer
      nerdcommenter 
      fugitive 
      vim-gitgutter # git 
      ctrlp-vim # fzf
      #ack
      rainbow

      # Languages
      vim-nix
      haskell-vim
      idris-vim
      # vim-fish
    ];
  };
  
  programs.neovim = {
    enable = true;
    viAlias = true;
    withNodeJs = true;

    plugins = with vimPlugins; config.programs.vim.plugins ++ [
      # Language Server Protocol
      coc-nvim
    ];

    extraConfig = config.programs.vim.extraConfig + ''

    '';
  };

  systemd.user.startServices = true;
  services.lorri.enable = true;

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
