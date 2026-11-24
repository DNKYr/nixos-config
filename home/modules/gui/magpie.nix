{ pkgs, lib, ... }:

let
  # Not in nixpkgs. Built from source rather than from the release binary:
  # the desktop build links GTK 3 + WebKitGTK 4.1 through cgo (Wails v3).
  # Upstream's self-updater recognises a /nix/store install and stands down,
  # so bump `version` + both hashes here to update.
  magpie = pkgs.buildGoModule (finalAttrs: {
    pname = "magpie";
    version = "0.1.4341";

    src = pkgs.fetchFromGitHub {
      owner = "yetone";
      repo = "magpie";
      tag = "v${finalAttrs.version}";
      hash = "sha256-4n6IN5I3ZORXQa068S5X72745NI8R9MfGuomuDE6CKY=";
    };

    vendorHash = "sha256-TgMwl324YTy8l9zlkjK/aAqJafP/m3ZbiLLDl1OrffY=";

    subPackages = [ "." ];

    # Mirrors upstream's `make release-linux`.
    tags = [
      "production"
      "gtk3"
      "packedassets"
    ];
    ldflags = [
      "-s"
      "-w"
      "-X main.version=v${finalAttrs.version}"
    ];

    nativeBuildInputs = with pkgs; [
      pkg-config
      wrapGAppsHook3
    ];
    buildInputs = with pkgs; [
      gtk3
      webkitgtk_4_1
    ];

    # `packedassets` embeds the UI as one zip, which isn't kept in git.
    preBuild = ''
      go run ./build/assetpack internal/gui/assets internal/gui/assets.zip
    '';
    # ...but the vendoring derivation inherits preBuild and has no vendor dir yet.
    overrideModAttrs = _: { preBuild = ""; };

    # The suite expects network access and a writable home.
    doCheck = false;

    meta = {
      description = "Model gateway and switcher for coding agents (menu bar app, TUI, web UI, CLI)";
      homepage = "https://github.com/yetone/magpie";
      license = lib.licenses.mit;
      mainProgram = "magpie";
      platforms = lib.platforms.linux;
    };
  });
in
{
  home.packages = [ magpie ];
}
