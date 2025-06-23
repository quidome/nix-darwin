{lib, ...}: {
  programs.zsh.initContent = lib.mkOrder 550 ''
    eval $(bol completion zsh)
  '';

  settings.brew = {
    brews = [
      "homebrew/homebrew-bol/proxer"
      "homebrew/homebrew-bol/bol-cli"
    ];
  };
}
