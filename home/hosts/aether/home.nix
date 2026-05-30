{
  config,
  pkgs,
  inputs,
  ...
}:

let

  configPath = "${config.home.homeDirectory}/nixos-config/configs";
  configs = ../../../configs;
  hxPath = "${configPath}/helix";

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
  xdg.configFile."helix".source = config.lib.file.mkOutOfStoreSymlink hxPath;

  home.file.".clang-format".text = ''
    BasedOnStyle: LLVM
    IndentWidth: 4
    TabWidth: 4
    UseTab: Never
  '';
  home.packages = [ inputs.emtodo.packages.x86_64-linux.default ];
}
