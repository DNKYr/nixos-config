# Neovim configuration (from scratch) — Design

## Goal

Replace the AstroNvim v5+ config in `configs/nvim/` with a from-scratch Neovim
configuration built on lazy.nvim + hand-picked plugins. Language servers and
formatters remain Nix-managed (no Mason). The config is symlinked into
`~/.config/nvim` via `home/hosts/aether/home.nix` (unchanged).

## Approach

- Plugin manager: `folke/lazy.nvim`.
- LSPs / formatters / linters: installed as Nix packages, discovered on `PATH`
  by `nvim-lspconfig` / `conform.nvim` / `nvim-lint`. No Mason.
- Target languages (unchanged from current set): Nix, Lua, Python, C/C++, Rust.
- Theme: catppuccin.
- Fuzzy finder: telescope.nvim.
- Leader key: space.
- Neovim is installed system-wide via `modules/features/base/default.nix`
  (unchanged). Helper packages (ripgrep, lazygit, gdu, bottom, nodejs) stay in
  `home/modules/core/editors/neovim.nix` (unchanged), plus a new
  `tree-sitter` CLI dependency (see below).
- Treesitter: `nvim-treesitter/nvim-treesitter` on the current `main` branch
  (active, not archived — `main` is a breaking rewrite requiring Nvim 0.12+,
  satisfied by 0.12.4). Parsers install at runtime via `:TSUpdate`
  (downloads + compiles grammars with `tree-sitter` CLI, `curl`, `tar`, `gcc`),
  matching the pre-existing behavior; parsers are not Nix-reproducible.

## Directory structure

```
configs/nvim/
├── init.lua                  # lazy.nvim bootstrap + require core
├── .stylua.toml              # kept (formats the Lua config itself)
├── .luarc.json               # kept (lua-language-server annotations)
└── lua/
    ├── core/
    │   ├── options.lua       # vim.opt / vim.g settings
    │   ├── keymaps.lua       # leader = space + global maps
    │   └── autocmds.lua
    └── plugins/
        ├── colorscheme.lua   # catppuccin
        ├── editor.lua        # treesitter, autopairs, comment, indent-blankline, which-key
        ├── lsp.lua           # lspconfig + nvim-cmp + LuaSnip
        ├── telescope.lua     # telescope + fzf-native
        ├── formatting.lua    # conform + nvim-lint (format/lint on save)
        ├── git.lua           # gitsigns + lazygit
        └── ui.lua            # lualine, bufferline, snacks dashboard
```

## Plugin list

| Area | Plugins |
|------|---------|
| Manager | lazy.nvim |
| Theme | catppuccin/nvim |
| Syntax | nvim-treesitter/nvim-treesitter (main, `build = ':TSUpdate'`) + nvim-treesitter/nvim-treesitter-textobjects |
| LSP | neovim/nvim-lspconfig → nil, lua_ls, pyright, clangd, rust_analyzer |
| Completion | hrsh7th/nvim-cmp + cmp-nvim-lsp, cmp-buffer, cmp-path, cmp_luasnip |
| Snippets | L3MON4D3/LuaSnip + rafamadriz/friendly-snippets |
| Fuzzy finder | nvim-telescope/telescope.nvim + plenary.nvim + telescope-fzf-native.nvim |
| Icons | nvim-tree/nvim-web-devicons |
| Format/lint | stevearc/conform.nvim + mfussenegger/nvim-lint |
| Git | lewis6991/gitsigns.nvim + lazygit (launched via snacks) |
| Statusline/tabs | nvim-lualine/lualine.nvim + akinsho/bufferline.nvim |
| Dashboard/term | folke/snacks.nvim (dashboard, lazygit launcher, terminal) |
| QoL | folke/which-key.nvim, windwp/nvim-autopairs, numToStr/Comment.nvim, lukas-reineke/indent-blankline.nvim |

## Format / lint wiring

**conform.nvim (format on save):**

| Filetype | Formatter | Source |
|----------|-----------|--------|
| nix | nixpkgs-fmt | `editors/default.nix` |
| lua | stylua | `editors/default.nix` (to add) |
| python | ruff | `dev-tools.nix` |
| c, cpp | clang-format | clang-tools (`editors/default.nix`) |
| rust | rustfmt | rustup (`dev-tools.nix`) |

**nvim-lint:**

- python → ruff
- c, cpp → clang-tidy

## Nix module changes

Two changes required:

- `home/modules/core/editors/default.nix`: add `stylua` to the shared
  LSP/formatter package list. All other tools (ruff, clang-format via
  clang-tools, rustfmt via rustup) already exist in `dev-tools.nix`.
- `home/modules/core/editors/neovim.nix`: add `tree-sitter` (nixpkgs package
  providing the `tree-sitter` CLI ≥0.26.1) as a nvim-treesitter build
  dependency. `curl` (base) and `gcc` (dev-tools) already exist.

## Files removed

All AstroNvim-specific files under `configs/nvim/`:

- `lua/community.lua`
- `lua/lazy_setup.lua`
- `lua/polish.lua`
- `lua/plugins/*.lua` (astrocore, astrolsp, astroui, mason, none-ls, treesitter, user)
- `README.md`
- `selene.toml`
- `.neoconf.json`
- `neovim.yml`

`.stylua.toml` and `.luarc.json` are retained (tooling config for the Lua files).

## Out of scope

- Mason / any runtime package installation (except tree-sitter parsers, which
  are runtime-installed by design per the `nvim-treesitter` `main` workflow).
- File explorer (neo-tree / oil.nvim) — not requested.
- Changes to the Nix-managed LSP language set (stays Nix/Lua/Python/C++/Rust).
- Home-manager wiring — the existing `xdg.configFile."nvim"` symlink is reused.
