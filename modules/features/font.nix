{ ... }:

{
  flake.nixosModules.font =
    { config, pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        # Google fonts
        google-fonts
        # nerdfonts
        nerd-fonts.symbols-only
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
      ];

      fonts.fontconfig = {
        defaultFonts = {
          serif = [
            "Shippori Mincho"
          ];
          sansSerif = [
            "Noto Sans Traditional Chinese"
            "Noto Sans Simplified Chinese"
            "Klee One"
          ];
        };
      };
    };
}
