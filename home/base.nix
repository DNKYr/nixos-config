{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [

    # Browser
    chromium
    firefox
    tor-browser

    # Communication
    discord
    telegram-desktop

    # Editors
    obsidian
    zed-editor

    # Media Player
    foliate # E-Book
    vlc # Audio

    # Livestream
    obs-studio

    # Utility
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
    xwayland-satellite
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
