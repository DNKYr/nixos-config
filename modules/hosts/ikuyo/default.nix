{ self, inputs, ... }:

{
  flake.nixosConfigurations.ikuyo = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.ikuyo-config
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = { inherit inputs; };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dnkyr = import ../../../home/hosts/ikuyo/home.nix;
          backupFileExtension = "backup";
        };
      }
    ];
  };
}
