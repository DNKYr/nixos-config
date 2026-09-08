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
