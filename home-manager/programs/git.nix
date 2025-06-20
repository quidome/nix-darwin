{ config, lib, ... }:
with lib;
let
  gitEnabled = config.programs.git.enable;
in
{
  config.programs.git = mkIf gitEnabled {
    delta.enable = true;
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = "auto";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };
    # Aliases
    aliases = {
      "hist" = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
    ignores = [
      ".DS_Store"
      "*~"
      "\#*\#"
      "/.emacs.desktop"
      "/.emacs.desktop.lock"
      "*.elc"
      "auto-save-list"
      "tramp"
      ".\#*"
      ".rbenv-gemsets"
      ".vscode"
      ".idea"
      "*.iml"
      ".directory"
      ".ruby-version"
      ".ruby-gemset"
      ".mise.toml"
      ".venv"
      ".envrc"
      ".zed"
    ];
  };
}
