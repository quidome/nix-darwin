{
  description = "quidome's darwin-nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, ... }@inputs:
    let
      inherit (inputs.darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib) nixosSystem;
      inherit (inputs.nixpkgs.lib)
        attrValues optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config.allowUnfree = true;
        config.permittedInsecurePackages = [ "electron-27.3.11" ];

        overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev:
            (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
              inherit (final.pkgs-x86)
                niv# has an aarch64 build but it won't build
                purescript
                ;
            })
        );
      };
    in
    {
      darwinConfigurations = {
        LMAC-F47VNQXX1G = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/LMAC-F47VNQXX1G/darwin.nix

            inputs.home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.qmeijer = import ./hosts/LMAC-F47VNQXX1G/home.nix;
            }
          ];
        };
      };

      # Overlays --------------------------------------------------------------- {{{
      overlays = {
        unstable-packages = final: _prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = final.system;
            config.allowUnfree = true;
          };
        };
        # Overlays to add various packages into package set
        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Add access to x86 packages system is running Apple Silicon
            pkgs-x86 = import inputs.nixpkgs {
              system = "x86_64-darwin";
              inherit (nixpkgsConfig) config;
            };
          };
      };
    };
}
