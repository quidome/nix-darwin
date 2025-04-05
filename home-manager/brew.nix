{ lib, config, ... }:
with lib;

let
  cfg = config.settings.brew;

  # Normalize the input to always be a list of lists
  # This allows for flexibility in user input (single string or list of strings)
  normalizeInput = input: builtins.map (item: if builtins.isString item then [ item ] else item) input;

  normalizedTaps = normalizeInput cfg.taps;
  normalizedBrews = normalizeInput cfg.brews;
  normalizedCasks = normalizeInput cfg.casks;

  # Generate Brewfile lines for a given package type (tap, brew, or cask)
  generateBrewfileLines = packageType: packageList: builtins.concatStringsSep "\n" (map
    (package:
      let
        packageString = builtins.concatStringsSep "\", \"" package;
      in
      ''${packageType} "${packageString}"'')
    packageList);

  tapLines = generateBrewfileLines "tap" normalizedTaps;
  brewLines = generateBrewfileLines "brew" normalizedBrews;
  caskLines = generateBrewfileLines "cask" normalizedCasks;
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
      description = "A list of brews to install using brew.";
    };

    casks = mkOption {
      type = types.listOf (types.oneOf [
        types.str
        (types.listOf types.str)
      ]);
      default = [ ];
      description = "A list of casks to install using brew.";
    };
  };

  config = {
    # Configure Zsh to initialize Homebrew if Zsh is enabled
    programs.zsh.initExtra = mkIf config.programs.zsh.enable ''
      # Initialize Homebrew environment
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    # Set the Homebrew bundle file location
    home.sessionVariables = {
      HOMEBREW_BUNDLE_FILE = "${config.home.homeDirectory}/.config/brewfile";
    };

    # Generate the Brewfile
    home.file.brewfile = {
      target = ".config/brewfile";
      text = ''
        # Taps (third-party repositories)
        ${tapLines}

        # Formulae (command-line software)
        ${brewLines}

        # Casks (GUI applications)
        ${caskLines}
      '';
    };
  };
}
