{ config, pkgs, ... }:
{
  imports = [
    ./gaming.nix
    ./noctalia.nix
    ./zen-browser.nix
    ./terminal.nix
    ./android.nix
    ./spotify.nix
    ./claude-desktop.nix
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

}
