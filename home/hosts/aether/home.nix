{ pkgs, inputs, ... }:

let

  configs = ../../../configs;

in

{
  imports = [
    ../../base.nix
    ../../modules/neovim.nix
    ../../modules/shell
    ../../modules/noctalia.nix
    ../../modules/zen-browser.nix
    ../../modules/claude.nix
    ../../modules/gaming.nix
  ];
  home.username = "dnkyr";
  home.homeDirectory = "/home/dnkyr";

  xdg.configFile."nvim".source = "${configs}/nvim/";
  xdg.configFile."niri".source = "${configs}/niri/";

  home.file.".clang-format".text = ''
    BasedOnStyle: LLVM
    IndentWidth: 4
    TabWidth: 4
    UseTab: Never
  '';
}
