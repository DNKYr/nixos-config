{ ... }:

{
  flake.nixosModules.ikuyo-xray =
    { config, ... }:
    {
      services.xray = {
        enable = true;
        settingsFile = config.age.secrets.ikuyo-xray-config.path;
      };
    };
}
