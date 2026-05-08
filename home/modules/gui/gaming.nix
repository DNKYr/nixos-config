{
  pkgs,
  configs,
  inputs,
  ...
}:

{
  home.packages = [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
    pkgs.heroic
    pkgs.prismlauncher # Minecraft Launcher
    pkgs.protonplus # DW-Proton for Arknights:Endfield
  ];
}
