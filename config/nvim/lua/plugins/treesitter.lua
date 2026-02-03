return {
  "nvim-treesitter/nvim-treesitter",
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
  end,
}
