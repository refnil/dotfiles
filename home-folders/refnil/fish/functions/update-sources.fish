function update-sources
    pushd $HOME/dotfiles
    niv update nixos-stable
    niv update nixos-unstable
    niv update home-manager
    popd
end
