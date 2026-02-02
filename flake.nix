{
    description = "A simple nix flakes";
    
    inputs = {
        # Adding package source for nix packages
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

	home-manager = {
	    url = "github:nix-community/home-manager/release-25.11";
	    inputs.nixpkgs.follows = "nixpkgs";
	};
    };

    outputs = inputs@{ nixpkgs, home-manager, ...}: {
	nixosConfigurations = {
	    aether = nixpkgs.lib.nixosSystem{
	        modules = [
		    # Import previous configuration
		    ./configuration.nix

		    # Add home-manager module
		    home-manager.nixosModules.home-manager
		    {
		        home-manager.useGlobalPkgs = true;
		        home-manager.useUserPackages = true;

		        home-manager.users.dnkyr = import ./home.nix;
		    }
	        ];
	    };
	};
    };

}
