-- TODO:
-- * Look into text objects: https://github.com/nvim-lua/kickstart.nvim/blob/f6d67b69c3/init.lua#L330-L363
-- * Setup DAP and friends: dap, dapui, dap-go
return {
  "nvim-tree/nvim-web-devicons",
  "nvim-lua/plenary.nvim",
  {
    "linux-cultist/venv-selector.nvim",
  },
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {}, -- required, even if empty
  },
  {
    -- issues with filetype detecting if not lazy loaded
    "sheerun/vim-polyglot",
    lazy = true,
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>",  mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.align").setup()
    end
  },
  {
    "stevearc/aerial.nvim",
    opts = {}
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    opts = {},
    event = "VeryLazy",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = function(_, opts)
      opts.options = {
        mode = "tabs",
        separator_style = "slant",
        show_close_icon = false,
        show_buffer_close_icons = false,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "left",
            separator = false,
          }
        },
      }

      if (vim.g.colors_name or ""):find("catppuccin") then
        -- https://github.com/catppuccin/nvim/issues/919
        opts.highlights = require("catppuccin.special.bufferline").get_theme()
      end
    end
  }

}
