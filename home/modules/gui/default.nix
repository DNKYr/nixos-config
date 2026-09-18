{ config, pkgs, ... }:
{
  imports = [
    ./gaming.nix
    ./noctalia.nix
    ./zen-browser.nix
    ./terminal.nix
    ./android.nix
    ./spotify.nix
  ];

  home.packages = with pkgs; [

    # Browser
    # chromium
    firefox
    tor-browser

    # Communication
    discord
    telegram-desktop
    qq

    # Editors
    obsidian
    zed-editor
    libreoffice

    # voice to text
    (voxtype.override { vulkanSupport = true; })

    # File Explorer
    kdePackages.dolphin
    udiskie

    # File Transfer
    localsend

    # Media Player
    foliate # E-Book
    vlc # Audio

    # Livestream
    obs-studio

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

    #VPN
    clash-verge-rev
  ];

  # voxtype's Quickshell OSD needs its QML tree installed. The nixpkgs package
  # only ships the binaries + default config, not the quickshell/ QML files, so
  # symlink them from the package source into $XDG_DATA_HOME/voxtype/quickshell/.
  xdg.dataFile = {
    "voxtype/quickshell/shell.qml".source = "${pkgs.voxtype.src}/quickshell/shell.qml";
    "voxtype/quickshell/OsdSurface.qml".source = "${pkgs.voxtype.src}/quickshell/OsdSurface.qml";
    "voxtype/quickshell/EnginePicker.qml".source = "${pkgs.voxtype.src}/quickshell/EnginePicker.qml";
    "voxtype/quickshell/MeetingControls.qml".source = "${pkgs.voxtype.src}/quickshell/MeetingControls.qml";
    "voxtype/quickshell/voxtype-shared/AudioBridge.qml".source = "${pkgs.voxtype.src}/quickshell/voxtype-shared/AudioBridge.qml";
    "voxtype/quickshell/voxtype-shared/qmldir".source = "${pkgs.voxtype.src}/quickshell/voxtype-shared/qmldir";
    "voxtype/quickshell/voxtype-shared/StateReader.qml".source = "${pkgs.voxtype.src}/quickshell/voxtype-shared/StateReader.qml";
    "voxtype/quickshell/voxtype-shared/Theme.qml".source = "${pkgs.voxtype.src}/quickshell/voxtype-shared/Theme.qml";
  };

  # aw-watcher-window-wayland replaces ActivityWatch's X11-based window and
  # AFK watchers. It reports both buckets itself, so do not let aw-qt start
  # aw-watcher-window or aw-watcher-afk as well.
  xdg.configFile."activitywatch/aw-qt/aw-qt.toml".text = ''
    [aw-qt]
    autostart_modules = ["aw-server"]

    [aw-qt-testing]
    autostart_modules = ["aw-server"]
  '';

  # Start the Wayland watcher with the graphical session. It reports both
  # window and AFK events, so the X11 watchers must stay disabled in aw-qt.
  systemd.user.services.aw-watcher-window-wayland = {
    Unit = {
      Description = "ActivityWatch Wayland window watcher";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.aw-watcher-window-wayland}/bin/aw-watcher-window-wayland";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
