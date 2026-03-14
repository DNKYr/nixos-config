{ config, pkgs, ... }:

{

  programs.alacritty = {

    enable = true;
    settings = {
      window = {
        opacity = 0.93;
        startup_mode = "Maximized";
        dynamic_title = true;
      };

      terminal = {
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
        };
      };

      font = {
        normal = {
          family = "FiraCode Nerd Font";
        };
      };
    };
  };

  programs.kitty = {
    enable = true;

    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };

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
