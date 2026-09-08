{ config, pkgs, ... }:

{
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
