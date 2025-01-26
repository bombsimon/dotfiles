return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "s1n7ax/nvim-window-picker", -- window picker
    },
    config = function()
        require("window-picker").setup({
            hint = "floating-big-letter",
            picker_config = {
                floating_big_letter = {
                    font = 'ansi-shadow',
                }
            }
        })

        require("neo-tree").setup({
            close_if_last_window = true,
            position = "left",
            width = 40,
            window = {
                mappings = {
                    ["<cr>"] = "open_with_window_picker",
                },
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_hidden = false,
                    hide_gitignored = false,
                },
                -- toggle this feature
                -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1485#issuecomment-2164865976
                follow_current_file = {
                    enabled = true,
                },
            },
        })
    end
}
