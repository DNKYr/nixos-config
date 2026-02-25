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
    extraPackages = with pkgs; [
      # Nix LSP
      nil
      nixpkgs-fmt

      # Lua LSp
      lua-language-server

      # Python LSP
      pyright

      # C++ LSP
      clang-tools
    ];
  };
}
