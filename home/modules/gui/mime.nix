{ config, pkgs, ... }:
{
  # MIME associations consumed by xdg-open. This is what yazi's default
  # "open" opener ends up calling (xdg-open), so pinning PDFs here makes
  # Enter on a .pdf in yazi launch Firefox's built-in viewer — no yazi
  # config needed. Also affects Niri keybindings / any xdg-open user.
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
    "application/x-pdf" = "firefox.desktop";
  };
}
