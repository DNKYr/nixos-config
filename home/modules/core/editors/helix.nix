{ ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language-server = {
        nil.command = "nil";
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nil" ];
          formatter.command = "nixfmt";
        }
        {
          name = "python";
          language-servers = [ "pyright" ];
        }
      ];
    };

    themes = {
      rose_pine_transparent = {
        inherits = "rose_pine";
        "ui.background" = { };
      };
    };

    settings = {
      theme = "rose_pine";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;

        # use system clipboard by default
        default-yank-register = "+";
        # Wrap long line to viewport
        soft-wrap = {
          enable = true;
        };

        # Completion
        auto-completion = true;
        path-completion = true;
        auto-format = true;
        preview-completion-insert = true;

        # LSP
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };

        # status line layout
        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [ ];
          right = [
            "workspace-diagnostics"
            "diagnostics"
            "position"
            "position-percentage"
            "file-type"
          ];
          separator = "|";
          diagnostics = [
            "error"
            "warning"
            "info"
          ];
          workspace-diagnostics = [
            "error"
            "warning"
          ];
          mode = {
            normal = "NOR";
            insert = "INS";
            select = "SEL";
          };
        };

        true-color = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
