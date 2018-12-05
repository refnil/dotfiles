#! /usr/bin/env bash

nix-shell -p home-manager --run "home-manager -f home-bootstrap.nix switch"
mkdir -p ~/.config/nixpkgs
ln -sf `pwd`/home.nix ~/.config/nixpkgs/home.nix
home-manager switch
