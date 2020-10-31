{ pkgs, options, ...}:
{
  programs.home-manager.enable = true;

  programs.home-manager.path = https://github.com/rycee/home-manager/archive/release-20.09.tar.gz;

  home.file = {
    ".config/fish/functions".source = ./fish/functions;
  };
}
