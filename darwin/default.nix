{pkgs, ...}: {
  imports = [./secrets.nix];

  environment.shells = [pkgs.zsh];
  environment.systemPackages = with pkgs; [
    home-manager
    git
    git-crypt
      just
  ];

  fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];

  nix.settings.substituters = ["https://cache.nixos.org/"];
  nix.settings.trusted-users = ["@admin"];

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  programs.zsh.enable = true;
  programs.nix-index.enable = true;
  # programs.gnupg.agent.enable = true;

  # Allow touchid to be used for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Keyboard mappings
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.stateVersion = 6;
}
