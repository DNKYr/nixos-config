{ ... }:

{
  flake.nixosModules.mirror =
    { lib, ... }:
    {
      # Use Chinese binary cache mirrors for faster downloads.
      # TUNA is primary; cache.nixos.org as fallback.
      # Both serve the same content, same signing key.
      nix.settings.substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];

      nix.settings.trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      # Increase connection resilience for unstable networks
      nix.settings.connect-timeout = 10;
      nix.settings.http-connections = 50;
    };

}
