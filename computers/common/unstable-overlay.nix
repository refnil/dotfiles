self: super:

let
  callPackage = self.callPackage;
  sources = import ../..;
in
{
  unstable = super.callPackage sources.nixos-unstable {};
}
