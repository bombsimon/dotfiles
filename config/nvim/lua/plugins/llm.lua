return {
  {
    "github/copilot.vim",
    config = function()
      -- Disable default Tab mapping to avoid conflict with nvim-cmp
      vim.g.copilot_no_tab_map = true

      -- Custom keybindings for Copilot
      vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)")
      vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)")

      -- disable copilot by default
      vim.g.copilot_enabled = false
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        acp = {
          -- npm install -g @zed-industries/claude-code-acp
          -- npm install -g @anthropic-ai/claude-code
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                -- ANTHROPIC_API_KEY for `antrophic` adapter
                CLAUDE_CODE_OAUTH_TOKEN = "cmd:op read 'op://Personal/Antrophic API key/credential'",
              },
            })
          end,
          -- npm i -g @openai/codex
          -- npm i -g @zed-industries/codex-acp
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chatgpt", -- "openai-api-key"|"codex-api-key"|"chatgpt"
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          adapter = "claude_code",
        },
        inline = {
          adapter = "copilot",
        },
        cmd = {
          adapter = "copilot",
        },
      },
      opts = {
        log_level = "INFO",
      },
    },
  },
}
