{ pkgs, ... }:
{
  imports = [
    ./home-vars.nix
    ../../home
  ];

  home = {
    language.base = "en_IE.UTF-8";
    language.ctype = "en_IE.UTF-8";
    stateVersion = "24.05";
    packages = with pkgs; [
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
    ];

    sessionPath = [
      "/Applications/IntelliJ IDEA.app/Contents/MacOS"
    ];
  };

  programs.zsh.initExtra = ''
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
  '';

  programs.zsh.shellAliases = {
    nix-update = "darwin-rebuild switch --flake $HOME/dev/github.com/quidome/nix-config";
    idea = "open -na \"IntelliJ IDEA.app\" --args \"$@\"";
    em = "emacsclient -t -a ''";
  };

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
