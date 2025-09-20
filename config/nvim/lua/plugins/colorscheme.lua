return {
  {
    "catppuccin/nvim",
    name = "catppucin",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      flavour = "frappe",
      integrations = {
        bufferline = true
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.cmd.colorscheme "catppuccin"
    end,
  },
}
