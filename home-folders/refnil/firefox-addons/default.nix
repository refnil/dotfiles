let 
  sources = import ../../..;
  unstable = import sources.nixos-unstable {};
  nur = import sources.nur { pkgs = unstable; };
  rycee = nur.repos.rycee;
  generated-set = unstable.callPackage ./firefox-addons-generated.nix { inherit (rycee.firefox-addons) buildFirefoxXpiAddon; };
  generated-list = builtins.attrValues generated-set;
  generated-filtered = builtins.filter unstable.lib.attrsets.isDerivation generated-list;
in
  generated-filtered

