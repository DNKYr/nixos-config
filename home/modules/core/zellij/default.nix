{ config, pkgs, ... }:

{

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      default_shell = "${pkgs.nushell}/bin/nu";
      theme = "tokyo-night";
      show_startup_tips = false;
    };
  };
}
