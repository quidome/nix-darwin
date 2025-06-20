{
  description = "quidome's darwin-nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, ...} @ inputs: let
    system = "aarch64-darwin";

    pkgs = import inputs.nixpkgs {
      inherit system;
    };
  in {
    darwinConfigurations = {
      LMAC-LK9GJDPQXR = inputs.darwin.lib.darwinSystem {
        inherit pkgs;
        modules = [./darwin];
      };
    };

    homeConfigurations = {
      "qmeijer@LMAC-LK9GJDPQXR" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home-manager];
      };
    };
  };
}
