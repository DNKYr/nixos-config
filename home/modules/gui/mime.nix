{ config, pkgs, ... }:
{
  # MIME associations consumed by xdg-open. This is what yazi's default
  # "open" opener ends up calling (xdg-open), so pinning PDFs here makes
  # Enter on a .pdf in yazi launch Firefox's built-in viewer — no yazi
  # config needed. Also affects Niri keybindings / any xdg-open user.
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "firefox.desktop";
    "application/x-pdf" = "firefox.desktop";

    # Default web browser: links opened via xdg-open (terminal, chat apps,
    # Electron apps) go to Firefox.
    "text/html" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}
