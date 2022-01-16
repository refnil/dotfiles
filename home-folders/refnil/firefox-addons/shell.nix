let 
  sources = import ../../..;
  unstable = import sources.nixos-unstable {};
  nur = import sources.nur { pkgs = unstable; };
  rycee = nur.repos.rycee;
in
unstable.mkShell {
  buildInputs = [ rycee.firefox-addons-generator ];
}
