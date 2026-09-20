{ config, pkgs, ... }:
let
  # On-demand autoclicker. `theclicker` itself is installed in
  # home/modules/gui/default.nix; it reads raw evdev and emits clicks through a
  # virtual /dev/uinput device, which is why it works under Niri. Requires the
  # `input` group (granted in modules/hosts/aether/configuration.nix).
  #
  # by-id/by-path are used instead of /dev/input/eventN, since event numbering
  # shifts whenever a device is replugged.
  #
  # -l 274 binds BTN_MIDDLE to "toggle left-autoclick". `-d` only selects which
  # device is *watched* for that bind -- the clicks themselves always come out
  # of the separate virtual device, so the watched device need not be the mouse
  # being clicked with. Hence the trackpoint variant below: it leaves a
  # two-button mouse entirely untouched. Ctrl-C to stop.
  clickerFlags = "-l 274 -c 25 -j 3";

  # Wheel-click on the wireless mouse. Preferred -- hand stays on the mouse.
  clickerCmd = "theclicker run -d /dev/input/by-id/usb-Telink_Wireless_Receiver-event-mouse ${clickerFlags}";

  # Fallback for a mouse whose wheel does not press: the ThinkPad middle button
  # between the trackpoint buttons, which is a real BTN_MIDDLE.
  clickerTpCmd = "theclicker run -d /dev/input/by-path/platform-i8042-serio-1-event-mouse ${clickerFlags}";
in
{
  home.packages = with pkgs; [
    ani-cli # anime watcher
    bat # cat replacement
    bash
    bootdev-cli
    fastfetch
    lsd
    eza # new-gen ls
    playerctl # MPRIS media player control (used by niri keybindings)
    yazi # Command line file explorer
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "zoxide"
        "git"
        "sudo"
        "docker"
        "systemd"
        "colored-man-pages"
        "command-not-found"
      ];
    };

    shellAliases = {
      cat = "bat";
      grep = "rg";
      sl = "\\ls";
      ls = "lsd --group-dirs first";
      ll = "lsd --group-dirs first -al";
      l = "lsd -l";

      tree = "lsd --tree --group-dirs first --depth=2 2>/dev/null";

      clicker = clickerCmd;
      clicker-tp = clickerTpCmd;
    };
  };

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;

      completions.external = {
        enable = true;
        max_results = 200;
      };
    };
    shellAliases = {
      grep = "rg";
      cat = "bat";
      cd = "z";

      clicker = clickerCmd;
      clicker-tp = clickerTpCmd;
    };

  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
