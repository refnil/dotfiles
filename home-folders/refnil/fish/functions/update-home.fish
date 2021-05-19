function update-home
   env USE_NIX2_COMMAND=true home-manager switch -I nixpkgs=(current_nixpkgs)
end

