local cmp = require("cmp")

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" }, -- For vsnip users.
  }, {
    { name = "buffer" },
  }),
  window = {},
  completion = {},
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-y>"] = cmp.mapping.scroll_docs(-4),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
})
