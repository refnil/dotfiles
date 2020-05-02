let 
  sources = import ./nix/sources.nix;
in
sources //
{
  nixpkgs = sources.nixos-stable;
}
