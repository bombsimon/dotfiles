return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
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
  end
}
