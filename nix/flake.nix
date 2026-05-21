{
  description = "nixos system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, mac-style-plymouth, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Aplica o overlay direto de forma limpa como o repo manda
          { nixpkgs.overlays = [ mac-style-plymouth.overlays.default ]; }
          
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
    };
  };
}
