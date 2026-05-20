{ pkgs, ... }:
{
  imports = [
    ./helix.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    # Language server + formatter - shared by helix & neovim
    nil
    nixpkgs-fmt
    lua-language-server
    pyright
    clang-tools
    rust-analyzer
  ];
}
