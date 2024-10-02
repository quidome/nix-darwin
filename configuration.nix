{ pkgs, ... }:
{
  config = {
    environment.shells = [ pkgs.zsh ];
    environment.systemPackages = with pkgs; [
      home-manager
      git
      git-crypt
    ];

    nix.settings.substituters = [ "https://cache.nixos.org/" ];
    nix.settings.trusted-users = [ "@admin" ];
    nix.configureBuildUsers = true;

    nix.extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    programs.zsh.enable = true;
    programs.nix-index.enable = true;
    programs.gnupg.agent.enable = true;

    # Allow touchid to be used for sudo authentication
    security.pam.enableSudoTouchIdAuth = true;

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;

    # Keyboard mappings
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToEscape = true;
  };
}
