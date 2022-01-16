#! /usr/bin/env nix-shell
#! nix-shell -i bash shell.nix

nixpkgs-firefox-addons firefox-addons.json firefox-addons-generated.nix
