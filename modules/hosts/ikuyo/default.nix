{ self, inputs, ... }:

{
  flake.nixosConfigurations.ikuyo = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.ikuyo-config
    ];
  };
}
