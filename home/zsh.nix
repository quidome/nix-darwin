{ config, pkgs, lib, ... }:
with lib;
let
  zshEnabled = config.programs.zsh.enable;
in
{
  config = mkIf zshEnabled {
    # enable starship
    programs.starship.enable = true;

    programs.zsh = {
      shellAliases = {
        find = "noglob find";
        nix-update = "darwin-rebuild switch --flake $HOME/dev/github.com/quidome/nix-config";
        idea = "open -na \"IntelliJ IDEA.app\" --args \"$@\"";
      };

      enableCompletion = true;
      enableAutosuggestions = true;
      history = {
        size = 50000;
        save = 50000;
        ignoreDups = true;
      };

      defaultKeymap = "emacs";

      initExtra = ''
        # unfortunally a few system paths end up in front of my profile path
        # this just adds the path (again) before the other paths
        export PATH=${config.home.profileDirectory}/bin:$PATH

        # source all .sh file in .env.d
        if [ -d "$HOME"/.env.d ]; then
          for i in "$HOME"/.env.d/*.sh; do
            if [ -r $i ]; then
              . $i
            fi
          done
          unset i
        fi
      '';
    };
  };
}
