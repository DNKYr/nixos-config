{config, pkgs, ...}:

{
	home.username = "dnkyr";
	home.homeDirectory = "/home/dnkyr";
	

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

	programs.neovim = {
		enable = true;

	};

	programs.zellij = {
		enable = true;
		enableZshIntegration = true;
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
