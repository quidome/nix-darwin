{ config, lib, pkgs, ... }:
with lib;
let
  hyprlandEnabled = (config.my.gui == "hyprland");
  networkmanagerEnabled = config.networking.networkmanager.enable;
  tailscaleEnabled = config.services.tailscale.enable;
in
{
  config = lib.mkIf hyprlandEnabled {
    environment = {
      systemPackages = with pkgs; [
        # hyprland deps
        avizo
        hyprpicker
        hyprcursor
        hyprlock
        hypridle
        hyprpaper
        waybar

        # Theming
        glib
        gnome.adwaita-icon-theme
        gsettings-desktop-schemas
        gtk-engine-murrine
        gtk_engines
        lxappearance

        # qt theming
        adwaita-qt
        libsForQt5.breeze-qt5
        libsForQt5.qt5ct

        kdePackages.polkit-kde-agent-1

        (mkIf networkmanagerEnabled networkmanagerapplet)
        (mkIf tailscaleEnabled tailscale-systray)
      ];
    };

    programs.gnupg.agent.enableSSHSupport = true;
    programs.hyprland.enable = true;
    programs.thunar.enable = true;

    # for qt theming
    qt.platformTheme = "qt5ct";

    services.auto-cpufreq.enable = true;
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
