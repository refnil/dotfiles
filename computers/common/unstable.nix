self: super:

let
  callPackage = self.callPackage;
  source = import ../..;
  unstableTarball = source.nixos-unstable.outPath;
in
{
  unstable = super.callPackage unstableTarball {};
}
