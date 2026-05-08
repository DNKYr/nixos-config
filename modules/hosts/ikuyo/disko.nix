{ inputs, ... }:
{
  flake.nixosModules.ikuyo-disko =
    { ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];
      disko.devices.disk.main = {
        device = "/dev/sda";
        type = "disk";
        content.type = "gpt";
        content.partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
}
