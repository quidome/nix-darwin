{ pkgs, ... }:
{
  imports = [
    ./home-brew.nix
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
      eval "$(fnm env --use-on-cd)";

      # Create link to /var/run/docker.sock
      if command -v colima >/dev/null 2>&1 && [ ! -L "/var/run/docker.sock" ] ; then
        local docker_link="sudo ln -sf $HOME/.colima/docker.sock /var/run/docker.sock"
        echo "$docker_link"
        eval $docker_link
      fi
    '';

    programs.zsh.shellAliases = {
      nix-update = "darwin-rebuild switch --flake $HOME/dev/github.com/quidome/nix-config";
      idea = "open -na \"IntelliJ IDEA.app\" --args \"$@\"";
      em = "emacsclient -t -a ''";
    };
}
