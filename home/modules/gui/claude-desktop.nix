{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  # Two things upstream's wrapper doesn't cover under niri:
  #
  #  - No Wayland text-input flags, so fcitx5 composition never reaches the app.
  #
  #  - Chromium picks its password-store backend from XDG_CURRENT_DESKTOP, which
  #    is "niri" here. That matches neither GNOME nor KDE, so it falls back to
  #    basic_text, Electron reports safeStorage as unavailable, and the app warns
  #    that the session will not persist. The Secret Service is in fact running
  #    (gnome-keyring owns org.freedesktop.secrets), so just name the backend.
  claude-desktop =
    inputs.claude-desktop.packages.${system}.claude-desktop.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram "$out/bin/claude-desktop" \
          --add-flags "--enable-wayland-ime" \
          --add-flags "--wayland-text-input-version=3" \
          --add-flags "--password-store=gnome-libsecret"
      '';
    });
in
{
  home.packages = [ claude-desktop ];
}
