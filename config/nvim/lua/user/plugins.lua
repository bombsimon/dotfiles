local fn = vim.fn

-- automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

packer.startup(function(use)
  use({ "echasnovski/mini.align" })          -- tabularize/align
  use({ "folke/which-key.nvim" })            -- help to show key bindings
  use({ "lewis6991/gitsigns.nvim" })         -- git tools
  use({ "ray-x/starry.nvim" })               -- colorscheme to use 'miranda_lighter"
  use({ "nvim-treesitter/nvim-treesitter" }) -- parser to help with colors etc
  use({ "catppuccin/nvim", as = "catppuccin" })


  use({
    'akinsho/bufferline.nvim',
    tag = "*",
    requires = 'nvim-tree/nvim-web-devicons',
  }) -- nice tabs


  use({ "sheerun/vim-polyglot" })           -- language packs for all the things
  use({ "simrat39/rust-tools.nvim" })       -- rust improvement
  use({ "wbthomason/packer.nvim" })         -- packet manager for plugins
  use({ "L3MON4D3/LuaSnip" })               -- snippets and such

  use({ "weilbith/nvim-code-action-menu" }) -- menu for code actions
  use({ "nvim-lua/plenary.nvim" })          -- Useful lua functions for nvim

  use({
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
  })                            -- DAP (Debugger) and UI
  use({ "leoluz/nvim-dap-go" }) -- Go DAP support

  use({
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
  })                                                      -- copy remote url

  use({ "nvim-telescope/telescope-live-grep-args.nvim" }) -- args plugin
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  }) -- fuzzy file finder and search

  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
  }) -- tree viewer

  use({
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
  }) -- diagnostics and error reporting

  use({
    'stevearc/aerial.nvim',
  }) -- work with symbols

  -- lsp
  use({ "williamboman/mason.nvim" })           -- simple to use language server installer
  use({ "neovim/nvim-lspconfig" })             -- enable LSP
  use({ "williamboman/mason-lspconfig.nvim" }) -- bridge between mason and lspconfig
  use({ "jose-elias-alvarez/null-ls.nvim" })   -- for formatters and linters
  use({ "jayp0521/mason-null-ls.nvim" })       -- bridge between mason and null-ls

  -- cmp - autocomplete
  use({ "hrsh7th/nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-path" })
  use({ "hrsh7th/cmp-vsnip" })
  use({ "hrsh7th/vim-vsnip" })

  -- Automatically set up your configuration after cloning packer.nvim
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

require("luasnip.loaders.from_vscode").lazy_load()
require("mini.align").setup()
require("gitlinker").setup()

require('aerial').setup({
  layout = {
    placement = "edge",
    default_direction = "prefer_right",
  },
  attach_mode = "global",
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end
})

require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 200,
  },
})

require("trouble").setup({
  mode = "workspace_diagnostics",
  auto_close = true,
  use_diagnostic_signs = true,
})

local actions = require("telescope.actions")
local trouble = require("trouble.sources.telescope")
local lga_actions = require("telescope-live-grep-args.actions")
require("telescope").setup({
  defaults = {
    dynamic_preview_title = true,
    prompt_prefix = "› ",
    selection_caret = "› ",
    mappings = {
      i = { ["<c-t>"] = trouble.open },
      n = { ["<c-t>"] = trouble.open },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      mappings = {
        -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
    }
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "go",
    "javascript",
    "json",
    "proto",
    "python",
    "rust",
    "toml",
    "yaml",
  },
  highlight = {
    enable = true,
  }
})

require("bufferline").setup({
  options = {
    mode = "tabs",
    separator_style = "padded_slant",
    show_close_icon = false,
    show_buffer_close_icons = false,
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = false,
      }
    },
  }
})
