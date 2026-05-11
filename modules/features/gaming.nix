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

      # Endfield deadlock on fsync
      # ntsync replaces it with a kernel-side primitive that doesn't.
      boot.kernelModules = [ "ntsync" ];

      # 32-bit graphics support required for Proton
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      services.auto-cpufreq.enable = true;
    };
}
