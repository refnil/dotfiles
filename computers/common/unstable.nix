{...}:
{
  nixpkgs = {
    overlays = [
      (import ./unstable-overlay.nix)
    ];
  };
}
