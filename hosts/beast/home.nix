{ config, pkgs, lib, ... }:
{
  imports = [
    ../../home
    ./home-vars.nix
  ];

  my.profile = "workstation";
  my.gui = "gnome";

  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      # dev tools
      postgresql
      jetbrains.idea-community
      temurin-bin-21
    ];
  };

  programs.home-manager.enable = true;
}
