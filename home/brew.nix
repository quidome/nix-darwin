{ lib, config, ... }:
with lib;

let
  cfg = config.settings.brew;

  # Normalize the input to always be a list of lists
  normalizeInput = input: builtins.map (item: if builtins.isString item then [ item ] else item) input;

  normalizedTaps = normalizeInput cfg.taps;
  normalizedBrews = normalizeInput cfg.brews;
  normalizedCasks = normalizeInput cfg.casks;

  generateLines = input: key: builtins.concatStringsSep "\n" (map
    (entry:
      let
        string = builtins.concatStringsSep "\", \"" entry;
      in
      ''${key} "${string}"'')
    input);

  tapLines = generateLines normalizedTaps "tap";
  brewLines = generateLines normalizedBrews "brew";
  caskLines = generateLines normalizedCasks "cask";
in
{
  options.settings.brew = {
    taps = mkOption {
      type = types.listOf (types.oneOf [
        types.str
        (types.listOf types.str)
      ]);
      default = [ ];
      description = "A list of taps to install using brew.";
    };

    brews = mkOption {
      type = types.listOf (types.oneOf [
        types.str
        (types.listOf types.str)
      ]);
      default = [ ];
      description = "A single brew string or a list of brews to install using brew.";
    };

    casks = mkOption {
      type = types.listOf (types.oneOf [
        types.str
        (types.listOf types.str)
      ]);
      default = [ ];
      description = "A single cask string or a list of casks to install using brew.";
    };
  };

  config = {
    programs.zsh.initExtra = mkIf config.programs.zsh.enable ''
      # Configure brew
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    home.sessionVariables = {
      HOMEBREW_BUNDLE_FILE = "${config.home.homeDirectory}/.config/brewfile";
    };

    home.file.brewfile = {
      target = ".config/brewfile";
      text = ''
        # taps
        ${tapLines}

        # brews
        ${brewLines}

        # casks
        ${caskLines}
      '';
    };
  };
}
