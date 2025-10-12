require("config.lsp")

-- Manually install `rust-analyzer`
-- `rustup component add rust-analyzer`
return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  lazy = false, -- This plugin is already lazy
  init = function()
    vim.g.rustaceanvim = function()
      -- Original path
      local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb"

      local this_os = vim.uv.os_uname().sysname;

      -- The path is different on Windows
      if this_os:find "Windows" then
        codelldb_path = extension_path .. "adapter\\codelldb.exe"
        liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
      else
        -- The liblldb extension is .so for Linux and .dylib for MacOS
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
      end

      local cfg = require("rustaceanvim.config")

      return {
        tools = {
          rustc = {
            default_edition = "2024"
          }
        },
        server = {
          on_attach = on_attach,
          default_settings = {
            -- https://rust-analyzer.github.io/book/configuration.html
            ["rust-analyzer"] = {
              diagnostics = {
                enable = true,
                disabled = {},
                enableExperimental = true,
              },
              checkOnSave = true,
              cargo = {
                features = "all",
                allFeatures = true,
              },
              procMacro = {
                enable = true
              },
              cleanup = {
                unusedImports = true,
              },
            },
          },
        },
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end
  end
}
