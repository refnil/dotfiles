function try_from
    set from $argv[1]
    nix-shell -p $from --run "$argv[2..-1]"
end

