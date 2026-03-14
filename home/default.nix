{
  config,
  pkgs,
  ...
}:
let

  configs = ../configs;

in

{
  imports = [
    ./modules/neovim.nix
    ./modules/shell
    ./modules/noctalia.nix
    ./modules/zen-browser.nix
    ./modules/claude.nix
    ./modules/cpp-dev.nix
    ./modules/gaming.nix
  ];
  home.username = "dnkyr";
  home.homeDirectory = "/home/dnkyr";

  xdg.configFile."nvim".source = "${configs}/nvim/";
  xdg.configFile."niri".source = "${configs}/niri/";

  home.file.".clang-format".text = ''
    BasedOnStyle: LLVM
    IndentWidth: 4
    TabWidth: 4
    UseTab: Never
  '';

  home.packages = with pkgs; [

    # Browser
    firefox
    tor-browser

    # Communication
    telegram-desktop

    # Editors
    obsidian
    zed-editor

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

  home.stateVersion = "25.11";
}
