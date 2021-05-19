function update
   sudo nixos-rebuild switch --upgrade -I nixpkgs=(current_nixpkgs)
   env USE_NIX2_COMMAND=true home-manager switch -I nixpkgs=(current_nixpkgs)
end

