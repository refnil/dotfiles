{ pkgs, options, ...}:
{
  programs.home-manager.enable = true;
  #programs.home-manager.path = "/home/refnil/contrib/home-manager";
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
