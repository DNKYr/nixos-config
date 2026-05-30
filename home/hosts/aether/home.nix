{
  config,
  pkgs,
  inputs,
  ...
}:

let

  configPath = "${config.home.homeDirectory}/nixos-config/configs";
  nvimPath = "${configPath}/nvim";
  hxPath = "${configPath}/helix";
  niriPath = "${configPath}/niri";

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

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;
  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink niriPath;
  xdg.configFile."helix".source = config.lib.file.mkOutOfStoreSymlink hxPath;

  home.file.".clang-format".text = ''
    BasedOnStyle: LLVM
    IndentWidth: 4
    TabWidth: 4
    UseTab: Never
  '';
  home.packages = [ inputs.emtodo.packages.x86_64-linux.default ];
}
