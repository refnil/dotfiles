function update
   sudo nixos-rebuild switch --upgrade 
   nix-channel --update
   home-manager switch
end

