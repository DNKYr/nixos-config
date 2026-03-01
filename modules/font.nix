{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    #nerdfonts
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];
}
