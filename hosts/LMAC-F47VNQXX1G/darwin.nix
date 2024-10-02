{ pkgs, lib, ... }: {
  # Nix configuration ------------------------------------------------------------------------------

  imports = [
    ./darwin-vars.nix
  ];

  system.stateVersion = 5;
}
