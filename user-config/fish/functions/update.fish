function update
   sudo nixos-rebuild switch --upgrade 
   nix-channel --update
   env USE_NIX2_COMMAND=true home-manager switch
end

