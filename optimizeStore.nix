{ lib, pkgs, ...}:

{
	# Don't need this much configuration
	boot.loader.grub.configurationLimit = 10;

	# Do garbage collection weekly to keep the storage low
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};

	nix.settings.auto-optimise-store = true;


}

