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
        "ruifm/gitlinker.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {}
    },
    {
        'echasnovski/mini.nvim',
        version = '*',
        config = function()
            require('mini.align').setup()
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
        branch = "regexp",
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
                opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
            end
        end
    }

}
