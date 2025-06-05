{ config, lib, pkgs, ... }:
let
  cfg = config.programs.gpg;
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        gnupg
        pinentry_mac
      ];

      file.".gnupg/gpg-agent.conf".text = ''
        pinentry-program ${lib.getExe pkgs.pinentry_mac}
        enable-ssh-support

        default-cache-ttl 7200
        max-cache-ttl 14400

        default-cache-ttl-ssh 43200
        max-cache-ttl-ssh 86400
      '';
    };

    programs.zsh.initContent = ''
      # Configure gpg/ssh
      unset SSH_AGENT_PID
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    '';
  };
}
