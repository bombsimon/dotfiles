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
  use({ "echasnovski/mini.align" }) -- tabularize/align
  use({ "folke/which-key.nvim" }) -- help to show key bindings
  use({ "lewis6991/gitsigns.nvim" }) -- git tools
  use({ "ray-x/starry.nvim" }) -- colorscheme to use 'miranda_lighter"
  use({ "arcticicestudio/nord-vim" }) -- colorscheme 'nord'

  use({ "sheerun/vim-polyglot" }) -- language packs for all the things
  use({ "simrat39/rust-tools.nvim" }) -- rust improvement
  use({ "wbthomason/packer.nvim" }) -- packet manager for plugins

  use({
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
  }) -- copy remote url

  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
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
  use({ "williamboman/mason.nvim" }) -- simple to use language server installer
  use({ "neovim/nvim-lspconfig" }) -- enable LSP
  use({ "williamboman/mason-lspconfig.nvim" }) -- bridge between mason and lspconfig
  use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
  use({ "jayp0521/mason-null-ls.nvim" }) -- bridge between mason and null-ls

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

require("nvim-tree").setup({
  view = {
    mappings = {
      list = {
        { key = "q", action = "dir_up" },
      },
    },
  },
  tab = {
    sync = {
      open = true,
    },
  },
})

require("trouble").setup({
  mode = "workspace_diagnostics",
  auto_close = true,
  use_diagnostic_signs = true,
})

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
require("telescope").setup({
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
})
