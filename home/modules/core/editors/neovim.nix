{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # ~/.config/nvim is an out-of-store symlink to configs/nvim (AstroNvim),
    # so home-manager must not also write nvim/init.lua there. Sideloading
    # passes its generated init (provider host paths) via wrapper args instead.
    sideloadInitLua = true;
  };

  home.packages = with pkgs; [

    # Neovim Dependency
    ripgrep
    lazygit
    gdu
    bottom
    nodejs

    # nvim-treesitter (main branch) build dependency
    tree-sitter

  ];
}
