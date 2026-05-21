{ ... }:
{
  programs.helix = {
    enable = true;
    languages = {
      language-server = {
        nil.command = "nil";
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
        };
      };

      languages = [
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

    settings = {
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
      };
    };
  };
}
