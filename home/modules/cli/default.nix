{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
  ];
  imports = [
    ./coding-agent.nix
  ];
}
