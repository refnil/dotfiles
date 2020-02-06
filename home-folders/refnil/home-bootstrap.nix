{ pkgs, options, ...}:
{
  programs.home-manager.enable = true;

  #programs.home-manager.path = "/home/refnil/contrib/home-manager";
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/release-19.09.tar.gz;
  #programs.home-manager.path = https://github.com/rycee/home-manager/archive/release-18.09.tar.gz;

  home.file = {
    ".config/fish/functions".source = ./fish/functions;
  };
}
