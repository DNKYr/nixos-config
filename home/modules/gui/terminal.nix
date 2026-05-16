{ pkgs, ... }:

{
  programs.alacritty = {

    enable = true;
    settings = {
      window = {
        opacity = 0.93;
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
}
