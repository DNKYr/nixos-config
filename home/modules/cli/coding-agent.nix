{ pkgs, ... }:

let
  # Upstream Bun-compiled binary; not in nixpkgs. Patching/stripping breaks
  # the embedded payload, so it relies on nix-ld (enabled on aether) to run.
  openscience = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "openscience";
    version = "2.0.151";
    src = pkgs.fetchurl {
      url = "https://github.com/synthetic-sciences/OpenScience/releases/download/v${version}/openscience-linux-x64.tar.gz";
      hash = "sha256-9eKLRW2fxO1eEb4jRx88hpuzS6Ber129oE9KfuT/FYE=";
    };
    sourceRoot = ".";
    dontStrip = true;
    dontPatchELF = true;
    installPhase = "install -Dm755 openscience $out/bin/openscience";
  };
in
{
  home.packages = with pkgs; [
    claude-code
    opencode
    pi-coding-agent
    codex
    openscience
  ];

}
