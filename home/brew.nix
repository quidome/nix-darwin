{ lib, config, ... }:
with lib;
let
  cfg = config.settings.brew;
in
{
  options.settings.brew = {
    brews = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "A list of brews to install using brew.";
    };

    casks = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "A list of casks to install using brew.";
    };
  };

  config = {
    programs.zsh.initExtra = mkIf config.programs.zsh.enable ''
      # Homebrew settings
      eval "$(/opt/homebrew/bin/brew shellenv)"
      FPATH="$(brew --prefix)/share/zsh/site-functions:''${FPATH}"
    '';

    home.sessionVariables = {
      HOMEBREW_BUNDLE_FILE = "${config.home.homeDirectory}/.config/brewfile";
    };

    # Write the brewfile
    home.file.brewfile = {
      target = ".config/brewfile";
      text = ''
        ${builtins.concatStringsSep "\n" (map (p: ''brew "${p}"'') cfg.brews)}
        ${builtins.concatStringsSep "\n" (map (p: ''cask "${p}"'') cfg.casks)}
      '';
    };
  };
}
