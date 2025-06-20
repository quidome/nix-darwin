{
  config,
  lib,
  ...
}: let
  cfg = config.settings.gcloud;
in {
  options.settings.gcloud.enable = lib.mkEnableOption "gcloud";

  config = lib.mkIf cfg.enable {
    settings.brew.casks = ["google-cloud-sdk"];

    programs.zsh = lib.mkIf config.programs.zsh.enable {
      initContent = ''
        # Configure gcloud
        . "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc"
        . "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"
      '';

      shellAliases = {
        k = "kubectl";
        kn = "kubens";
        kc = "kubectx";
      };
    };
  };
}
