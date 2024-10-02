{ config, lib, pkgs, ... }:
{
  imports = [
    ./programs
    ./services
  ];

  home = {
    file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${lib.getExe pkgs.pinentry_mac}
      enable-ssh-support

      default-cache-ttl 7200
      max-cache-ttl 43200

      default-cache-ttl-ssh 7200
      max-cache-ttl-ssh 43200
    '';

    packages = with pkgs;  [
      # Base
      bottom
      curl
      dogdns
      fd
      fzf
      git-crypt
      gitui
      gnupg
      gopass
      jless
      jq
      ripgrep
      shellcheck
      wget
      yq-go
      bitwarden-cli
      element-desktop
      pandoc
      plantuml

      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

      # Useful nix related tools
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      niv # easy dependency management for nix projects
      nixpkgs-fmt
      cocoapods
      coreutils
      m-cli # useful macOS CLI commands
      watch
      pinentry_mac
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

  fonts.fontconfig.enable = true;

  my.syncthing.enable = true;

  programs.alacritty.enable = true;

  programs.bat.enable = true;
  programs.bat.config.theme = "DarkNeon";
  programs.bat.config.style = "header,snip";

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.eza.enable = true;
  programs.eza.enableZshIntegration = true;

  programs.git.enable = true;

  programs.gpg.enable = true;

  programs.helix.enable = true;

  programs.home-manager.enable = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.ssh.enable = true;
  programs.ssh.extraConfig = "AddKeysToAgent yes";

  programs.zellij.enable = lib.mkDefault true;

  programs.zoxide.enable = true;
  programs.zoxide.options = [ "--cmd j" ];

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.initExtraBeforeCompInit = "fpath+=($HOME/.zsh/completion/)";
  programs.zsh.initExtra = ''
    # Configure gpg/ssh
    unset SSH_AGENT_PID
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent

    # Add function to update nixpkgs index
    download_nixpkgs_cache_index () {
      location=~/.cache/nix-index
      filename="index-$(uname -m | sed 's/^arm64$/aarch64/')-$(uname | tr A-Z a-z)"
      mkdir -p "$location"
      # -N will only download a new version if there is an update.
      wget -P "$location" -q -N https://github.com/nix-community/nix-index-database/releases/latest/download/$filename
      ln -f "$location/$filename" "$location/files"
    }
  '';
}
