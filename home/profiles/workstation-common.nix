{ config, pkgs, lib, ... }:
with lib;
{
  config = mkIf (config.my.profile == "workstation") {
    my.syncthing.enable = true;

    home = {
      packages = with pkgs; [
        pandoc
        plantuml
        lapce
        nil

        bitwarden-cli
        discord
        gimp
        element-desktop
      ];

      sessionPath = [
        "${config.home.homeDirectory}/bin"
        "${config.home.homeDirectory}/go/bin"
        "${config.home.homeDirectory}/.cargo/bin"
      ];

      sessionVariables = {
        DEV_PATH = "${config.home.homeDirectory}/dev";
      };
    };

    programs = {
      direnv.enable = true;
      direnv.nix-direnv.enable = true;

      helix.enable = true;
    };
  };
}
