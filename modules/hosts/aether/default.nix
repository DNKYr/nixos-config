{ self, inputs, ... }:
{

  flake.nixosConfigurations.aether = inputs.nixpkgs.lib.nixosSystem {
    # system = "x86_64-linux";
    # specialArgs = { inherit inputs; };
    modules = [
      self.nixosModules.aether-config
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = { inherit inputs; };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.dnkyr = import ../../../home/hosts/aether/home.nix;
          backupFileExtension = "backup";
        };
      }
    ];

  };
}
