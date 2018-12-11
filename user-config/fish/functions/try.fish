function try
    set program $argv[1]
    nix-shell -p $program --run "$argv"
end

