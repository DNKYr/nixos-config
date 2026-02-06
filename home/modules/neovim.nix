{ config, pkgs, ...}:

{
	programs.neovim = {
		enable = true;
		vimAlias = true;
		extraPackages = with pkgs; [
			nil
			nixpkgs-fmt
		];
	};
}
