{ config, ... }:

let

  # Expects this repo cloned to ~/nixos-config on ikuyo (same as aether);
  # the links dangle until it is.
  configPath = "${config.home.homeDirectory}/nixos-config/configs";

in

{
  # Headless agent box: terminal essentials + coding agents only.
  # dev-tools.nix is skipped (too heavy for this VPS); use per-project
  # `nix develop` / direnv for toolchains instead.
  imports = [
    ../../base.nix
    ../../modules/core
    ../../modules/cli/coding-agent.nix
  ];
  home.username = "dnkyr";
  home.homeDirectory = "/home/dnkyr";

  # nvim stays unconfigured here (no ~/.config/nvim): stock nvim, no lazy.nvim.
  xdg.configFile."helix".source = config.lib.file.mkOutOfStoreSymlink "${configPath}/helix";
}
