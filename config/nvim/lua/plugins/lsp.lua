local exists = function(name)
  local path = require("plenary.path")
  return path:new(vim.fn.getcwd() .. "/" .. name):exists()
end

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Non Mason LSP clients
      vim.lsp.enable("gleam")
      vim.lsp.enable("sourcekit")

      vim.lsp.config("*", {
        on_attach = on_attach,
        capabilities = capabilities
      })

      vim.lsp.config("ruff", {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
          settings = {
            fixAll = true,
            organizeImports = true,
          },
        }
      })

      vim.lsp.config("pyright", {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
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
        }
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {}
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {}
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
          "pyright",
          "ruff",
          "shellcheck",
          "shfmt",
          "sql-formatter",
          "stylua",
          "yamllint",
        },
      })

      null_ls = require("null-ls")
      null_ls.setup({
        debug = false,
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
          null_ls.builtins.formatting.prettier,
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
            },
          }),

          require("none-ls-shellcheck.diagnostics"),
          require("none-ls-shellcheck.code_actions"),
        },
      })
    end,
  }
}
