{ configs, pkgs, ... }:

{
  imports = [
    ./niri.nix
    ./fonts
    ./gaming.nix
  ];
}
