{ config, lib, pkgs, ... }:
{
  imports = [
    ./secrets.nix
    ./brew.nix
    ./gcloud.nix
    ./programs
    ./services
  ];

  home = {
    language.base = "en_IE.UTF-8";
    language.ctype = "en_IE.UTF-8";
    stateVersion = "24.05";

    packages = with pkgs;  [
      # Core
      # bitwarden-cli
      bottom
      cocoapods

      coreutils
      curl
      dogdns
      element-desktop
      fd
      fzf
      git-crypt
      gitui
      gopass
      jless
      jq
      m-cli # useful macOS CLI commands
      nushell
      pandoc
      plantuml
      rename
      ripgrep
      shellcheck
      watch
      wget
      yq-go

      # Lang stuff
      fnm
      go
      ktlint

      # DevOps
      colima
      docker-client
      docker-compose
      docker-credential-helpers
      envsubst
      httpie
      k9s
      kubectx
      libyaml
      postgresql
      stern

      # Fonts
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

      # Useful nix related tools
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      niv # easy dependency management for nix projects
      nixpkgs-fmt
    ];

    sessionPath = [
      "${config.home.homeDirectory}/bin"
      "${config.home.homeDirectory}/go/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "/Applications/IntelliJ IDEA.app/Contents/MacOS"
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

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.shellAliases = {
    nix-update = "darwin-rebuild switch --flake $HOME/dev/github.com/quidome/nix-config";
    idea = "open -na \"IntelliJ IDEA.app\" --args \"$@\"";
    em = "emacsclient -t -a ''";
  };

  programs.zsh.initExtraBeforeCompInit = "fpath+=($HOME/.zsh/completion/)";
  programs.zsh.initExtra = ''
    # Add function to update nixpkgs index
    download_nixpkgs_cache_index () {
      location=~/.cache/nix-index
      filename="index-$(uname -m | sed 's/^arm64$/aarch64/')-$(uname | tr A-Z a-z)"
      mkdir -p "$location"
      # -N will only download a new version if there is an update.
      wget -P "$location" -q -N https://github.com/nix-community/nix-index-database/releases/latest/download/$filename
      ln -f "$location/$filename" "$location/files"
    }

    # Configure fnm
    eval "$(fnm env --use-on-cd)";

    # Create link to /var/run/docker.sock
    if command -v colima >/dev/null 2>&1 && [ ! -L "/var/run/docker.sock" ] ; then
      local docker_link="sudo ln -sf $HOME/.colima/docker.sock /var/run/docker.sock"
      echo "$docker_link"
      eval $docker_link
    fi

    # Pyenv setup
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"

    # jenv setup
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
  '';

  settings.brew = {
    taps = [
      "homebrew/services"
    ];
    brews = [
      "homebrew/homebrew-bol/proxer"
      "homebrew/homebrew-bol/bol-cli"
      "openssl"
      "xz"
      "jenv"
      "pyenv"
      "poetry"
    ];
    casks = [
      "bitwarden"
      "browserosaurus"
      "emacs"
      "logseq"
      "obsidian"
      "raycast"
      "signal"
      "zulu@21"
    ];
  };

  settings.gcloud.enable = true;
}
