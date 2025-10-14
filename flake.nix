{
  description = "NixOS config for multiple hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = inputs: {

    nixosConfigurations = {

      desktop = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          { nix.settings.experimental-features = ["nix-command" "flakes"]; }
          ./hosts/desktop/configuration.nix
        ];
      };

      #laptop = inputs.nixpkgs.lib.nixosSystem {
        #modules = [
          #{ nix.settings.experimental-features = ["nix-command" "flakes"]; }
          #./hosts/laptop/configuration.nix
        #];
      #};
      
    };

  };
  
}

