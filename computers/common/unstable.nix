self: super:

let
  callPackage = self.callPackage;
  mkIf = self.lib.mkIf;
  unstableTarball = builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/91d748670355b4f10ff63d4c6f7cd083613a6528.tar.gz";
      sha256 = "0sg6rkncfq51gcj1cjlrbjb7pd6f6dq4i5fjx7z9nillkqqdc566";
  };
in
{
  unstable = super.callPackage unstableTarball {};
}
