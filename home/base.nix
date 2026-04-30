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

  # Forward Bluetooth AVRCP commands (headphone buttons) to MPRIS media players
  systemd.user.services.mpris-proxy = {
    Unit = {
      Description = "Bluetooth MPRIS proxy";
      After = [
        "network.target"
        "sound.target"
      ];
    };
    Service = {
      ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

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
