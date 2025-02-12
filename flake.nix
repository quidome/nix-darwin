{
  description = "quidome's darwin-nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, ... }@inputs:
    let
      inherit (inputs.nixpkgs.lib)
        attrValues optionalAttrs singleton;

      system = "aarch64-darwin";

      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "electron-27.3.11" ];
        };
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

      args = inputs;
in
    {
      darwinConfigurations = {
        LMAC-LK9GJDPQXR = inputs.darwin.lib.darwinSystem {
          inherit(pkgs);
          system = "aarch64-darwin";
          modules = [
            ./configuration.nix
            ./hosts/LMAC-LK9GJDPQXR/darwin.nix

            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.qmeijer = import ./hosts/LMAC-LK9GJDPQXR/home.nix;
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
              inherit (pkgs) config;
            };
          };
      };
    };
}
