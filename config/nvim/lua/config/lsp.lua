capabilities = require("cmp_nvim_lsp").default_capabilities()

local function setup_autocmds(_, bufnr)
  local au_group = vim.api.nvim_create_augroup("lsp_stuff" .. bufnr, { clear = true })

  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source.fixAll" } },
        async = false,
      })

      vim.lsp.buf.format({}, 5000)
    end,
    buffer = bufnr,
    group = au_group,
    desc = "Formatting",
  })

  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    callback = function()
      local notify = vim.notify
      vim.notify = function(_, _)
      end

      vim.lsp.buf.clear_references()
      vim.lsp.buf.document_highlight()
      vim.lsp.codelens.refresh()

      vim.notify = notify
    end,
    buffer = bufnr,
    group = au_group,
    desc = "LSP cursor",
  })

  vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
    callback = function()
      local notify = vim.notify
      vim.notify = function(_, _)
      end

      vim.lsp.buf.clear_references()

      vim.notify = notify
    end,
    group = au_group,
    buffer = bufnr,
    desc = "LSP cursor",
  })
end

local function setup_keybinds(_, bufnr)
  local opts = { noremap = true, buffer = bufnr }

  vim.keymap.set("n", "<C-e>", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]e", vim.diagnostic.goto_next, opts)

  vim.keymap.set("i", "<C-q>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<C-q>", vim.lsp.buf.hover, opts)
end

function on_attach(client, bufnr)
  setup_autocmds(client, bufnr)
  setup_keybinds(client, bufnr)
end
