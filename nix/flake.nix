{
  description = "nixos nitro-v15 configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-anydesk.url = "github:nixos/nixpkgs/nixos-24.11";

    dam-fc = {
      url = "github:PXDiv/Div-Acer-Manager-Fan-Controls";
      flake = false;
    };

    superfile = {
      url = "github:yorukot/superfile";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotifast = {
      url = "github:crmne/spotifast";
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

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-anydesk,
      mac-style-plymouth,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      anydeskPkgs = import nixpkgs-anydesk {
        inherit system;
        config.allowUnfree = true;
      };

      anydeskCompat =
        (anydeskPkgs.callPackage "${nixpkgs.outPath}/pkgs/by-name/an/anydesk/package.nix" {
          net-tools = anydeskPkgs.nettools;
          libice = anydeskPkgs.xorg.libICE;
          libsm = anydeskPkgs.xorg.libSM;
          libx11 = anydeskPkgs.xorg.libX11;
          libxdamage = anydeskPkgs.xorg.libXdamage;
          libxext = anydeskPkgs.xorg.libXext;
          libxfixes = anydeskPkgs.xorg.libXfixes;
          libxi = anydeskPkgs.xorg.libXi;
          libxmu = anydeskPkgs.xorg.libXmu;
          libxrandr = anydeskPkgs.xorg.libXrandr;
          libxrender = anydeskPkgs.xorg.libXrender;
          libxt = anydeskPkgs.xorg.libXt;
          libxtst = anydeskPkgs.xorg.libXtst;
        })
          .overrideAttrs (_: {
            version = "8.0.4";
            src = anydeskPkgs.fetchurl {
              url = "https://download.anydesk.com/linux/anydesk-8.0.4-amd64.tar.gz";
              hash = "sha256-fg3sLcushu5zDvsBakHLP/FRqhvauICx86rlpK4YkW8=";
            };
          });

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
                (final: prev: { anydesk = anydeskCompat; })
              ];
            }

            ./configuration.nix

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
