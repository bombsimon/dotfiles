local exists = function(name)
  local path = require("plenary.path")
  return path:new(vim.fn.getcwd() .. "/" .. name):exists()
end

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").gleam.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
      require("lspconfig").sourcekit.setup({
        on_attach = on_attach,
        capabilities = capabilities
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
    opts = {
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            on_attach = on_attach
          })
        end,
        ["pyright"] = function()
          require("lspconfig").pyright.setup({
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
        end,
        ["ruff"] = function()
          require("lspconfig").ruff.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            init_options = {
              settings = {
                fixAll = true,
                lineLength = 88,
                organizeImports = true,
              },
            }
          })
        end,
        ["lua_ls"] = function()
          local runtime, workspace = {}, {}

          -- Custom setup for Playdate development
          if exists("Source/main.lua") then
            runtime = { nonstandardSymbol = { "+=", "-=", "*=", "/=" } }
            workspace = {
              library = { os.getenv("HOME") .. "/Developer/PlaydateSDK/CoreLibs/" },
            }
          end

          require("lspconfig")["lua_ls"].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = runtime,
                workspace = workspace,
                format = {
                  enable = true,
                  defaultConfig = {
                    -- Indentation settings will not have
                    -- any effect since the editor's
                    -- settings have precedenceo.
                    -- https://luals.github.io/wiki/formatter/#default-configuration
                    indent_style = "space",
                    indent_size = "2",
                    quote_style = "double"
                  },
                },
                diagnostics = {
                  globals = { "vim" },
                },
              },
            }
          })
        end
      }
    }
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
          "golangci-lint",
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

          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.sql_formatter,
          null_ls.builtins.formatting.phpcsfixer,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.shfmt.with({
            extra_args = { "-i 2" },
          }),

          require("none-ls-shellcheck.diagnostics"),
          require("none-ls-shellcheck.code_actions"),
        },
      })
    end,
  }
}
