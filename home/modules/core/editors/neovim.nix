{ config, pkgs, ... }:

{
  home.packages = with pkgs; [

    # Neovim Dependency
    ripgrep
    lazygit
    gdu
    bottom
    nodejs

  ];
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
  };
}
