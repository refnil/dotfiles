function nixify

    if test ! -e ./.envrc 
        echo "use_nix" > .envrc
        direnv allow
    end
    if test ! -e shell.nix
        echo "\
{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
      buildInputs = [ ];
}
" > shell.nix
    end

end
