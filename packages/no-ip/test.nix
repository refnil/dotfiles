let nixpkgs = import <nixos> {};
in
{
  no-ip = nixpkgs.callPackage ./. {};
}
