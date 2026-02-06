{config, pkgs, ...}:
let

configs = ../configs;

in

{
	imports = [
		./modules/neovim.nix
		./modules/shell.nix
	];
	home.username = "dnkyr";
	home.homeDirectory = "/home/dnkyr";
	
	# TODO: Update the config file call to DRY principle 
	xdg.configFile."nvim".source = "${configs}/nvim/";
	xdg.configFile."niri".source = "${configs}/niri/";
	

	home.packages = with pkgs; [
		
		# Browser
		firefox

		# Code

		# Nix
		nil
		nixpkgs-fmt
		#Python
		gcc
		python312

		# Command line tools
		fastfetch
		lsd # new-gen ls

		# Editors
		zed-editor

		# Shell
		bash

		# Utility
		# Neovim Dependency
		ripgrep
		lazygit
		gdu
		bottom
		nodejs

		unzip
		zip

		#Niri Dependency
		glibc
		wayland
		wayland-protocols
		libinput
		libdrm
		libxkbcommon
		pixman
		meson
		ninja
		libdisplay-info
		libliftoff
		hwdata
		seatd
		pcre2

		#Niri optional
		alacritty
	];

	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "DNKYr";
				email = "dnkyr2007@gmail.com";
			};
			
			pull.rebase = true;
			init.defaultBranch = "main";
		};
	};

	programs.gh = {
		enable = true;
		settings = {
			git_protocol = "https";
		};
		gitCredentialHelper.enable = true;
	};


	programs.kitty = {
		enable = true;

		settings = {
			shell = "${pkgs.zsh}/bin/zsh";
		};
	};

	programs.zellij = {
		enable = true;
		enableZshIntegration = true;
		settings = {
			default_shell = "${pkgs.zsh}/bin/zsh";
		};
	};

	home.stateVersion = "25.11";
}
