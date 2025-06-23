{
  description = "quidome's darwin-nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {...} @ inputs: let
    system = "aarch64-darwin";

    pkgs = import inputs.nixpkgs {
      inherit system;
    };

    mkDarwin = host:
      inputs.darwin.lib.darwinSystem {
        inherit pkgs;
        modules = [./darwin];
      };

    mkHome = user: host:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home-manager];
      };
  in {
    darwinConfigurations = {
      LMAC-LK9GJDPQXR = mkDarwin "LMAC-LK9GJDPQXR";
    };

    homeConfigurations = {
      "qmeijer@LMAC-LK9GJDPQXR" = mkHome "qmeijer" "LMAC-LK9GJDPQXR";
    };
  };
}
