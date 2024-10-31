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
      poetry

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
  '';

  programs.zsh.shellAliases = {
    nix-update = "darwin-rebuild switch --flake $HOME/dev/github.com/quidome/nix-config";
    idea = "open -na \"IntelliJ IDEA.app\" --args \"$@\"";
    em = "emacsclient -t -a ''";
  };

  settings.brew = {
    brews = [
      "openssl"
      "xz"
      "jenv"
      "pyenv"
      "pyenv-virtualenv"
    ];
    casks = [
      "bitwarden"
      "browserosaurus"
      "drawio"
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
