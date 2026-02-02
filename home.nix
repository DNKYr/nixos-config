{config, pkgs, ...}:

{
	home.username = "dnkyr";
	home.homeDirectory = "/home/dnkyr";
	

	home.packages = with pkgs; [
		fastfetch
		kitty
		gh
		
		zip
		unzip

		zed-editor
		firefox
		neovim
		
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



	home.stateVersion = "25.11";
	 


}
