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
      " TextEdit might fail if hidden is not set.
      set hidden

      " Some servers have issues with backup files, see #649.
      set nobackup
      set nowritebackup

      " Give more space for displaying messages.
      set cmdheight=2

      " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
      " delays and poor user experience.
      set updatetime=300

      " Don't pass messages to |ins-completion-menu|.
      set shortmess+=c

      " Always show the signcolumn, otherwise it would shift the text each time
      " diagnostics appear/become resolved.
      set signcolumn=yes

      " Use tab for trigger completion with characters ahead and navigate.
      " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
      " other plugin before putting this into your config.
      inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion.
      inoremap <silent><expr> <c-space> coc#refresh()

      " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
      " position. Coc only does snippet and additional edit on confirm.
      " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
      if exists('*complete_info')
        inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
      else
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
      endif

      " Use `[g` and `]g` to navigate diagnostics
      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      " GoTo code navigation.
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " Use K to show documentation in preview window.
      nnoremap <silent> K :call <SID>show_documentation()<CR>

      function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        else
          call CocAction('doHover')
        endif
      endfunction

      " Highlight the symbol and its references when holding the cursor.
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Symbol renaming.
      nmap <leader>rn <Plug>(coc-rename)

      " Formatting selected code.
      xmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder.
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Applying codeAction to the selected region.
      " Example: `<leader>aap` for current paragraph
      xmap <leader>a  <Plug>(coc-codeaction-selected)
      nmap <leader>a  <Plug>(coc-codeaction-selected)

      " Remap keys for applying codeAction to the current line.
      nmap <leader>ac  <Plug>(coc-codeaction)
      " Apply AutoFix to problem on the current line.
      nmap <leader>qf  <Plug>(coc-fix-current)

      " Introduce function text object
      " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
      xmap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap if <Plug>(coc-funcobj-i)
      omap af <Plug>(coc-funcobj-a)

      " Use <TAB> for selections ranges.
      " NOTE: Requires 'textDocument/selectionRange' support from the language server.
      " coc-tsserver, coc-python are the examples of servers that support it.
      nmap <silent> <TAB> <Plug>(coc-range-select)
      xmap <silent> <TAB> <Plug>(coc-range-select)

      " Add `:Format` command to format current buffer.
      command! -nargs=0 Format :call CocAction('format')

      " Add `:Fold` command to fold current buffer.
      command! -nargs=? Fold :call     CocAction('fold', <f-args>)

      " Add `:OR` command for organize imports of the current buffer.
      command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

      " Add (Neo)Vim's native statusline support.
      " NOTE: Please see `:h coc-status` for integrations with external plugins that
      " provide custom statusline: lightline.vim, vim-airline.
      " set statusline^=%{coc#status()}%{get(b:,'coc_current_function'

      " Mappings using CoCList:
      " Show all diagnostics.
      nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
      " Manage extensions.
      nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
      " Show commands.
      nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
      " Find symbol of current document.
      nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
      " Search workspace symbols.
      nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
      " Do default action for next item.
      nnoremap <silent> <space>j  :<C-u>CocNext<CR>
      " Do default action for previous item.
      nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
      " Resume latest coc list.
      nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
    '';
  };

  systemd.user.startServices = true;
  services.lorri.enable = true;

  xdg.mimeApps = {
    enable = false;
    defaultApplications = {
      "application/x-keepass" = "keepass.desktop";
    };
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
