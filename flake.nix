{                                                                                         
  description = "NixOS config for multiple hosts";                                        
                                                                                          
  inputs = {                                                                              
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";                                     
  };                                                                                      
                                                                                          
  outputs = { self, nixpkgs }: let                                                        
    # LaTeX parser (utftex) for neovim
    libtexprintf = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {              
      pname = "libtexprintf";                                                             
      version = "1.31";                                                                   
      src = nixpkgs.legacyPackages.x86_64-linux.fetchFromGitHub {                                                           
        owner = "bartp5";
        repo = "libtexprintf";
        rev = "v1.31";                                                          
        hash = "sha256-OXDcohfSfik0H1MpoznN267OVTYkW75N+TIF6lRRvZ0=";
      };                                                                                  
      nativeBuildInputs = with nixpkgs.legacyPackages.x86_64-linux; [                     
        autoconf                                                                          
        automake                                                                          
        libtool                                                                           
      ];                                                                                  
      preConfigure = "./autogen.sh";                                                      
    };                                                                                    
  in {                                                                                    
    nixosConfigurations = {                                                               
      desktop = nixpkgs.lib.nixosSystem {                                                 
        modules = [                                                                       
          { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }            
          ./hosts/desktop/configuration.nix                                               
          {                                                                               
            environment.systemPackages = [ libtexprintf ];                                
          }                                                                               
        ];                                                                                
      };                                                                                  
      laptop = nixpkgs.lib.nixosSystem {                                                  
        modules = [                                                                       
          { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }            
          ./hosts/laptop/configuration.nix                                                
          {                                                                               
            environment.systemPackages = [ libtexprintf ];                                
          }                                                                               
        ];        
       };                                                                                  
    };                                                                                    
  };
}
