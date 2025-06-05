{ config, lib, ... }:
let
  cfg = config.settings.mise;
in
{
  options.settings.mise.enable = lib.mkEnableOption "mise";

  config = lib.mkIf cfg.enable {
    settings.brew.brews = [ "mise" ];

    programs.zsh.initContent = lib.mkIf config.programs.zsh.enable ''
      # Configure mise
      eval "$(mise activate zsh)"
    '';
  };
}
