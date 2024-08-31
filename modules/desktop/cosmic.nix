{ config, pkgs, lib, ... }:
with lib;
let
  cosmicEnabled = (config.my.gui == "cosmic");
in
{
    programs.gnupg.agent.enableSSHSupport = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    services.printing.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
