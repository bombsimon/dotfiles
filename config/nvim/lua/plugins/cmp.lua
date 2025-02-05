return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-git",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },

    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          -- Limit the max width of the completion window
          format = function(_, vim_item)
            local function truncate(str, len)
              if not str then return end
              local truncated = vim.fn.strcharpart(str, 0, len)
              return truncated == str and str or truncated .. "..."
            end

            vim_item.menu = truncate(vim_item.menu, math.floor(0.25 * vim.o.columns))

            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-j>"] = cmp.mapping.select_next_item({ count = 5 }),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item({ count = 5 }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
        }),
        sources = cmp.config.sources(
          {
            { name = "nvim_lsp" },
            { name = "vsnip" },
          },
          {
            { name = "buffer" },
          }
        ),
      })
    end,
  },
}
