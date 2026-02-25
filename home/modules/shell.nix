{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    bash
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    shellAliases = {
      cat = "bat";
      grep = "rg";
      sl = "\\ls";
      ls = "lsd --group-dirs first";
      ll = "lsd --group-dirs first -al";
      l = "lsd -l";

      tree = "lsd --tree --group-dirs first --depth=2 2>/dev/null";
    };
  };
}
