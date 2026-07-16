{ config, pkgs, ... }:

{

  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      default_shell = "${pkgs.zsh}/bin/zsh";
      theme = "tokyo-night";
      show_startup_tips = false;
    };
  };
}
