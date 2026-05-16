{ pkgs, inputs, ... }:

let

  configs = ../../../configs;

in

{
  imports = [
    ../../base.nix
    ../../modules/gui
    ../../modules/cli
    ../../modules/core
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
  home.packages = [ inputs.emtodo.packages.x86_64-linux.default ];
}
