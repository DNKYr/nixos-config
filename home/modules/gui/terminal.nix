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
          program = "${pkgs.zellij}/bin/zellij";
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
