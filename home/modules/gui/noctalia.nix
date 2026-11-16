{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    settings = {
      wallpaper.default.path = "${../../wallpapers/1387138.png}";
    };
  };
}
