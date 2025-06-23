{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./secrets.nix
    ./bol.nix
    ./brew.nix
    ./gcloud.nix
    ./programs
    ./services
  ];

  home = {
    language.base = "en_IE.UTF-8";
    language.ctype = "en_IE.UTF-8";
    stateVersion = "25.05";

    packages = with pkgs; [
      # Core
      # bitwarden-cli
      bottom
      cocoapods

      coreutils
      curl
      dogdns
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

      # Useful nix related tools
      alejandra # nix formatting tool
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      niv # easy dependency management for nix projects
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

  programs.zed-editor.enable = true;

  programs.zellij.enable = lib.mkDefault true;

  programs.zoxide.enable = true;

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.shellAliases = {
    nix-update = "darwin-rebuild switch --flake $HOME/dev/github.com/quidome/nix-config";
    idea = "open -na \"IntelliJ IDEA.app\" --args \"$@\"";
    em = "emacsclient -t -a ''";
  };

  programs.zsh.initContent = ''
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

    # temp fix until https://github.com/nix-community/home-manager/pull/7117/files is available in flake.lock
    unset SSH_AGENT_PID
    export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
  '';

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
    enableSshSupport = true;
  };

  settings.brew = {
    taps = [
      "homebrew/services"
    ];
    brews = [
      "bitwarden-cli"
      "openssl"
      "xz"
      "jenv"
      "pyenv"
      "poetry"
    ];
    casks = [
      "arc"
      "bitwarden"
      "browserosaurus"
      "element"
      "emacs"
      "logseq"
      "obsidian"
      "raycast"
      "signal"
      "zulu@11"
      "zulu@21"
    ];
  };

  settings.gcloud.enable = true;
}
