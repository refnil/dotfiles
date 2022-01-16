function current_nixpkgs
    nix-instantiate --eval -E "(import ~/dotfiles).nixpkgs.outPath" | string unescape
end
