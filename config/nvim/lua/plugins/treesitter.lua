return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  config = function()
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
