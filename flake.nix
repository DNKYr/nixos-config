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

		        home-manager.users.dnkyr = import ./home/home.nix;
		    }
	        ];
	    };
	};
    };

}
