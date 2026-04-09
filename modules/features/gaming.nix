{ ... }:

{
  flake.nixosModules.gaming =
    { ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;
        gamescopeSession.enable = true;
      };

      programs.gamemode.enable = true;
      programs.gamescope.enable = true;

      # 32-bit graphics support required for Proton
      hardware.graphics.enable32Bit = true;
    };
}
