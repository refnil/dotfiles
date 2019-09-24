self: super:

let
  callPackage = self.callPackage;
  mkIf = self.lib.mkIf;
  unstableTarball = builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/91d748670355b4f10ff63d4c6f7cd083613a6528.tar.gz";
      sha256 = "0mi032xs1jsak93wa7bqa6z2ingz91z0g2ncc2g9mb754mpxp6xb";
  };
in
{
  unstable = super.callPackage unstableTarball {};
}
