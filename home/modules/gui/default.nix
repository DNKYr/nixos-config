{ config, pkgs, ... }:
{
  imports = [
    ./gaming.nix
    ./noctalia.nix
    ./zen-browser.nix
    ./terminal.nix
  ];

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
}
