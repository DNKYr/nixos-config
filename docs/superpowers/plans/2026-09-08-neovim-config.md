# Neovim Configuration (from scratch) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the AstroNvim config in `configs/nvim/` with a from-scratch lazy.nvim + hand-picked-plugins configuration, with Nix-managed LSPs/formatters.

**Architecture:** A minimal `init.lua` bootstraps lazy.nvim and loads `lua/core/*` (options/keymaps/autocmds) plus `lua/plugins/*` (one file per plugin group). Plugins are specified as lazy.nvim specs; each file `return { ... }` a table of specs. LSPs and formatters are resolved from `PATH` (installed by Nix). Treesitter parsers install at runtime via the rewritten `nvim-treesitter` `main` branch.

**Tech Stack:** Neovim 0.12.4, lazy.nvim, nvim-lspconfig, nvim-cmp, LuaSnip, telescope.nvim, conform.nvim, nvim-lint, gitsigns, lualine, bufferline, snacks.nvim, catppuccin.

## Global Constraints

- Neovim ≥ 0.12 (installed: 0.12.4).
- No Mason. All LSPs/formatters/linters are Nix packages discovered on `PATH`.
- Leader key = space (`vim.g.mapleader = " "`).
- Target languages: Nix (nil), Lua (lua_ls), Python (pyright), C/C++ (clangd), Rust (rust_analyzer).
- Formatters: nix → nixpkgs-fmt, lua → stylua, python → ruff, c/cpp → clang-format, rust → rustfmt.
- Lua files use 2-space indent (stylua); global editor tabstop/shiftwidth is 4 (clang-format convention), overridden to 2 for `lua` filetype via autocmd.
- `nvim-treesitter/nvim-treesitter` on `main` branch, `build = ":TSUpdate"`, parsers listed via `require("nvim-treesitter").install({...})`; highlighting enabled via `vim.treesitter.start()` in a `FileType` autocmd.
- Config lives in `configs/nvim/`, symlinked to `~/.config/nvim` (out-of-store symlink — edits take effect immediately, no rebuild).
- Nix changes require `nixos-rebuild` to take effect; Lua changes do not.

---

### Task 1: Nix package changes (stylua + tree-sitter CLI)

**Files:**
- Modify: `home/modules/core/editors/default.nix`
- Modify: `home/modules/core/editors/neovim.nix`

**Interfaces:**
- Consumes: nothing.
- Produces: `stylua` (lua formatter) and `tree-sitter` (CLI ≥0.26.1) on `PATH` for the `dnkyr` user; used by conform.nvim (Task 7) and nvim-treesitter (Task 4).

- [ ] **Step 1: Add `stylua` and bind `lib` in `default.nix`**

Edit `home/modules/core/editors/default.nix`. Replace the header line and add `stylua` to the package list:

```nix
{ pkgs, lib, ... }:
{
  imports = [
    ./helix.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    # Language server + formatter - shared by helix & neovim
    nil
    nixpkgs-fmt
    lua-language-server
    pyright
    clang-tools
    stylua
    (lib.hiPrio pkgs.rust-analyzer)
  ];
}
```

(Note: the previous header was `{ pkgs, ... }:` but the body already referenced `lib.hiPrio`; binding `lib` explicitly fixes that latent unbound-variable.)

- [ ] **Step 2: Add `tree-sitter` CLI to `neovim.nix`**

Edit `home/modules/core/editors/neovim.nix` to add `tree-sitter`:

```nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [

    # Neovim Dependency
    ripgrep
    lazygit
    gdu
    bottom
    nodejs

    # nvim-treesitter (main branch) build dependency
    tree-sitter

  ];
}
```

- [ ] **Step 3: Verify the Nix evaluation**

Run: `nixos-rebuild build --flake .#aether`
Expected: build succeeds (exit 0). This pulls `stylua` and `tree-sitter` into the aether closure.

- [ ] **Step 4: Commit**

```bash
git add home/modules/core/editors/default.nix home/modules/core/editors/neovim.nix
git commit -m "feat(nvim): add stylua and tree-sitter CLI for from-scratch config"
```

---

### Task 2: Remove AstroNvim files + write `init.lua`

**Files:**
- Remove (git rm): `configs/nvim/README.md`, `configs/nvim/neovim.yml`, `configs/nvim/selene.toml`, `configs/nvim/.neoconf.json`, `configs/nvim/lua/community.lua`, `configs/nvim/lua/lazy_setup.lua`, `configs/nvim/lua/polish.lua`, and all of `configs/nvim/lua/plugins/*.lua` (astrocore, astrolsp, astroui, mason, none-ls, treesitter, user)
- Rewrite: `configs/nvim/init.lua`

**Interfaces:**
- Produces: `init.lua` requiring `core.options`, `core.keymaps`, `core.autocmds` (Task 3) and `require("lazy").setup({ import = "plugins" })` (loads Tasks 4-8 plugin specs).

- [ ] **Step 1: Remove the old AstroNvim files**

```bash
git rm -r configs/nvim/README.md configs/nvim/neovim.yml configs/nvim/selene.toml \
  configs/nvim/.neoconf.json configs/nvim/lua/community.lua \
  configs/nvim/lua/lazy_setup.lua configs/nvim/lua/polish.lua \
  configs/nvim/lua/plugins/astrocore.lua configs/nvim/lua/plugins/astrolsp.lua \
  configs/nvim/lua/plugins/astroui.lua configs/nvim/lua/plugins/mason.lua \
  configs/nvim/lua/plugins/none-ls.lua configs/nvim/lua/plugins/treesitter.lua \
  configs/nvim/lua/plugins/user.lua
```

- [ ] **Step 2: Rewrite `configs/nvim/init.lua`**

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.keymaps")
require("core.autocmds")

require("lazy").setup({ import = "plugins" })
```

- [ ] **Step 3: Verify syntax**

Run: `nvim --headless -u NONE -c "lua vim.opt.rtp:append('configs/nvim')" -c "luafile configs/nvim/init.lua" -c "qa"`
Expected: exit 0. (Will attempt to clone lazy.nvim on first run; this requires network. If `core.*` files don't exist yet — see Task 3 — expect a `module 'core.options' not found` error, which is fine at this stage.)

- [ ] **Step 4: Commit**

```bash
git add -A configs/nvim
git commit -m "feat(nvim): replace AstroNvim with lazy.nvim bootstrap"
```

---

### Task 3: Core files (options, keymaps, autocmds)

**Files:**
- Create: `configs/nvim/lua/core/options.lua`
- Create: `configs/nvim/lua/core/keymaps.lua`
- Create: `configs/nvim/lua/core/autocmds.lua`

**Interfaces:**
- Consumes: nothing (loaded by `init.lua`).
- Produces: global settings, leader-key maps, and the treesitter `FileType` autocmd that Tasks 4-8 rely on for highlighting.

- [ ] **Step 1: Create `options.lua`**

```lua
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.splitbelow = true
opt.splitright = true

opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400

opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

opt.hidden = true
opt.showmode = false
opt.laststatus = 3
opt.swapfile = false
```

- [ ] **Step 2: Create `keymaps.lua`**

```lua
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("v", "<", "<gv", { desc = "De-indent" })
map("v", ">", ">gv", { desc = "Indent" })
```

- [ ] **Step 3: Create `autocmds.lua`**

```lua
local augroup = vim.api.nvim_create_augroup("user", { clear = true })

-- Enable treesitter highlighting for any buffer that has a parser available.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- 2-space indent for lua (matches stylua config).
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
})

-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
  end,
})

-- Restore cursor position on reopen.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
```

- [ ] **Step 4: Verify syntax (all three load cleanly)**

Run:
```bash
nvim --headless -u NONE \
  -c "luafile configs/nvim/lua/core/options.lua" \
  -c "luafile configs/nvim/lua/core/keymaps.lua" \
  -c "luafile configs/nvim/lua/core/autocmds.lua" \
  -c "qa"
```
Expected: exit 0, no error output.

- [ ] **Step 5: Commit**

```bash
git add configs/nvim/lua/core
git commit -m "feat(nvim): add core options, keymaps, and autocmds"
```

---

### Task 4: Colorscheme + editor plugins (treesitter, autopairs, comment, indent-blankline, which-key, textobjects)

**Files:**
- Create: `configs/nvim/lua/plugins/colorscheme.lua`
- Create: `configs/nvim/lua/plugins/editor.lua`

**Interfaces:**
- Consumes: `tree-sitter` CLI on PATH (Task 1), treesitter `FileType` autocmd (Task 3).
- Produces: catppuccin colorscheme, treesitter parsers (runtime), textobject select keymaps, and editing QoL plugins.

- [ ] **Step 1: Create `colorscheme.lua`**

```lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = true,
        which_key = true,
        bufferline = true,
        snacks = true,
        indent_blankline = { enabled = true },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
```

- [ ] **Step 2: Create `editor.lua`**

```lua
return {
  -- Treesitter: main branch (rewrite). Parsers install at runtime via :TSUpdate.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install({
        "nix",
        "lua",
        "python",
        "c",
        "cpp",
        "rust",
        "vim",
        "vimdoc",
        "bash",
      })
    end,
  },

  -- Syntax-aware text objects (function/class/parameter selection).
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",
          },
        },
      })
      local select = require("nvim-treesitter-textobjects.select")
      vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "Around function" })
      vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "Inside function" })
      vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "Around class" })
      vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "Inside class" })
    end,
  },

  -- Auto-close brackets/quotes.
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- Toggle comments with gc / gcc.
  { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },

  -- Indent guides.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {},
  },

  -- Keymap discoverability.
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
}
```

- [ ] **Step 3: Verify syntax**

Run:
```bash
nvim --headless -u NONE -c "luafile configs/nvim/lua/plugins/colorscheme.lua" -c "qa"
nvim --headless -u NONE -c "luafile configs/nvim/lua/plugins/editor.lua" -c "qa"
```
Expected: both exit 0 (spec tables are only evaluated, not executed).

- [ ] **Step 4: Commit**

```bash
git add configs/nvim/lua/plugins/colorscheme.lua configs/nvim/lua/plugins/editor.lua
git commit -m "feat(nvim): add catppuccin and editor plugins (treesitter, textobjects, QoL)"
```

---

### Task 5: LSP + completion + snippets

**Files:**
- Create: `configs/nvim/lua/plugins/lsp.lua`

**Interfaces:**
- Consumes: LSPs on PATH (nil, lua_ls, pyright, clangd, rust_analyzer — installed by Nix).
- Produces: LSP attach keymaps (`gd`, `gD`, `gr`, `gi`, `gt`, `K`, `<leader>rn`, `<leader>ca`) and nvim-cmp completion wired to LSP/buffer/path/luasnip.

- [ ] **Step 1: Create `lsp.lua`**

```lua
local on_attach = function(_, bufnr)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  map("gd", vim.lsp.buf.definition, "Goto definition")
  map("gD", vim.lsp.buf.declaration, "Goto declaration")
  map("gr", vim.lsp.buf.references, "References")
  map("gi", vim.lsp.buf.implementation, "Implementation")
  map("gt", vim.lsp.buf.type_definition, "Type definition")
  map("<leader>rn", vim.lsp.buf.rename, "Rename")
  map("<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("K", vim.lsp.buf.hover, "Hover")
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")

      local servers = {
        nil_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        pyright = {},
        clangd = {},
        rust_analyzer = {},
      }

      for server, opts in pairs(servers) do
        opts = vim.tbl_deep_extend("force", {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = on_attach,
        }, opts)
        lspconfig[server].setup(opts)
      end
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
```

- [ ] **Step 2: Verify syntax**

Run: `nvim --headless -u NONE -c "luafile configs/nvim/lua/plugins/lsp.lua" -c "qa"`
Expected: exit 0.

- [ ] **Step 3: Commit**

```bash
git add configs/nvim/lua/plugins/lsp.lua
git commit -m "feat(nvim): add LSP config, completion, and snippets"
```

---

### Task 6: Telescope fuzzy finder

**Files:**
- Create: `configs/nvim/lua/plugins/telescope.lua`

**Interfaces:**
- Consumes: nothing external (plenary + fzf-native are dependencies; fzf-native compiles via `make`).
- Produces: `<leader>ff` (files), `<leader>fg` (grep), `<leader>fb` (buffers), `<leader>fh` (help), `<leader>fr` (recent).

- [ ] **Step 1: Create `telescope.lua`**

```lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
```

- [ ] **Step 2: Verify syntax**

Run: `nvim --headless -u NONE -c "luafile configs/nvim/lua/plugins/telescope.lua" -c "qa"`
Expected: exit 0.

- [ ] **Step 3: Commit**

```bash
git add configs/nvim/lua/plugins/telescope.lua
git commit -m "feat(nvim): add telescope fuzzy finder"
```

---

### Task 7: Format & lint on save (conform + nvim-lint)

**Files:**
- Create: `configs/nvim/lua/plugins/formatting.lua`

**Interfaces:**
- Consumes: formatters/linters on PATH — nixpkgs-fmt, stylua (Task 1), ruff/clang-format/rustfmt (already in `dev-tools.nix`/`clang-tools`).
- Produces: format-on-save (conform) and lint-on-save (nvim-lint).

- [ ] **Step 1: Create `formatting.lua`**

```lua
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        nix = { "nixpkgs_fmt" },
        lua = { "stylua" },
        python = { "ruff_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        rust = { "rustfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
        c = { "clangtidy" },
        cpp = { "clangtidy" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
```

- [ ] **Step 2: Verify syntax**

Run: `nvim --headless -u NONE -c "luafile configs/nvim/lua/plugins/formatting.lua" -c "qa"`
Expected: exit 0.

- [ ] **Step 3: Commit**

```bash
git add configs/nvim/lua/plugins/formatting.lua
git commit -m "feat(nvim): add format/lint on save (conform + nvim-lint)"
```

---

### Task 8: Git + UI (gitsigns, lualine, bufferline, snacks)

**Files:**
- Create: `configs/nvim/lua/plugins/git.lua`
- Create: `configs/nvim/lua/plugins/ui.lua`

**Interfaces:**
- Consumes: `lazygit` on PATH (installed in `neovim.nix`), nvim-web-devicons (declared in ui.lua).
- Produces: gitsigns hunk keymaps, lualine/bufferline, snacks dashboard + lazygit launcher.

- [ ] **Step 1: Create `git.lua`**

```lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous hunk" })
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
      end,
    },
  },
}
```

- [ ] **Step 2: Create `ui.lua`**

```lua
return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
      },
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = { enabled = true },
      notifier = { enabled = true },
    },
    keys = {
      { "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
      { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git browse" },
    },
  },
}
```

- [ ] **Step 3: Verify syntax**

Run:
```bash
nvim --headless -u NONE -c "luafile configs/nvim/lua/plugins/git.lua" -c "qa"
nvim --headless -u NONE -c "luafile configs/nvim/lua/plugins/ui.lua" -c "qa"
```
Expected: both exit 0.

- [ ] **Step 4: Commit**

```bash
git add configs/nvim/lua/plugins/git.lua configs/nvim/lua/plugins/ui.lua
git commit -m "feat(nvim): add git integration and UI (gitsigns, lualine, bufferline, snacks)"
```

---

### Task 9: Full integration verification

**Files:** none (verification only).

**Interfaces:**
- Consumes: everything from Tasks 1-8.
- Produces: a working Neovim config; this is the acceptance gate.

- [ ] **Step 1: Activate the Nix changes**

Run: `sudo nixos-rebuild switch --flake .#aether` (or `just aether`)
Expected: switch succeeds; `stylua` and `tree-sitter` are now on `PATH`.

- [ ] **Step 2: Launch nvim headless to install all plugins**

Run: `nvim --headless "+Lazy! install" +qa`
Expected: exit 0. This clones lazy.nvim (if needed), installs all plugins, runs `telescope-fzf-native`'s `make`, and runs nvim-treesitter's `:TSUpdate` to compile parsers. Requires network (GitHub + grammar repos; CN/proxy caveat applies).

- [ ] **Step 3: Verify a clean startup**

Run: `nvim --headless -c "qa"`
Expected: exit 0, no error messages on stderr.

- [ ] **Step 4: Spot-check a real buffer**

Run: `nvim --headless -c "edit configs/nvim/init.lua" -c "lua print(vim.bo.filetype)" -c "sleep 2" -c "qa"`
Expected: prints `lua`, exit 0 (no crash from LSP/treesitter autocommands).

- [ ] **Step 5: Manual smoke test (interactive)**

Open `nvim` on a `.nix`, `.py`, `.rs`, and `.c` file and confirm: treesitter highlighting, LSP diagnostics (`:checkhealth lspconfig`), completion menu, `:Lazy` shows all plugins loaded, `:Dashboard` (or opening nvim with no file) shows the dashboard, `<leader>gg` opens lazygit, `:Lint`/format-on-save works.

- [ ] **Step 6: Commit any fixes**

If fixes were needed during verification, commit them:

```bash
git add -A configs/nvim
git commit -m "fix(nvim): address integration issues"
```
