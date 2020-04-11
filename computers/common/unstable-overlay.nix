self: super:

let
  callPackage = self.callPackage;
  sources = import ../..;
  unstableTarball = import sources.nixos-unstable {};
in
{
  unstable = super.callPackage unstableTarball {};
}
