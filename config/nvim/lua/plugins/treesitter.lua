return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  config = function()
    -- `.mc` -> monkeyc filetype detection comes from garmin-monkeyc.nvim
    -- Installed via https://github.com/bombsimon/tree-sitter-monkey-c
    vim.treesitter.language.register("monkey_c", { "monkeyc" })

    require("nvim-treesitter").install({
      "gleam",
      "go",
      "javascript",
      "json",
      "proto",
      "python",
      "rust",
      "toml",
      "yaml",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
