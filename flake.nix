{
  description = "DNKYr's nix flake";

  inputs = {
    # Adding package source for nix packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # Make home-manager set to the master branch
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      quickshell,
      noctalia,
      ...
    }:
    {
      nixosConfigurations = {
        aether = nixpkgs.lib.nixosSystem {
          modules = [
            # Import disk optimize file
            ./optimizeStore.nix

            # Import niri modules
            ./modules/niri.nix
            # Import virtual machine configuration
            # ./vm/configuration.nix # Comment it out on Laptop

            # Import laptop configuration
            ./laptop/configuration.nix

            # Add home-manager module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.dnkyr = import ./home;
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };

}
