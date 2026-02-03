capabilities = require("cmp_nvim_lsp").default_capabilities()

local function setup_autocmds(client, bufnr)
  local au_group = vim.api.nvim_create_augroup("lsp_stuff" .. bufnr, { clear = true })

  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      -- Specific for Rust we want to run the code actions too because features
      -- like sorting imports are part of the LSP code action and not formatter.
      if client.supports_method("textDocument/codeAction") then
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { "source.fixAll" } },
          async = false,
        })
      end

      vim.lsp.buf.format({}, 5000)
    end,
    buffer = bufnr,
    group = au_group,
    desc = "Formatting",
  })

  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    callback = function()
      local notify = vim.notify
      vim.notify = function(_, _) end

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
      vim.notify = function(_, _) end

      vim.lsp.buf.clear_references()

      vim.notify = notify
    end,
    group = au_group,
    buffer = bufnr,
    desc = "LSP cursor",
  })
end

local function clean_pyright_markdown(contents)
  if type(contents) == "string" then
    contents = contents:gsub("&nbsp;", " ")
    contents = contents:gsub("&gt;", ">")
    contents = contents:gsub("&lt;", "<")
    contents = contents:gsub("\\_", "_")
  elseif type(contents) == "table" and contents.value then
    contents.value = clean_pyright_markdown(contents.value)
  end
  return contents
end

local function custom_hover()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "pyright" })
  if #clients > 0 then
    local params = vim.lsp.util.make_position_params(0, clients[1].offset_encoding)
    clients[1].request("textDocument/hover", params, function(err, result, ctx)
      vim.schedule(function()
        if result and result.contents then
          result.contents = clean_pyright_markdown(result.contents)
          vim.lsp.handlers.hover(err, result, ctx, { border = "rounded" })
        else
          vim.lsp.buf.hover()
        end
      end)
    end)
  else
    vim.lsp.buf.hover()
  end
end

local function setup_keybinds(_, bufnr)
  local opts = { noremap = true, buffer = bufnr }

  vim.keymap.set("n", "<C-e>", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]e", vim.diagnostic.goto_next, opts)

  vim.keymap.set("i", "<C-q>", function()
    vim.lsp.buf.signature_help({ border = "rounded" })
  end, opts)
  vim.keymap.set("n", "<C-q>", custom_hover, opts)
end

function on_attach(client, bufnr)
  setup_autocmds(client, bufnr)
  setup_keybinds(client, bufnr)
end
