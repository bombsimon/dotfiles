require("mason").setup()

local rust_tools = require("rust-tools")
local null_ls = require("null-ls")
local mason_null_ls = require("mason-null-ls")
local mason_lsp_config = require("mason-lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function setup_autocmds(_, bufnr)
  local au_group = vim.api.nvim_create_augroup("lsp_stuff" .. bufnr, { clear = true })

  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      pcall(function()
        vim.lsp.buf.format({}, 5000)
      end)
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
  vim.keymap.set("n", "<leader>q", rust_tools.hover_actions.hover_actions, opts)
end

local function on_attach(client, bufnr)
  setup_autocmds(client, bufnr)
  setup_keybinds(client, bufnr)
end

local servers = {
  pylsp = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {},
          maxLineLength = 80,
        },
      },
    },
  },
  rust_analyzer = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        allFeatures = true,
      },
      procMacro = {
        enable = true
      },
    },
  },
  sumneko_lua = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
  sumneko_lua_playdate = {
    Lua = {
      runtime = { nonstandardSymbol = { "+=", "-=", "*=", "/=" } },
      workspace = {
        library = { os.getenv("HOME") .. "/Developer/PlaydateSDK/CoreLibs/" },
      },
    },
  },
}

null_ls.setup({
  debug = false,
  on_attach = on_attach,
  sources = {
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.shfmt.with({
      extra_args = { "-i 2" },
    }),
    null_ls.builtins.formatting.trim_whitespace,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.sql_formatter,

    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.misspell,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.yamllint,

    null_ls.builtins.formatting.phpcsfixer,
    null_ls.builtins.diagnostics.phpcs,

    -- Python
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.ruff,
    null_ls.builtins.formatting.black.with({
      extra_args = { "--line-length=88" },
    }),
    null_ls.builtins.diagnostics.ruff,

    -- Go
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.diagnostics.golangci_lint.with({
      extra_args = { "--fast=false" },
    }),
  },
})

mason_null_ls.setup({
  ensure_installed = {
    "bash",
    "black",
    "clang-format",
    "codelldb",
    "eslint",
    "gofumpt",
    "goimports",
    "golangci-lint",
    "gopls",
    "isort",
    "jsonlint",
    "jq",
    "lua-language-server",
    "markdownlint",
    "misspell",
    "prettier",
    "pyright",
    "ruff",
    "rust-analyzer",
    "shellcheck",
    "shfmt",
    "stylua",
    "yamllint",
  },
})

local path = require("plenary.path")
local exists = function(name)
  return path:new(vim.fn.getcwd() .. "/" .. name):exists()
end

mason_lsp_config.setup()
mason_lsp_config.setup_handlers({
  function(server_name)
    local settings = servers[server_name]

    -- Load custom settings for Playdate projects
    if server_name == "sumneko_lua" and exists("Source/main.lua") then
      settings = servers["sumneko_lua_playdate"]
    end

    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = settings,
    })
  end,
})

local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.configurations.rust = {
  {
    type = 'rt_lldb',
    request = 'launch',
    name = 'Lauch executable',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/${workspaceFolderBasename}', 'file')
    end,
    cwd = '${workspaceFolder}',
    args = function()
      return vim.split(vim.fn.input('Args: ', ''), ' ')
    end
  }
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require('dap-go').setup({
  dap_configurations = {
    {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
  delve = {
    path = "dlv",
    initialize_timeout_sec = 20,
    port = "${port}",
    args = {},
    build_flags = "",
  },
})


local extension_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib' -- or .so for linux

rust_tools.setup({
  tools = {
    inlay_hints = {
      auto = true,
    },
    hover_actions = {
      auto_focus = true,
    },
  },
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = servers["rust_analyzer"],
  },
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
  },
})

vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  severity_sort = true,
  signs = true,
  float = {
    show_header = false,
    source = true,
    border = "rounded",
  },
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- https://github.com/neovim/neovim/pull/19677
-- https://vi.stackexchange.com/questions/39200/wrapping-comment-in-visual-mode-not-working-with-gq
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})
