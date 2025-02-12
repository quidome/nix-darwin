{
  description = "quidome's darwin-nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = input@{ nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations = {
      LMAC-LK9GJDPQXR = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
          ./hosts/LMAC-LK9GJDPQXR/darwin.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.qmeijer = import ./hosts/LMAC-LK9GJDPQXR/home.nix;
          }
        ];
      };
    };
  };
}
