{ pkgs, ... }:
let
  my-python-packages = ps: with ps; [
    pip
  ];
in
{
  imports = [
    ../../home
    ./home-vars.nix
  ];

  my.profile = "workstation";
  my.gui = "gnome";

  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      # dev tools
      postgresql
      poetry
      (python3.withPackages my-python-packages)
      temurin-bin-21
      nodejs_20
      jetbrains.idea-community
      rnix-lsp
      rustup

      # some tools
      cointop
      discord
      blender

      # office
      libreoffice-qt
      hunspell
      hunspellDicts.nl_NL
      hunspellDicts.en_US-large
      hunspellDicts.en_GB-large
    ];
  };

  programs.home-manager.enable = true;
}
