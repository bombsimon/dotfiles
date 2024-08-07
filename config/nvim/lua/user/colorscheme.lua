require("catppuccin").setup({
  flavour = "frappe"
})

vim.cmd.colorscheme "catppuccin"

-- Bufferline is setup here because it needs to be loaded not only after we load
-- `catppuccini` but after we switch colorscheme.
require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    mode = "tabs",
    separator_style = "slant",
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
