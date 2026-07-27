local capabilities = require("cmp_nvim_lsp").default_capabilities()

local exists = function(name)
  local path = require("plenary.path")
  return path:new(vim.fn.getcwd() .. "/" .. name):exists()
end

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Local dev
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "monkeyc",
      --   callback = function(args)
      --     vim.lsp.start({
      --       name = "monkey-c-lsp",
      --       cmd = { "~/git/monkey-c-rs/target/release/monkey-c-lsp" },
      --       root_dir = vim.fs.root(args.buf, { "manifest.xml", ".git" }) or vim.fn.getcwd(),
      --       -- A raw `vim.lsp.start` doesn't inherit the `vim.lsp.config("*")`
      --       -- defaults, so wire the shared on_attach (format-on-save, keybinds)
      --       -- and completion capabilities explicitly.
      --       on_attach = on_attach,
      --       capabilities = capabilities,
      --     })
      --   end,
      -- })

      -- Non Mason LSP clients
      vim.lsp.enable("gleam")
      vim.lsp.enable("sourcekit")

      vim.lsp.config("*", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.config("ruff", {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
          settings = {
            fixAll = true,
            organizeImports = true,
          },
        },
      })

      local runtime, workspace = {}, {}

      -- Custom setup for Playdate development
      if exists("Source/main.lua") then
        runtime = { nonstandardSymbol = { "+=", "-=", "*=", "/=" } }
        workspace = {
          library = { os.getenv("HOME") .. "/Developer/PlaydateSDK/CoreLibs/" },
        }
      end

      vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = runtime,
            workspace = workspace,
            format = {
              enable = false,
              defaultConfig = {
                -- Indentation settings will not have any effect since the
                -- editors' settings have precedence.
                -- https://luals.github.io/wiki/formatter/#default-configuration
                --
                -- These settings are instead set and configured with `stylua`
                -- via `null_ls`.
                indent_style = "space",
                indent_size = "2",
                quote_style = "double",
                trailing_table_separator = "never",
                align_continuous_inline_comment = "true",
              },
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
    end,
  },
  --   garmin-monkeyc.nvim    - https://github.com/bombsimon/garmin-monkeyc.nvim
  {
    name = "garmin-monkeyc.nvim",
    dir = vim.fn.expand("~/git/garmin-monkeyc.nvim"),
    -- jungle/mss so their bundled syntax files load when those files are opened.
    ft = { "monkeyc", "jungle", "mss" },
    config = function()
      require("garmin-monkeyc").setup({
        on_attach = on_attach,
        capabilities = capabilities,
        developer_key = "~/.ciq/developer_key.der",
        type_check_level = "Strict",
      })
    end,
  },
  --   monkeyc-optimizer.nvim - https://github.com/bombsimon/monkeyc-optimizer.nvim
  {
    name = "monkeyc-optimizer.nvim",
    dir = vim.fn.expand("~/git/monkeyc-optimizer.nvim"),
    ft = "monkeyc",
    dependencies = { "garmin-monkeyc.nvim" },
    config = function()
      require("monkeyc-optimizer").setup({})
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {},
  },
  {
    "jayp0521/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
      "gbprod/none-ls-shellcheck.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "bash-language-server",
          "clang-format",
          "codelldb",
          "eslint-lsp",
          "gofumpt",
          "goimports",
          "gopls",
          "isort",
          "lua-language-server",
          "markdownlint",
          "prettier",
          "ruff",
          "shellcheck",
          "shfmt",
          "sql-formatter",
          "stylua",
          "ty",
          "yamllint",
        },
      })

      -- npm install -g prettier @markw65/prettier-plugin-monkeyc
      local monkeyc_plugin = vim.trim(vim.fn.system({ "npm", "root", "-g" }))
        .. "/@markw65/prettier-plugin-monkeyc/build/prettier-plugin-monkeyc.cjs"

      local null_ls = require("null-ls")
      null_ls.setup({
        debug = false,
        border = "rounded",
        on_attach = on_attach,
        sources = {
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.phpcs,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.diagnostics.golangci_lint.with({
            extra_args = { "--fast=false" },
          }),

          null_ls.builtins.formatting.clang_format.with({
            filetypes = { "c", "cs", "cpp", "objc", "objcpp" },
          }),
          null_ls.builtins.formatting.prettier.with({
            name = "prettier_monkeyc",
            extra_filetypes = { "monkeyc" },
            extra_args = { "--plugin", monkeyc_plugin },
          }),
          null_ls.builtins.formatting.sql_formatter,
          null_ls.builtins.formatting.phpcsfixer,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.formatting.shfmt.with({
            extra_args = { "-i 2" },
          }),
          null_ls.builtins.formatting.stylua.with({
            extra_args = {
              "--indent-type",
              "Spaces",
              "--indent-width",
              "2",
              "--quote-style",
              "AutoPreferDouble",
              "--preserve-block-newline-gaps",
              "Never",
            },
          }),

          require("none-ls-shellcheck.diagnostics"),
          require("none-ls-shellcheck.code_actions"),
        },
      })
    end,
  },
}
