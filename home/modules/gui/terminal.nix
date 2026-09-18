{ pkgs, ... }:

{
  programs.alacritty = {

    enable = true;
    settings = {
      window = {
        opacity = 0.93;
        dynamic_title = true;
      };

      terminal.shell = "zsh";

      font = {
        normal = {
          family = "FiraCode Nerd Font";
        };
      };
    };
  };
}
