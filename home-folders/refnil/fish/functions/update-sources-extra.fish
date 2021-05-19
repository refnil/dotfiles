function update-sources-extra
    pushd $HOME/dotfiles
    niv update niv
    niv update nur
    pushd home-folders/refnil/firefox-addons
    ./update.sh
    popd
    popd
end
