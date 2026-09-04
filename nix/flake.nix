{
  description = "nixos nitro-v15 configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    dam-fc = {
      url = "github:PXDiv/Div-Acer-Manager-Fan-Controls";
      flake = false;
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      mac-style-plymouth,
      home-manager,
      lanzaboote,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      formatter.${system} = pkgs.nixfmt;

      devShells.${system} = {
        typescript = import ./devshells/typescript.nix {
          inherit pkgs;
        };

        go = import ./devshells/golang.nix {
          inherit pkgs;
        };

        python = import ./devshells/python.nix {
          inherit pkgs;
        };

        lua = import ./devshells/lua.nix {
          inherit pkgs;
        };

        c = import ./devshells/clang.nix {
          inherit pkgs;
        };
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
          };

          modules = [
            {
              nixpkgs.overlays = [
                mac-style-plymouth.overlays.default
              ];
            }

            ./configuration.nix
            lanzaboote.nixosModules.lanzaboote

            home-manager.nixosModules.home-manager

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";

                extraSpecialArgs = {
                  inherit inputs;
                };

                users.vinicius = import ./home.nix;
              };
            }
          ];
        };
      };
    };
}
