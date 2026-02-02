{config, pkgs, ...}:

{
	home.username = "dnkyr";
	home.homeDirectory = "/home/dnkyr";
	

	home.packages = with pkgs; [
		
		# Browser
		firefox

		# Command line tools
		fastfetch
		gh # Github CLI
		kitty # terminal eluminator
		lsd # new-gen ls
		zellij # terminal multiplixer

		# Editors
		neovim
		zed-editor

		# Shell
		bash

		oh-my-zsh
		zsh

		# Utility
		unzip
		zip

		
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
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		oh-my-zsh = {
			enable = true;
			plugins = [
				"git"
			];
		};
	};



	home.stateVersion = "25.11";
	 


}
