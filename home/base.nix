{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Utility
    unzip
    zip
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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

    # Repos under ~/sakura/ commit as SakuraRainn
    includes = [
      {
        condition = "gitdir:~/sakura/";
        contents.user = {
          name = "SakuraRainn";
          email = "SakuraRainn@proton.me";
        };
      }
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
    gitCredentialHelper.enable = true;
  };

  programs.fastfetch = {
    enable = true;
  };

  programs.jujutsu = {
    enable = true;
  };

  home.stateVersion = "25.11";
}
