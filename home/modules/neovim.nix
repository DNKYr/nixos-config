{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      nil
      nixpkgs-fmt

      lua-language-server
      pyright
    ];
  };
}
