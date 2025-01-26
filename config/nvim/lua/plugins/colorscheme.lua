return {
    {
        "catppuccin/nvim",
        name = "catppucin",
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {
            integrations = {
                -- add integration:
                -- TODO: Seems to always be enabled?
            },
        },
        config = function()
            require("catppuccin").setup({
                flavour = "frappe",
            })

            vim.cmd.colorscheme "catppuccin"
        end,
    },
}
