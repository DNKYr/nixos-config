{config, pkgs, ...}:

{
	imports = [
		./modules/neovim.nix
		./modules/shell.nix
	];
	home.username = "dnkyr";
	home.homeDirectory = "/home/dnkyr";
	
	xdg.configFile."nvim".source = ./modules/nvim-configs;

	home.packages = with pkgs; [
		
		# Browser
		firefox

		# Code

		#Python
		python312

		# Command line tools
		fastfetch
		lsd # new-gen ls

		# Editors
		zed-editor

		# Shell
		bash

		# Utility
		# Neovim dependency
		ripgrep
		lazygit
		gdu
		bottom
		nodejs

		unzip
		zip

		
	];


	programs.gcc = {
		enable = true;
	};
	
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
