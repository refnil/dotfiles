function update-computer
   echo Update computer
   sudo nixos-rebuild switch --upgrade -I nixpkgs=(current_nixpkgs)
end

