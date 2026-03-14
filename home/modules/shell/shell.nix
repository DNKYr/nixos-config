{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ani-cli # anime watcher
    bat # cat replacement
    bash
    fastfetch
    eza # new-gen ls
    playerctl # MPRIS media player control (used by niri keybindings)
    yazi # Command line file explorer
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

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;

      completions.external = {
        enable = true;
        max_results = 200;
      };
    };
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}
