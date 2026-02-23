{ config, pkgs, ... }:

{

  # Enable the niri Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.niri.package = pkgs.niri;
  programs.niri.enable = true;
  services.displayManager.sessionPackages = [ pkgs.niri ];

}
