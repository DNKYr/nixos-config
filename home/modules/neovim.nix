{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
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
