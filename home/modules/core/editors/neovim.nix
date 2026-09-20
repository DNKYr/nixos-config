{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
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
